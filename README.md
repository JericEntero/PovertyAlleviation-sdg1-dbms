✔ **SDG 1: No Poverty – RDBMS Project**

**1. Project Title and SDG Goal**

This project implements a Relational Database Management System (RDBMS) that manages beneficiaries, aid programs, and disbursements to support:
Sustainable Development Goal 1 — No Poverty.

**Problem Addressed:**

Aid organizations often use manual, inconsistent systems. This RDBMS ensures:
• accurate, centralized beneficiary data
• ACID‑compliant transactions for disbursements
• fast reporting for decision‑making
• secure user access with role‑based privileges


**2. Project Description**

This system (built in MySQL/MariaDB via phpMyAdmin) models key entities:

• Beneficiary
• Program
• AssistanceRecord

**✔ Core DBMS Concepts Used**

**DDL:** Primary/Foreign Keys, constraints, normalization

**DML:** Populating 50+ test records

**Stored Procedure:** Handles aid disbursement with eligibility checks

**Trigger:** Automatically updates TotalAidReceived

**Views:** Summary reports for management

**DCL:** Role‑based access (Data_Entry, Reporter)

**3. Installation / Setup (phpMyAdmin)**

Follow these steps to run the project:

✔ Create a new database

Example: sdg1_poverty_program

✔ Run the SQL scripts in this order:

1.1_DDL_Schema.sql → Creates tables + constraints

1.2_DML_TestData.sql → Inserts 50+ records

1.3_StoredLogic.sql → Stored Procedure, Trigger, Views

1.4_DCL_Users.sql → Creates system user roles

Done. Database is fully operational.

**NOTE:**

The folder 2_DEMO_INTERFACE contains only a note because this project uses pure SQL and does not generate external application files.

**4. Usage Instructions (Demonstration Guide)**

Below are the commands used during the demo to validate the functional requirements.

STORED PROCEDURE:

✔ Transaction Success Demonstration (FR3 – ACID)

CALL SP_DisburseAssistance(7, 5, NOW(), 500.00);

Shows successful INSERT + automatic UPDATE via trigger.

✔ Transaction Failure (Rollback)

CALL SP_DisburseAssistance(16, 3, NOW(), 500.00);

Should show a custom error and rollback the entire transaction.

TRIGGER:

✔ Trigger Demonstration (FR4 – Automation)

SELECT TotalAidReceived FROM Beneficiary WHERE BeneficiaryID = 7;

VIEWS: 

✔ Reporting View (FR5)

SELECT * FROM V_ProgramSummary;

SELECT * FROM V_TopBeneficiaries;

DCL:

✔ Security Test (FR6)

Example: Revoking a privilege

REVOKE EXECUTE ON PROCEDURE SP_DisburseAssistance FROM 'Data_Entry'@'localhost';

**5. Contributors**

The contributions of every member have been clearly outlined below.

**Jericho B. Busa**
Focus: Stored Procedure & ACID Transaction Logic

**Responsibilities:**

• Designed and implemented the main stored procedure enforcing ACID rules and beneficiary eligibility

• Created the transaction flowchart for FR3

• Wrote justification for stored procedures

**Files Contributed:**

• 1_SQL_SCRIPTS/1.3_StoredLogic.sql (Stored Procedure section)

• 3_DOCUMENTATION/Transaction_Flowchart.png

**Keanu Sean G. Gabuya**

Focus: Trigger & DML Test Data

**Responsibilities:**

• Implemented the automatic trigger for updating total aid

• Generated 50+ DML test data entries

• Ensured data consistency between tables

• Wrote justification for triggers

**Files Contributed:**

• 1_SQL_SCRIPTS/1.3_StoredLogic.sql (Trigger section)

• 1_SQL_SCRIPTS/1.2_DML_TestData.sql

**Angelyn Santos**

Focus: Reporting (Views) & Testing

**Responsibilities:**

• Designed complex reporting views for FR5

• Assisted in the testing of stored procedures and triggers

• Prepared documentation of results

• Helped finalize presentation materials

**Files Contributed:**

• 1_SQL_SCRIPTS/1.3_StoredLogic.sql (Views section)

**Jeric Jay M. Entero**

Focus: DDL, Schema & DCL Permissions

Responsibilities:

• Designed all database tables and constraints

• Created the final ERD diagrams

• Implemented DCL user permissions for FR6

• Wrote justification for schema design and integrity constraints

Files Contributed:

• 1_SQL_SCRIPTS/1.1_DDL_Schema.sql

• 1_SQL_SCRIPTS/1.4_DCL_Users.sql (DCL for permission control)

• 3_DOCUMENTATION/ERD_Final.pdf
