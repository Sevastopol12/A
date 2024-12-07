-- ALTER SESSION SET CURRENT_SCHEMA = mocnhien;
SET DEFINE OFF;
COMMIT;

--Employee
CREATE TABLE EMPLOYEE (
    EmployeeID INT,
    EmployeeName VARCHAR2(50) NOT NULL,
    Phone VARCHAR2(12),
    Birthday DATE,

    CONSTRAINT pk_emp PRIMARY KEY (EmployeeID)
);


-- BOAT
CREATE TABLE BOATS (
    BoatID INT,
    BoatType VARCHAR2(50) NOT NULL,
    BoatClass VARCHAR2(100),
    Make VARCHAR2(50),
    ProduceDate DATE NOT NULL,
    DryWeight_LB NUMBER,
    NumEngines NUMBER,
    Length_FT NUMBER,
    Price NUMBER,
    
    CONSTRAINT pk_BoatID PRIMARY KEY (BoatID)
)
PARTITION BY RANGE (ProduceDate)
INTERVAL (NUMTODSINTERVAL(365, 'DAY'))
SUBPARTITION BY LIST (BoatType)
SUBPARTITION TEMPLATE
(
    SUBPARTITION sp_power VALUES ('power'),
    SUBPARTITION sp_sail VALUES ('sail'),
    SUBPARTITION sp_unpowered VALUES ('unpowered')
)
(
    PARTITION p_2020 VALUES LESS THAN (TO_DATE('2021-01-01', 'YYYY-MM-DD'))
);


-- Sales
-- Date range from 2021-01-01 -> 2025-02-01
CREATE TABLE SALES (
    SaleID NUMBER,
    EmployeeID NUMBER NOT NULL,
    BoatID NUMBER NOT NULL,
    SaleDate DATE NOT NULL,
    Quantity NUMBER,
    TotalAmount NUMBER(10, 2),
    
    CONSTRAINT pk_sales PRIMARY KEY (SaleID),
    CONSTRAINT fk_sales FOREIGN KEY (BoatID) REFERENCES BOATS(BoatID)
)
PARTITION BY RANGE(SaleDate) 
(
    PARTITION p_2021 VALUES LESS THAN (TO_DATE('2022-01-01', 'YYYY-MM-DD')),
    PARTITION p_2022 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_CurrentYear VALUES LESS THAN (MAXVALUE)
);


--Boat inventory
CREATE TABLE INVENTORY (
    BoatID INT,
    QuantityInStock INT,

    CONSTRAINT fk_BoatID FOREIGN KEY (BoatID) REFERENCES BOATS(BoatID)
);


--After sales services
-- Date range from 2022-01-01 -> 2024-12-01
--ServiceType = ["Maintenance", "EngineRepair", "Customization", "ESR", "Winterization"] 
--Note: ESR = Electrical System Repair
CREATE TABLE Services (
    ServiceDate DATE NOT NULL,                        
    ServiceType VARCHAR2(100), 
    ServiceCost NUMBER(10, 2),                        
    WarrantyCovered VARCHAR2(3) CHECK (WarrantyCovered IN ('YES', 'NO'))   
)
PARTITION BY RANGE (ServiceDate) 
SUBPARTITION BY LIST(ServiceType) 
SUBPARTITION TEMPLATE
(
    SUBPARTITION sp_Maintenance VALUES ('Maintenance'),
    SUBPARTITION sp_EngineRepair VALUES ('EngineRepair'),
    SUBPARTITION sp_Customization VALUES ('Customization'),
    SUBPARTITION sp_ESR VALUES ('ESR'),
    SUBPARTITION sp_Winterization VALUES ('Winterization')
)
(
    PARTITION p_2021 VALUES LESS THAN (TO_DATE('2022-01-01', 'YYYY-MM-DD')),
    PARTITION p_2022 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION p_2023 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION p_CurrentYear VALUES LESS THAN (MAXVALUE)
);
COMMIT;



DROP TABLE BOATS;
DROP TABLE SALES;
DROP TABLE EMPLOYEE;
DROP TABLE SERVICES;
DROP TABLE INVENTORY;
COMMIT;



SELECT TABLE_NAME, PARTITION_NAME, subpartition_name, NUM_ROWS 
FROM USER_TAB_SUBPARTITIONS
WHERE TABLE_NAME IN ('BOATS', 'SALES', 'SERVICES');
