SET SERVEROUTPUT ON;

DECLARE
    v_emp_cursor SYS_REFCURSOR;
    v_rec patients%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Patient List ---');
    
    -- Get the cursor from the function
    v_emp_cursor := pkg_hospital_mgmt.show_all_patients;

    LOOP
        FETCH v_emp_cursor INTO v_rec;
        EXIT WHEN v_emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_rec.patient_id || 
                             ' | Name: ' || v_rec.name || 
                             ' | Status: ' || v_rec.admitted_status);
    END LOOP;
    
    CLOSE v_emp_cursor;
END;
/
