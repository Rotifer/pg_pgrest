DROP FUNCTION IF EXISTS pgrest.get_all_mice_table;
CREATE FUNCTION pgrest.get_all_mice_table()
RETURNS TABLE(mouse_id TEXT, sex CHAR, strain TEXT, dob DATE)
AS
$$
SELECT *
FROM
  lab_data.mice;
$$
LANGUAGE SQL
STABLE
SECURITY DEFINER;
COMMENT ON FUNCTION pgrest.get_all_mice_table IS $$
Return all the rows in the "lab_data.mice" tablle.
cURL example call:  curl http://127.0.0.0:8080/rpc/get_all_mice_table
$$;

DROP FUNCTION IF EXISTS pgrest.get_mouse_weight_data(INT);
CREATE FUNCTION pgrest.get_mouse_weight_data(p_mouse_id INT)
RETURNS TABLE(week INT, weigh_date DATE, glucose NUMERIC, weight NUMERIC)
AS
$$
SELECT
  week,
  weigh_date,
  glucose,
  weight
FROM
  lab_data.mouse_weights
WHERE
  mouse_id = p_mouse_id;
$$
LANGUAGE SQL
STABLE
SECURITY DEFINER;
COMMENT ON FUNCTION pgrest.get_mouse_weight_data(INT) IS $$
Return weight details for a given mouse ID.
cURL example call:  curl http://127.0.0.0:8080/rpc/get_mouse_weight_data?3005
$$;

DROP FUNCTION IF EXISTS pgrest.get_mouse_ids();
CREATE FUNCTION pgrest.get_mouse_ids()
RETURNS TABLE(mouse_id INT)
AS
$$
SELECT
  mouse_id
FROM
  lab_data.mice;
$$
LANGUAGE SQL
STABLE
SECURITY DEFINER;
COMMENT ON FUNCTION pgrest.get_mouse_ids IS $$
Return a list of all registered mice.
cURL example call:  http://127.0.0.0:8080/rpc/get_mouse_ids
$$;


--
DROP FUNCTION IF EXISTS pgrest.get_weights_for_mouse_list(INT[]);
CREATE FUNCTION pgrest.get_weights_for_mouse_list(p_mouse_ids INT[])
RETURNS TABLE(mouse_id INT,
              week INT,
              weigh_date DATE,
              glucose NUMERIC,
              weight NUMERIC,
              dob DATE,
              strain TEXT)
AS
$$
SELECT
  mw.mouse_id,
  mw.week,
  mw.weigh_date,
  mw.glucose,
  mw.weight,
  m.dob,
  m.strain
FROM
  lab_data.mouse_weights mw
JOIN
  lab_data.mice m
  ON
    mw.mouse_id = m.mouse_id
WHERE
  mw.mouse_id IN(SELECT UNNEST(p_mouse_ids));
$$
LANGUAGE SQL
STABLE
SECURITY DEFINER;
COMMENT ON FUNCTION pgrest.get_weights_for_mouse_list(INT[]) IS $$
Return all weight data for an array of mouse IDs and add mouse date of birth and strain.
cURL example call:
curl -X POST http://127.0.0.1:8080/rpc/get_weights_for_mouse_list \
  -H "Content-Type: application/json" \
  -d '{
    "p_mouse_ids": [3005, 3017]
  }'
$$;


DROP FUNCTION IF EXISTS pgrest.register_update_mouse(INT, CHAR, TEXT, DATE);
CREATE FUNCTION pgrest.register_update_mouse(p_mouse_id INT, p_sex CHAR, p_strain TEXT, p_dob DATE)
RETURNS JSONB
AS
$$
DECLARE
  l_result JSONB;
BEGIN
MERGE INTO lab_data.mice m
USING (
  SELECT p_mouse_id AS mouse_id, p_sex AS sex, p_strain AS strain, p_dob AS DOB
) s
ON (m.mouse_id = s.mouse_id)
WHEN MATCHED THEN
  UPDATE SET
    sex = s.sex,
    strain = s.strain,
    dob = s.dob
WHEN NOT MATCHED THEN
  INSERT (mouse_id, sex, strain, dob)
  VALUES (s.mouse_id, s.sex, s.strain, s.dob);
  l_result := '{"status": "complete"}'::JSONB;
  RETURN l_result;
END;
$$
LANGUAGE PLPGSQL
VOLATILE
SECURITY DEFINER;
COMMENT ON FUNCTION pgrest.register_update_mouse(INT, CHAR, TEXT, DATE) IS $$
Register a new mouse or update an existing mouse record.
Example Call:
SELECT *
FROM
pgrest.register_update_mouse(p_mouse_id => 4000, p_sex => 'M', p_strain => 'C57BL/6J', p_dob => '2008-10-31');
cURL Example Call:
curl -X POST http://127.0.0.1:8080/rpc/register_update_mouse \
  -H "Content-Type: application/json" \
  -d '{
        "p_mouse_id": 4031,
        "p_sex": "M",
        "p_strain": "FVB/NJ",
        "p_dob": "2009-01-09"
      }'
$$;



