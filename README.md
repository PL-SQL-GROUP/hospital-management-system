# hospital-management-system

# Hospital Management PL/SQL Package

## Group Members
* Nkaka Ganza Ivo
* Lisa Ornella
* Ndayizeye Eugene

## 1. What was the question about?
The hospital management team required a database solution to streamline patient and doctor management. We were tasked with creating a **PL/SQL Package** that could:
1.  Store patient and doctor details.
2.  Handle **bulk data insertion** efficiently (processing multiple patients at once).
3.  Provide functions to display patient lists and track admission status.
4.  Update patient status to "ADMITTED".

## 2. How we solved it
We implemented a comprehensive PL/SQL package named `pkg_hospital_mgmt` using **Oracle Database**.

* **Data Structures:** We defined a custom collection type (`TYPE t_patient_tab`) to hold multiple patient records in memory.
* **Bulk Processing:** In the `bulk_load_patients` procedure, we used the `FORALL` statement. This allows high-performance bulk inserts, significantly faster than standard loops.
* **Encapsulation:** We grouped related logic (Admitting, Counting, Listing) into a single package for better code organization.
* **Data Retrieval:** We used `SYS_REFCURSOR` to allow the application to fetch and iterate through the patient list dynamically.

### Solution Code
Below is the complete SQL script, including table creation, package specification, and package body.

```sql
/* Hospital Management System
   Solution: PL/SQL Package with Bulk Processing
*/

-- 1. Database Setup (Tables)
DROP TABLE patients CASCADE CONSTRAINTS;
DROP TABLE doctors CASCADE CONSTRAINTS;

CREATE TABLE doctors (
    doctor_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    specialty VARCHAR2(100)
);

CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    age NUMBER,
    gender VARCHAR2(10),
    admitted_status VARCHAR2(20) DEFAULT 'NOT ADMITTED' CHECK (admitted_status IN ('ADMITTED', 'NOT ADMITTED'))
);

-- 2. Package Specification
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
```
## 3. Results (Screenshots)

### 1. Bulk Loading Test
We created a PL/SQL block to load 3 patients at once using the bulk procedure.

<img width="414" height="97" alt="test 1" src="https://github.com/user-attachments/assets/f383d679-b707-493f-8ab1-559d264840d7" />


### 2. Displaying Patients
We called the `show_all_patients` function to verify that the data was inserted.

<img width="382" height="128" alt="test 2" src="https://github.com/user-attachments/assets/c22cb833-f84b-48e8-8aae-28af967f650d" />

### 3. Admitting a Patient
We admitted a patient and verified the count updated using `count_admitted`.

<img width="473" height="175" alt="test 3" src="https://github.com/user-attachments/assets/25e38da1-144b-4cce-b1ff-15e412f67a90" />
