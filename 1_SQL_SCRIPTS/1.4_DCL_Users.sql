-- Create Users 
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'secure_admin123';
CREATE USER 'Data_Entry'@'localhost' IDENTIFIED BY 'secure_data_entry123';
CREATE USER 'Reporter'@'localhost' IDENTIFIED BY 'secure_reporter123';

-- Grant Permissions

-- Admin: Full control
GRANT ALL PRIVILEGES ON Poverty_Alleviation_System.* TO 'Admin'@'localhost' WITH GRANT OPTION;

-- Data Entry: Can execute the SP and SELECT/INSERT into relevant tables
GRANT EXECUTE ON PROCEDURE SP_DisburseAssistance TO 'Data_Entry'@'localhost';
GRANT SELECT, INSERT ON AssistanceRecord TO 'Data_Entry'@'localhost';
GRANT SELECT ON Beneficiary TO 'Data_Entry'@'localhost';

-- Reporter: Read-Only access for reports
GRANT SELECT ON Beneficiary TO 'Reporter'@'localhost';
GRANT SELECT ON AssistanceRecord TO 'Reporter'@'localhost';
GRANT SELECT ON Program TO 'Reporter'@'localhost';
GRANT SELECT ON V_ProgramSummary TO 'Reporter'@'localhost';
GRANT SELECT ON V_TopBeneficiaries TO 'Reporter'@'localhost';

-- Apply Changes
FLUSH PRIVILEGES;