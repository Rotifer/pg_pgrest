DROP FUNCTION IF EXISTS lab_data.audit_trigger() CASCADE;
CREATE FUNCTION lab_data.audit_trigger()
RETURNS trigger AS $$
BEGIN
  IF NEW IS NOT DISTINCT FROM OLD THEN
    RETURN NEW;
  END IF;

  INSERT INTO audit.lab_data (
    table_name,
    action,
    account_name,
    old_data,
    new_data
  )
  VALUES (
    TG_TABLE_NAME,
    TG_OP,
    current_user,
    to_jsonb(OLD),
    to_jsonb(NEW)
  );
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

--DROP TRIGGER IF EXISTS trg_lab_data_audit ON lab_data.mice;
CREATE TRIGGER trg_lab_data_audit
AFTER UPDATE OR DELETE
ON lab_data.mice
FOR EACH ROW
EXECUTE FUNCTION lab_data.audit_trigger();
