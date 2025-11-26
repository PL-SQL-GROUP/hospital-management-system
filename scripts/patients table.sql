CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    age NUMBER,
    gender VARCHAR2(10),
    admitted_status VARCHAR2(20) DEFAULT 'NOT ADMITTED' CHECK (admitted_status IN ('ADMITTED', 'NOT ADMITTED'))
);
