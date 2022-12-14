-- tạo database quản lý điểm của các học viên VTI_mark_managerment
DROP DATABASE IF EXISTS VTI_MARK_MANAGERMENT;
CREATE DATABASE VTI_MARK_MANAGERMENT;

-- tạo bảng Trainee có TraineeID là primary key , First_Name, Last_Name, Age, Gender
USE VTI_MARK_MANAGERMENT;
DROP TABLE IF EXISTS Trainee;
CREATE TABLE Trainee(
     TraineeID  SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
     First_Name VARCHAR(10) NOT NULL,
     Last_Name  VARCHAR(20) NOT NULL,
     Age        TINYINT UNSIGNED NOT NULL,
     Gender     ENUM('Male','FeMale','Unknow')
);

-- tạo bảng Subject có các trường SubjectID, SubjectName
DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject`(
     SubjectID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
     SubjectName VARCHAR(30) UNIQUE NOT NULL
);

-- tạo bảng Trainee_Subject có các trường TraineeID, SubjectID, Mark, Exam_Day
DROP TABLE IF EXISTS Trainee_Subject;
CREATE TABLE Trainee_Subject(
     TraineeID  TINYINT UNSIGNED,
     SubjectID  TINYINT UNSIGNED,
     Mark       FLOAT UNSIGNED,
     Exam_Day   DATETIME DEFAULT NOW(),
     PRIMARY KEY(TraineeID, SubjectID),
     FOREIGN KEY(TraineeID) REFERENCES Trainee(TraineeID),
     FOREIGN KEY(SubjectID) REFERENCES `Subject`(SubjectID)
);
-- --------------------------------------------------------------------------------------
-- question
-- 1. tạo table với các ràng buộc và kiểu dữ liệu
--  thêm ít nhất 3 bản ghi vào mỗi table
INSERT INTO trainee(First_Name, Last_Name,  Age, Gender )
VALUES             ('Chu',     'Văn Mộc',    25,  'Male'  ),
				   ('Trần',    'Mộng Cắc',   25,  'Male'  ),
                   ('Đỗ  ',    'Xuân Thanh', 24,  'FeMale');
				
INSERT INTO `Subject`(SubjectName )
VALUES               ('MySQL'),
                     ('JavaCore'),
                     ('FrontEnd Basic'),
                     ('SpringFrameWork'),
                     ('FrontEnd Advance'),
                     ('Mock Project'),
                     ('NodeJS'),
                     ('PHP');
			
INSERT INTO trainee_subject(Trainee_ID, Subject_ID, Mark, Exam_Day)
VALUES                     (1,         1,         9.5,  '2022-08-02'),
                           (1,         2,         7.5,  '2022-10-02'),
                           (1,         3,         8.5,  '2022-09-02'),
                           (1,         4,         6.5,  '2022-11-02'),
                           (2,         1,         5.5,  '2022-08-02'),
                           (2,         2,         6.5,  '2022-10-02'),
                           (2,         3,         7.5,  '2022-09-02'),
                           (3,         1,         8.5,  '2022-08-02'),
                           (3,         6,         7.5,  '2022-07-02');

-- --------------------------------------------------------------------------------------
-- 2. viết lệnh để:
-- a) lấy tất cả các môn học không có bất kì điểm nào
-- lấy ra danh sách các môn ko xuất hiện trong bảng Trainee_Subject
SELECT s.Subject_Name, s.Subject_ID FROM trainee_subject ts
RIGHT JOIN `subject` s ON ts.Subject_ID = s.Subject_ID 
WHERE ts.Subject_ID IS NULL
UNION
-- lấy ra các môn có trong bản Trainee_Subject nhưng ko có dữ liệu ghi về điểm
SELECT s.Subject_Name, s.Subject_ID FROM trainee_subject ts
JOIN `subject` s ON ts.Subject_ID = s.Subject_ID 
GROUP BY ts.Subject_ID 
HAVING COUNT(ts.Mark) <= 0;

-- b) lấy danh sách các môn học có ít nhất 2 điểm
SELECT ts.Subject_ID, s.Subject_Name, count(Mark) SL FROM trainee_subject ts
JOIN `subject` s USING(Subject_ID)
GROUP BY Subject_ID
HAVING COUNT(Mark) >= 2;

-- --------------------------------------------------------------------------------------
-- 3. Tạo view có tên là 'TraineeInfo' lấy các thông tin về học sinh bao gồm:
-- Trainee_ID, FullName, Age, Gender,Subject_ID, Subject_Name, Mark, Exam_Day
CREATE OR REPLACE VIEW TraineeInfo AS
SELECT tb.TraineeID, concat(t.First_Name, ' ',t.Last_Name) AS FullName, t.Age, t.Gender, s.subjectID, s.SubjectName, tb.Mark, tb.Exam_Day FROM trainee_subject AS tb
JOIN trainee AS t USING (TraineeID)
JOIN `subject` AS s USING (SubjectID);

SELECT * FROM TraineeInfo;
-- --------------------------------------------------------------------------------------
-- 4.không sử dụng on update cascade, on delete cascade
-- a) Tạo Trigger cho table Subject có tên là SubjectUpdateID: khi thay đổi data của cột ID
--  của table subject thì  giá trị tương ứng với cột Subject_ID của table trainee_subject cũng thay đổi theo
DROP TRIGGER IF EXISTS SubjectUpdateID;
DELIMITER $$
CREATE TRIGGER SubjectUpdateID
BEFORE UPDATE
ON `Subject`
FOR EACH ROW
BEGIN
      UPDATE Trainee_Subject SET SubjectID = NEW.SubjectID
      WHERE SubjectID = OLD.SubjectID; 
END $$
DELIMITER ;

UPDATE `Subject` SET SubjectID = 9 WHERE SubjectID = 1;

-- b) Tạo trigger cho table Trainee có tên là StudentDeleteID:
-- Khi xóa data của cột ID của table trainee thì giá trị tương ứng của cột SubjectID của table 
-- trainee_subject cũng bị xóa theo

DROP TRIGGER IF EXISTS StudentDeleteID;
DELIMITER $$
CREATE TRIGGER StudentDeleteID
BEFORE DELETE
ON Trainee
FOR EACH ROW
BEGIN
      DELETE FROM Trainee_Subject WHERE TraineeID = OLD.TraineeID; 
END $$
DELIMITER ;

DELETE FROM Trainee WHERE TraineeID = 3;

-- --------------------------------------------------------------------------------------
-- 5. viết 1 store procedure có đầu vào parameter trainee_name sẽ xóa 
-- tất cả các thông tin liên quan tới học sinh có cùng tên như parameter. 
-- Trong trường hợp nhập vào '*' thì procedure sẽ xóa tất cả các học viên

DROP PROCEDURE IF EXISTS sp_DeletebyTraineeName;
DELIMITER $$
CREATE PROCEDURE sp_DeletebyTraineeName(IN Trainee_name varchar(30))
BEGIN
	 -- trường hợp nhập vào dấu '*'
     IF (Trainee_name = '*') THEN
       DELETE FROM Trainee_Subject;
       DELETE FROM Trainee;
     END IF;
     -- trường hợp nhập vào tên
     With CTE_ID AS(
     SELECT Trainee_ID ID FROM `Trainee` 
     WHERE First_Name = Trainee_name
     )
     DELETE FROM Trainee_Subject WHERE Trainee_ID = (SELECT ID FROM CTE_ID);
     DELETE FROM Trainee WHERE First_Name = Trainee_Name;
END $$
DELIMITER ;
SET SQL_SAFE_UPDATES = 0; -- tắt update safe mode
CALL sp_DeletebyTraineeName('First_Name 1');
SET SQL_SAFE_UPDATES = 1;
CALL sp_DeletebyTraineeName('*');