SET SERVEROUTPUT ON;

DECLARE
    v_patient_list pkg_hospital_mgmt.t_patient_tab := pkg_hospital_mgmt.t_patient_tab();
BEGIN
    -- Initialize the collection with 3 dummy patients
    v_patient_list.EXTEND(3);
    
    -- Patient 1
    v_patient_list(1).patient_id := 101;
    v_patient_list(1).name := 'John Doe';
    v_patient_list(1).age := 30;
    v_patient_list(1).gender := 'Male';
    v_patient_list(1).admitted_status := 'NOT ADMITTED';

    -- Patient 2
    v_patient_list(2).patient_id := 102;
    v_patient_list(2).name := 'Jane Smith';
    v_patient_list(2).age := 25;
    v_patient_list(2).gender := 'Female';
    v_patient_list(2).admitted_status := 'NOT ADMITTED';

    -- Patient 3
    v_patient_list(3).patient_id := 103;
    v_patient_list(3).name := 'Robert Brown';
    v_patient_list(3).age := 50;
    v_patient_list(3).gender := 'Male';
    v_patient_list(3).admitted_status := 'NOT ADMITTED';

    -- Call the bulk load procedure
    pkg_hospital_mgmt.bulk_load_patients(v_patient_list);
END;
/
