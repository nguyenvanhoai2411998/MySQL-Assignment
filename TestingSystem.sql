DROP DATABASE IF EXISTS TestingSystem;
CREATE DATABASE TestingSystem;
USE TestingSystem;
-- tạo table 1 department
DROP TABLE IF EXISTS Department;
CREATE TABLE Department(
             DepartmentID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             DepartmentName VARCHAR(30) NOT NULL
);
-- input dữ liệu cho table department
INSERT INTO department(DepartmentName)
VALUES                ('Kỹ Thuật'),
					  ('Nhân Sự'),
                      ('Kế Toán'),
                      ('Giám Sát'),
                      ('Sale'),
                      ('Quản Lý'),
                      ('Bảo Vệ'),
                      ('Gia Công'),
                      ('Chăm Sóc Khách Hàng');

INSERT INTO department(DepartmentName)
VALUES                ('Thực Phẩm');
-- check table department
SELECT * FROM department;


-- tạo table 2: position
DROP TABLE IF EXISTS Position;
CREATE TABLE Position (
             PositionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             PositionName ENUM('Dev','Test','Scrum Master','PM') UNIQUE
);
-- insert into table position
INSERT INTO `position`(PositionName)
VALUES                ('Dev'),
                      ('Test'),
                      ('Scrum Master'),
                      ('PM');
-- check table Position
SELECT * FROM Position;

-- tạo table 3: account
DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account` (
             AccountID       TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             Email           VARCHAR(30) UNIQUE KEY NOT NULL,
             UserName 	     VARCHAR(30) UNIQUE NOT NULL,
             FullName 		 VARCHAR(30) NOT NULL,
             DepartmentID    TINYINT UNSIGNED,
             PositionID   	 TINYINT UNSIGNED,
             CreateDate  	 DATETIME DEFAULT NOW(),
             FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID) ON DELETE CASCADE ON UPDATE CASCADE,
             FOREIGN KEY (PositionID) REFERENCES `Position`(PositionID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- insert into table Account
INSERT INTO `Account`(Email, UserName, FullName, DepartmentID, PositionID)
VALUES               ('TranmongCac1@gmail.com','Mộc Cắc 1', 'Trần Mộng Cắc', 1, 1 ),
                     ('TranmongCac2@gmail.com','Mộc Cắc 2', 'Thực Mộng Cắc', 2, 1),
                     ('TranmongCac3@gmail.com','Mộc Cắc 3', 'Kai Bành', 3, 2),
                     ('TranmongCac4@gmail.com','Mộc Cắc 4', 'Mộc Cắc', 4, 3),
                     ('TranmongCac5@gmail.com','Mộc Cắc 5', 'Trần Mộng Cắc', 5, 4),
                     ('TranmongCac6@gmail.com','Mộc Cắc 6', 'Trần Mộng Cắc', 6, 3),
                     ('TranmongCac7@gmail.com','Mộc Cắc 7', 'Trần Mộng Cắc', 7, 1),
                     ('TranmongCac8@gmail.com','Mộc Cắc 8', 'Trần Mộng Cắc', 8, 2),
                     ('TranmongCac9@gmail.com','Mộc Cắc 9', 'Trần Mộng Cắc', 9, 1),
                     ('TranmongCac10@gmail.com','Mộc Cắc 10', 'Trần Mộng Cắc', 10, 4);
-- check table `Account`
SELECT * FROM `Account`;

-- tạo table 4: Group
DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group` (
             GroupID         TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             GroupName       VARCHAR(30) UNIQUE NOT NULL,
             CreatorID       TINYINT UNSIGNED,
			 CreateDate  	 DATETIME DEFAULT NOW(),
             FOREIGN KEY(CreatorID) REFERENCES 	`Account`(AccountID)
);
-- nhập dữ liệu cho bảng Group
INSERT INTO `Group`(GroupName, CreatorID)
VALUES             ('Thế Vận Hội', 1),
                   ('Mùa Xuân 1975', 2),
                   ('Lời Tuyên Thệ', 5),
                   ('Vượt Ngục', 6),
                   ('Quỹ Lớp', 7),
                   ('Gây Quỹ', 6),
                   ('Bố Già', 3);
-- check table Group
SELECT * FROM `Group`;

-- tạo table 5: GroupAccount
DROP TABLE IF EXISTS `GroupAccount`;
CREATE TABLE `GroupAccount` (
             GroupID         TINYINT UNSIGNED,
             AccountID       TINYINT UNSIGNED,
			 JoinDate  	     DATETIME DEFAULT NOW(),
             FOREIGN KEY(GroupID) REFERENCES `Group`(GroupID),
             FOREIGN KEY(AccountID) REFERENCES `Account`(AccountID),
             PRIMARY KEY(GroupID, AccountID)
);
-- nhập dữ liệu cho bảng GroupAccount
INSERT INTO `GroupAccount`(GroupID, AccountID)
VALUES             (1,1),
                   (1,2),
                   (2,1),
                   (2,2),
                   (1,3),
                   (2,4),
                   (3,5),
                   (4,6);
-- check bảng GroupAccount
SELECT * FROM GroupAccount;
                   
-- tạo table 6: TypeQuestion
DROP TABLE IF EXISTS `TypeQuestion`;
CREATE TABLE `TypeQuestion` (
             TypeID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             TypeName ENUM('Essay','Multiple-Choice')
);
-- nhập dữ liệu cho bảng TypeQuestion
INSERT INTO TypeQuestion(TypeName)
VALUES                  ('Essay'),
						('Essay'),
                        ('Multiple-Choice'),
                        ('Essay'),
                        ('Essay'),
                        ('Multiple-Choice');
-- check TypeQuestion
SELECT * FROM TypeQuestion;


-- tạo table 7: CategoryQuestion
DROP TABLE IF EXISTS `CategoryQuestion`;
CREATE TABLE `CategoryQuestion` (
             CategoryID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             CategoryName ENUM('Java','.NET','SQL','Postman','Ruby','Python','C++','C#','Jquerry','React')
);
-- insert into table 7:
INSERT INTO CategoryQuestion(CategoryName)
VALUES                  ('Java'),
						('.NET'),
                        ('SQL'),
                        ('Postman'),
                        ('Ruby'),
                        ('python'),
                        ('C#'),
                        ('C++'),
                        ('JQuerry'),
                        ('React');
-- check table CategoryQuestion
SELECT * FROM CategoryQuestion;


-- tạo table 8: Question
DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question` (
             QuestionID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             Content VARCHAR(100) NOT NULL UNIQUE,
             CategoryID TINYINT UNSIGNED,
             TypeID     TINYINT UNSIGNED,
             CreatorID  TINYINT UNSIGNED,
			 CreateDate  	 DATETIME DEFAULT NOW(),
             FOREIGN KEY(CategoryID) REFERENCES `CategoryQuestion`(CategoryID),
             FOREIGN KEY(CreatorID) REFERENCES `Account`(AccountID),
             FOREIGN KEY(TypeID) REFERENCES `TypeQuestion`(TypeID)
);
-- insert into table 8:
INSERT INTO Question(Content,                           CategoryID,                       TypeID,                       CreatorID)
VALUES              ('đã có kinh nghiệm làm việc chưa', 1,                                3,                            1),
                    ('đã từng làm ở đâu',               2,                                1,                            2),
                    ('đã làm về lĩnh vực gì',           3,                                2,                            3),
                    ('trình độ toeic như thế nào',      4,                                4,                            4),
                    ('có bằng lái xe không',            5,                                1,                            5),
                    ('tại sao lại chọn công ty',        6,                                1,                            2);
SELECT * FROM Question;
   
-- tạo table 9: answer
DROP TABLE IF EXISTS `Answer`;
CREATE TABLE `Answer` (
             ExamID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             Content VARCHAR(100) NOT NULL UNIQUE,
             QuestionID TINYINT UNSIGNED,
             isCorrect ENUM('Đúng','Sai'),
             FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID) ON DELETE CASCADE
);
-- nhập dữ liệu vào table  Answer
INSERT INTO Answer(Content,                                  QuestionID,                       isCorrect)
VALUES            ('đã từng làm việc tại công ty abc, yzt',  4,                                'Sai'),
                  ('làm ở văn phòng google sw',              4,                                'Đúng'),
                  ('đã từng làm về web back end',            4,                                'Sai'),
                  ('đã đạt được số điểm 550',                7,                                'Đúng'),
                  ('có bằng lái xe máy, ô tô, máy bay',      8,                                'Đúng'),
                  ('vì chưa có kinh nghiệm nên xin thực tập',  9,                                'Đúng');
-- check table Answer
SELECT * FROM Answer;


-- tạo table 10: Exam
DROP TABLE IF EXISTS `Exam`;
CREATE TABLE `Exam` (
             ExamID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
             ExamCode VARCHAR(100) NOT NULL UNIQUE,
             Title VARCHAR(100) NOT NULL,
             CategoryID TINYINT UNSIGNED,
             Duration TINYINT NOT NULL,
             CreatorID TINYINT UNSIGNED,
             CreateDate DATETIME DEFAULT NOW(),
             FOREIGN KEY (CategoryID) REFERENCES categoryquestion(CategoryID),
             FOREIGN KEY (CreatorID) REFERENCES `Account`(AccountID)
);
-- insert into table Exam
INSERT INTO Exam(ExamCode,                          Title,                       CategoryID,                       Duration,                  CreatorID)
VALUES          ('XC01',                            'Mã đề 01',                  1,                                30,                         1),
				('XC02',                            'Mã đề 02',                  2,                                45,                         1),
                ('XC03',                            'Mã đề 03',                  3,                                30,                         2),
                ('XC04',                            'Mã đề 04',                  4,                                75,                         3),
                ('XC05',                            'Mã đề 05',                  5,                                15,                         1),
                ('XC06',                            'Mã đề 06',                  6,                                45,                         3),
                ('XC07',                            'Mã đề 07',                  7,                                60,                         4),
                ('XC08',                            'Mã đề 08',                  8,                                30,                         5),
                ('XC09',                            'Mã đề 09',                  9,                                30,                         6);
-- check dữ liệu table Exam
SELECT * FROM Exam;


SELECT AccountID, Email, DepartmentName, PositionName FROM `Account` a
INNER JOIN department d on a.departmentID = d.departmentID
INNER JOIN position p ON a.positionID = p.positionID;

-- tạo bảng examquestion
DROP TABLE IF EXISTS ExamQuestion;
CREATE TABLE ExamQuestion(
       ExamID TINYINT UNSIGNED,
       QuestionID TINYINT UNSIGNED,
       PRIMARY KEY(ExamID, QuestionID),
       FOREIGN KEY (ExamID) REFERENCES Exam(ExamID) ON DELETE CASCADE,
       FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID) ON DELETE CASCADE
);

SELECT * FROM ExamQuestion;
INSERT INTO ExamQuestion(ExamID, QuestionID)
VALUES                  (3,      4),
						(4,      4),
                        (5,      4),
                        (6,      5),
                        (7,      7),
                        (8,      6),
                        (9,      11);
                        
-- Trigger
-- viết trigger không cho phép xóa account có username là admin
DROP TRIGGER IF EXISTS Trg_BfDeleteAccount;
DELIMITER $$ 
CREATE TRIGGER Trg_BfDeleteAccount
BEFORE DELETE ON `account`
FOR EACH ROW
BEGIN 
     IF(OLD.userName = 'admin') THEN
     SIGNAL SQLSTATE '12345'
     SET MESSAGE_TEXT =' không thể xóa admin';
     END IF;
END $$
DELIMITER ;

DELETE FROM `account` WHERE AccountID = 4;