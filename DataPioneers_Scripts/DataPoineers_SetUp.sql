-- Drop users if they already exist
BEGIN
    EXECUTE IMMEDIATE 'DROP USER data_pioneers_admin CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP USER data_pioneers CASCADE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -01918 THEN RAISE; END IF;
END;
/

-- Create ADMIN user with full access
CREATE USER data_pioneers_admin IDENTIFIED BY "Admin@123456789";
GRANT CONNECT, RESOURCE TO data_pioneers_admin;
GRANT CREATE SESSION TO data_pioneers_admin;
GRANT CREATE TABLE TO data_pioneers_admin;
GRANT CREATE VIEW TO data_pioneers_admin;
GRANT CREATE SEQUENCE TO data_pioneers_admin;
GRANT CREATE PROCEDURE TO data_pioneers_admin;
GRANT CREATE TRIGGER TO data_pioneers_admin;
GRANT CREATE TYPE TO data_pioneers_admin;
GRANT CREATE SYNONYM TO data_pioneers_admin;
GRANT UNLIMITED TABLESPACE TO data_pioneers_admin;
ALTER USER data_pioneers_admin QUOTA UNLIMITED ON USERS;

-- Create USER with read-only access
CREATE USER data_pioneers IDENTIFIED BY "User@123456789";
GRANT CONNECT TO data_pioneers;


