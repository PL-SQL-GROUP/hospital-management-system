SET SERVEROUTPUT ON;

DECLARE
    v_count NUMBER;
BEGIN
    -- 1. Check initial count
    v_count := pkg_hospital_mgmt.count_admitted();
    DBMS_OUTPUT.PUT_LINE('Initial Admitted Count: ' || v_count);

    -- 2. Admit Patient 102
    pkg_hospital_mgmt.admit_patient(102);

    -- 3. Check count again to verify update
    v_count := pkg_hospital_mgmt.count_admitted();
    DBMS_OUTPUT.PUT_LINE('New Admitted Count: ' || v_count);
END;
/
