DROP USER data_pioneers CASCADE;

-- Create user with a secure password
CREATE USER data_pioneers IDENTIFIED BY "Pass@123456789";

-- Grant essential privileges
GRANT CONNECT, RESOURCE TO data_pioneers;
GRANT CREATE SESSION TO data_pioneers;
GRANT CREATE TABLE TO data_pioneers;
GRANT CREATE VIEW TO data_pioneers;
GRANT CREATE SEQUENCE TO data_pioneers;
GRANT CREATE PROCEDURE TO data_pioneers;
GRANT CREATE TRIGGER TO data_pioneers;

-- Assign unlimited quota on USERS tablespace
ALTER USER data_pioneers QUOTA UNLIMITED ON USERS;






