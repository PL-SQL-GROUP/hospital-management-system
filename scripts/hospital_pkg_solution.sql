CREATE OR REPLACE PACKAGE pkg_hospital_mgmt AS
    -- Collection type for bulk processing
    TYPE t_patient_tab IS TABLE OF patients%ROWTYPE;

    PROCEDURE bulk_load_patients(p_patients IN t_patient_tab);
    FUNCTION show_all_patients RETURN SYS_REFCURSOR;
    FUNCTION count_admitted RETURN NUMBER;
    PROCEDURE admit_patient(p_patient_id IN NUMBER);
END pkg_hospital_mgmt;
/

-- 3. Package Body
CREATE OR REPLACE PACKAGE BODY pkg_hospital_mgmt AS

    -- Bulk Load Implementation
    PROCEDURE bulk_load_patients(p_patients IN t_patient_tab) IS
    BEGIN
        -- FORALL performs the insert in a single context switch (High Performance)
        FORALL i IN 1 .. p_patients.COUNT
            INSERT INTO patients VALUES p_patients(i);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Bulk load completed. ' || SQL%ROWCOUNT || ' patients inserted.');
    END bulk_load_patients;

    -- Show All Patients Implementation
    FUNCTION show_all_patients RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR SELECT * FROM patients ORDER BY patient_id;
        RETURN v_cursor;
    END show_all_patients;

    -- Count Admitted Implementation
    FUNCTION count_admitted RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM patients WHERE admitted_status = 'ADMITTED';
        RETURN v_count;
    END count_admitted;

    -- Admit Patient Implementation
    PROCEDURE admit_patient(p_patient_id IN NUMBER) IS
    BEGIN
        UPDATE patients 
        SET admitted_status = 'ADMITTED'
        WHERE patient_id = p_patient_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Patient ID ' || p_patient_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Patient ID ' || p_patient_id || ' successfully admitted.');
        END IF;
    END admit_patient;

END pkg_hospital_mgmt;
/
