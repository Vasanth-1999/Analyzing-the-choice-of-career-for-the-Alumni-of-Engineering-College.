-- Q1
CREATE SCHEMA alumni;

-- Q2
USE alumni;
SELECT * FROM college_a_hs;  # 1157 rows
SELECT * FROM college_a_se;  # 724 rows
SELECT * FROM college_a_sj;  # 4006 rows
SELECT * FROM college_b_hs;	 # 199 rows
SELECT * FROM college_b_se;  # 201 rows
SELECT * FROM college_b_sj;  # 1859 rows

-- Q3
DESC college_a_hs;  # 1157 rows only
DESC college_a_se;  # 724 rows only
DESC college_a_sj;  # 4006 rows only
DESC college_b_hs;  # 199 rows only
DESC college_b_se;  # 201 rows only
DESC college_b_sj;  # 1859 rows only

-- Q4 in Project 2.Q4.ipynb file

-- Q5 in Project 2.Q5.xlsx file

-- Q6
CREATE VIEW college_a_hs_v AS SELECT * FROM college_a_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_a_hs_v;

-- Q7
CREATE VIEW college_a_se_v AS SELECT * FROM college_a_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_a_se_v;

-- Q8
CREATE VIEW college_a_sj_v AS SELECT * FROM college_a_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_a_sj_v;

-- Q9
CREATE VIEW college_b_hs_v AS SELECT * FROM college_b_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_b_hs_v;

-- Q10
CREATE VIEW college_b_se_v AS SELECT * FROM college_b_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NULL AND FatherName IS NOT NULL OR MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_b_se_v;

-- Q11
CREATE VIEW college_b_sj_v AS SELECT * FROM college_b_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL;
SELECT * FROM college_b_sj_v;

-- Q12
DELIMITER <>
CREATE PROCEDURE converts()
BEGIN
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_a_hs_v;
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_a_se_v;
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_a_sj_v;
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_b_hs_v;
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_b_se_v;
SELECT LOWER(Name) Name, LOWER(FatherName) FatherName, LOWER(MotherName) MotherName FROM college_b_sj_v;
END <>
DELIMITER ;

CALL converts;

-- Q13 in Project 2.Q13.xlsx file

-- Q14
DELIMITER !!
DROP PROCEDURE IF EXISTS get_name_collegeA;
CREATE PROCEDURE get_name_collegeA(INOUT Aname VARCHAR(16000))
BEGIN
DECLARE finished INT DEFAULT 0;
DECLARE Anamelist VARCHAR(400) DEFAULT "";

DECLARE Anamedetail CURSOR FOR SELECT Name FROM college_a_se_v;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN Anamedetail;
getAname:
LOOP
FETCH Anamedetail INTO Anamelist;
IF finished = 1 THEN
LEAVE getAname;
END IF;

SET Aname = CONCAT(Anamelist, ":", Aname);
END LOOP getAname;

CLOSE Anamedetail;
END !!
DELIMITER ;

-- CALL PROCEDURE
SET @Aname = "";
CALL get_name_collegeA(@Aname);
SELECT @Aname Aname;

-- Q15
DELIMITER ??
DROP PROCEDURE IF EXISTS get_name_collegeB;
CREATE PROCEDURE get_name_collegeB(INOUT Bname VARCHAR(16000))
BEGIN
DECLARE finished INT DEFAULT 0;
DECLARE Bnamelist VARCHAR(400) DEFAULT "";

DECLARE Bnamedetail CURSOR FOR SELECT Name FROM college_b_se_v;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

OPEN Bnamedetail;
getBname:
LOOP
FETCH Bnamedetail INTO Bnamelist;
IF finished = 1 THEN
LEAVE getBname;
END IF;

SET Bname = CONCAT(Bnamelist, ":", Bname);
END LOOP getBname;

CLOSE Bnamedetail;
END ??
DELIMITER ;

-- CALL PROCEDURE
SET @Bname = "";
CALL get_name_collegeB(@Bname);
SELECT @Bname Bname;


-- Q16 Sorry for the wrong percentage
SELECT "Higher Studies" PresentStatus,(COUNT(ahs.RollNo) /(ahs.RollNo))*100 College_A_Persentage,(COUNT(bhs.RollNo)/(bhs.RollNo))*100 College_B_Persentage   FROM college_a_hs ahs CROSS JOIN college_b_hs bhs UNION 
SELECT "Self Empolyment" PresentStatus,(COUNT(ase.RollNo) /(ase.RollNo))*100 College_A_Persentage,(COUNT(bse.RollNo)/(bse.RollNo))*100 College_B_Persentage   FROM college_a_se ase CROSS JOIN college_b_se bse UNION
SELECT "Service Job" PresentStatus,(COUNT(asj.RollNo) /(asj.RollNo))*100 College_A_Persentage,(COUNT(bsj.RollNo)/(bsj.RollNo))*100 College_B_Persentage    FROM college_a_sj asj CROSS JOIN college_b_sj bsj;