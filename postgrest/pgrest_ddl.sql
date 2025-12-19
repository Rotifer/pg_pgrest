DROP SCHEMA IF EXISTS lab_data CASCADE;
CREATE SCHEMA IF NOT EXISTS lab_data;
COMMENT ON SCHEMA lab_data IS 'Contains all the data tables and views used by the pgrest';

CREATE TABLE IF NOT EXISTS lab_data.mice(
  mouse_id INT PRIMARY KEY,
  sex CHAR(1) CHECK(sex IN('M', 'F')),
  strain TEXT,
  dob DATE
);
COMMENT ON TABLE lab_data.mice IS 'Stores data on individual mice.';


CREATE TABLE IF NOT EXISTS lab_data.mouse_weights(
  mouse_weight_id SERIAL PRIMARY KEY,
  mouse_id INT,
  week INT,
  weigh_date DATE,
  glucose NUMERIC,
  weight NUMERIC,
  FOREIGN KEY(mouse_id) REFERENCES lab_data.mice(mouse_id)
);
COMMENT ON TABLE lab_data.mouse_weights IS 'Stores data on indivual mouse weighings.';

-- Populate the mice table.
INSERT INTO lab_data.mice(mouse_id, sex, strain, dob) VALUES
(3005, 'M', 'BALB/c', '2007-02-28'),
(3017, 'M', 'BALB/c', '2006-09-06'),
(3434, 'F', 'BALB/c', '2006-10-22'),
(3449, 'M', 'BALB/c', '2006-12-05'),
(3499, 'F', 'BALB/c', '2006-12-05');

-- Populate the lab_data.mouse_weights table.
INSERT INTO lab_data.mouse_weights(mouse_weight_id, mouse_id, week, weigh_date, glucose, weight) VALUES
(1, 3005, 4, '2007-03-30', 19.3, 635.0),
(2, 3005, 6, '2007-04-11', 31.0, 460.7),
(3, 3005, 8, '2007-04-27', 39.6, 530.2),
(4, 3017, 4, '2006-10-06', 25.9, 202.4),
(5, 3017, 6, '2006-10-19', 45.1, 384.7),
(6, 3017, 8, '2006-11-03', 57.2, 458.7),
(7, 3434, 4, '2006-11-22', 26.6, 238.9),
(8, 3434, 6, '2006-12-06', 45.9, 378.0),
(9, 3434, 8, '2006-12-22', 56.2, 409.8),
(10, 3449, 4, '2007-01-05', 27.5, 121.0),
(11, 3449, 6, '2007-01-19', 42.9, 191.3),
(12, 3449, 8, '2007-02-02', 56.7, 182.5),
(13, 3499, 4, '2007-01-05', 19.8, 220.2),
(14, 3499, 6, '2007-01-19', 36.6, 556.9),
(15, 3499, 8, '2007-02-02', 43.6, 446.0);

/*
Not needed for such a small data set but it is good practice to index foreign keys in
PostgreSQL as it does not create them by default.
*/
CREATE INDEX ON lab_data.mouse_weights(mouse_id);


-- Audit section

CREATE SCHEMA IF NOT EXISTS audit;
COMMENT ON SCHEMA audit IS 'Tracks updates and deletes of tables in the "lab_data"';

DROP TABLE IF EXISTS audit.lab_data;
CREATE TABLE audit.lab_data (
  audit_id SERIAL PRIMARY KEY,
  table_name TEXT,
  action TEXT,
  account_name TEXT,
  old_data JSONB,
  new_data JSONB,
  changed_at TIMESTAMPTZ DEFAULT now()
);
COMMENT ON TABLE audit.lab_data IS 'Records details of UPDATEs and DELETEs performed on tables in the "lab_data_schema".';

