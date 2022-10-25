-- Question 1: tạo view có chứa danh sách nhân viên thuộc phòng ban 'Kỹ thuật'
CREATE OR REPLACE VIEW architec AS
SELECT a.FullName, a.accountID, d.DepartmentName FROM `Account` a
JOIN department d USING(departmentID)
WHERE  d.DepartmentName = 'Kỹ Thuật';

SELECT * FROM architec;

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
-- SubQuery


-- CTE 
WITH Dem AS(
select COUNT(1) sl from GroupAccount Group By AccountID
)
SELECT ga.AccountID, COUNT(GroupID) FROM groupaccount ga
JOIN `account` a USING (AccountID)
GROUP BY AccountID 
HAVING COUNT(ga.AccountID) = (SELECT MAX(sl) FROM Dem);

-- Question 3: tạo view có những câu hỏi có chứa câu hỏi và content quá dài > 10 kí tự và xóa đi
 CREATE OR REPLACE VIEW longchar AS
 SELECT * FROM question
 WHERE char_length(Content) > 10;
 
 SELECT * FROM longchar;
 DROP VIEW longchar;
 
 -- Question 4:  tạo view chứa danh sách các phòng ban có nhiều nhân viên nhất
 CREATE OR REPLACE VIEW EmployMax AS
 WITH Dem AS(
 SELECT COUNT(1) sl FROM `Account` GROUP BY DepartmentID
 )
 SELECT * FROM `account` a 
 JOIN department USING(DepartmentID)
 GROUP BY DepartmentID
 HAVING COUNT(a.DepartmentID) = (SELECT MAX(sl) FROM Dem);
 
 SELECT departmentID FROM EmployMax;
 
 -- Question 5: tạo view có chứa tất cả các câu hỏi do user họ nguyễn tạo
  CREATE OR REPLACE VIEW nguyen AS
  SELECT  q.CreatorID, q.QuestionID, q.Content FROM question q 
  JOIN `account` a ON (a.AccountID) = (q.CreatorID)
  WHERE substring_index(a.FullName,' ',1) = 'Kai';
  
  -- tạo procedure nhập tên nhân viên, hiển thị ra departmentID

  DROP PROCEDURE IF EXISTS in_name_return_depID;
  DELIMITER $$
  CREATE PROCEDURE in_name_return_depID(IN EName varchar(30), OUT depID TINYINT)
  BEGIN
	SELECT DepartmentID INTO depID FROM `Account` 
	WHERE FullName = EName;
  END$$
  DELIMITER ;
  
  SET @v_depID = 0;
  CALL in_name_return_depID('Mộc Cắc', @v_depID);
  SELECT @v_depID;
  
  -- question 4: tạo store để trả về id của typeQuestion có nhiều câu hỏi nhất

DROP PROCEDURE IF EXISTS Out_typeID_have_max_question;
DELIMITER $$ 
Create Procedure Out_typeID_have_max_question(OUT idtypeQ TINYINT)
BEGIN
	WITH TypeQuestionTab AS(
	  SELECT COUNT(1) SL FROM question GROUP BY TypeID
	)
	SELECT TypeID INTO idtypeQ FROM question 
	GROUP BY TypeID
	HAVING COUNT(1) = (SELECT MAX(SL) FROM TypequestionTab);
END $$
DELIMITER ;

SET @idtypeMax = 0;
CALL Out_typeID_have_max_question(@idtypeMax);
SELECT @idtypeMax;
