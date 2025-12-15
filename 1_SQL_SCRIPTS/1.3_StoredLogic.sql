-- CREATE TRIGGER (T_UpdateTotalAid)
DELIMITER $$
CREATE TRIGGER T_UpdateTotalAid
AFTER INSERT ON AssistanceRecord
FOR EACH ROW
BEGIN
    -- Update the TotalAidReceived in the Beneficiary table
    UPDATE Beneficiary
    SET TotalAidReceived = TotalAidReceived + NEW.AmountGiven
    WHERE BeneficiaryID = NEW.BeneficiaryID;
END$$
DELIMITER ;

-- CREATE PROCEDURE (SP_DisburseAssistance)
DELIMITER $$
CREATE PROCEDURE SP_DisburseAssistance (
    IN p_BeneficiaryID INT,
    IN p_ProgramID INT,
    IN p_DistributionDate DATE,
    IN p_AmountGiven DECIMAL(10, 2)
)
BEGIN
    DECLARE v_Income DECIMAL(10, 2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handling: If anything fails, rollback the entire transaction
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed due to system error.';
    END;

    -- 1. BEGIN TRANSACTION
    START TRANSACTION;

    -- 2. Consistency Check (Example: Only disburse to those with annual income <= 25000)
    SELECT AnnualIncome INTO v_Income
    FROM Beneficiary
    WHERE BeneficiaryID = p_BeneficiaryID;

    IF v_Income > 25000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Beneficiary is ineligible: Annual income exceeds P25,000 threshold.';
        ROLLBACK;
    ELSE
        -- 3. Atomicity: Insert the new record
        INSERT INTO AssistanceRecord (BeneficiaryID, ProgramID, DistributionDate, AmountGiven)
        VALUES (p_BeneficiaryID, p_ProgramID, p_DistributionDate, p_AmountGiven);

        -- The Trigger (T_UpdateTotalAid) executes automatically here.

        -- 4. COMMIT the transaction
        COMMIT;
    END IF;
END$$
DELIMITER ;

-- CREATE VIEW 1 (V_ProgramSummary)
-- Report 1: Total aid given per program, including the program's category.
CREATE VIEW V_ProgramSummary AS
SELECT
    p.ProgramName,
    p.ProgramCategory,
    COUNT(ar.AssistanceID) AS TotalDisbursements,
    SUM(ar.AmountGiven) AS TotalAidDisbursed
FROM
    Program p
JOIN
    AssistanceRecord ar ON p.ProgramID = ar.ProgramID
GROUP BY
    p.ProgramID, p.ProgramName, p.ProgramCategory
ORDER BY
    TotalAidDisbursed DESC;


-- CREATE VIEW 2 (V_TopBeneficiaries)
-- Report 2: List of beneficiaries who received the highest aid, including their demographic and income details.
CREATE VIEW V_TopBeneficiaries AS
SELECT
    b.FullName,
    b.City,
    b.HouseholdSize,
    b.AnnualIncome,
    b.TotalAidReceived
FROM
    Beneficiary b
ORDER BY
    b.TotalAidReceived DESC
LIMIT 10;