-- 1. Program Table (Reference Table)
CREATE TABLE Program (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramName VARCHAR(100) NOT NULL UNIQUE,
    -- ENUM constraint ensures data integrity for category type
    ProgramCategory ENUM('Cash Aid', 'Livelihood', 'Food', 'Health') NOT NULL, 
    Description TEXT,
    CHECK (LENGTH(ProgramName) > 5) 
);

-- 2. Beneficiary Table (Core Entity - Focus for Normalization/Trigger)
CREATE TABLE Beneficiary (
    BeneficiaryID INT PRIMARY KEY AUTO_INCREMENT,
    ID_Number VARCHAR(20) UNIQUE NOT NULL, -- Unique constraint prevents duplicate registration (FR5)
    FullName VARCHAR(150) NOT NULL,
    
    -- Added: DateOfBirth for accurate age calculation and eligibility checks
    DateOfBirth DATE NOT NULL,
    
    HouseholdSize INT NOT NULL,
    AnnualIncome DECIMAL(10, 2) NOT NULL,
    City VARCHAR(50) NOT NULL,
    
    -- System-managed column updated by the TRIGGER (TotalAidReceived)
    TotalAidReceived DECIMAL(10, 2) DEFAULT 0.00,  
    
    -- System-managed column for auditing (RegistrationDate)
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    
    -- CHECK constraints enforce valid input (FR2)
    CHECK (AnnualIncome >= 0),
    CHECK (HouseholdSize >= 1) 
);

-- 3. AssistanceRecord Table (Junction/Transaction Table - Focus for M:N & ACID)
-- This implements the Complex Many-to-Many Relationship between Beneficiary and Program.
CREATE TABLE AssistanceRecord (
    AssistanceID INT PRIMARY KEY AUTO_INCREMENT,
    BeneficiaryID INT NOT NULL,
    ProgramID INT NOT NULL,
    DistributionDate DATE NOT NULL,
    AmountGiven DECIMAL(10, 2) NOT NULL,
    
    -- Mandatory Constraint: Ensure assistance is positive (FR2)
    CHECK (AmountGiven > 0.00),

    -- Foreign Keys enforce referential integrity (FR2 & Midterm Concept)
    FOREIGN KEY (BeneficiaryID) REFERENCES Beneficiary(BeneficiaryID) ON DELETE CASCADE,
    FOREIGN KEY (ProgramID) REFERENCES Program(ProgramID) ON DELETE RESTRICT,
    
    -- Index for faster joins in complex reports (FR5)
    INDEX (BeneficiaryID, ProgramID) 
);

