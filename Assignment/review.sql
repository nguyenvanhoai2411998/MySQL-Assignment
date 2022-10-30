DROP DATABASE IF EXISTS fresher;
CREATE DATABASE fresher;
USE fresher;
DROP TABLE IF EXISTS Trainee;
CREATE TABLE Trainee(
    TraineeID TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(30) NOT NULL,
    Birth_Date DATE NOT NULL,
    Gender ENUM('MALE','FEMALE','UNKNOWN') NOT NULL,
    ET_IQ INTEGER UNSIGNED,
    ET_Gmath INTEGER UNSIGNED,
    ET_English INTEGER UNSIGNED,
    Training_Class VARCHAR(10), -- mã lớp
    Evaluation_Notes VARCHAR(20),
    -- tạo constraint check để ràng buộc đk ở nhiều cột
    CONSTRAINT CHK_Score CHECK(ET_IQ <= 20 AND ET_Gmath <= 20 AND ET_English <= 50)
);

INSERT INTO Trainee(Full_Name,   Birth_Date,  Gender, ET_IQ, ET_Gmath, ET_English, Training_Class, Evaluation_Notes)
VALUES             ('FullName1', '1998-02-12','Male', 30, 15, 40, 'VTI001', 'DHBKHN'),
				   ('FullName2', '2000-02-10','Male', 12, 15, 40, 'VTI002', 'DHBKHN'),
                   ('FullName3', '2001-01-12','Male', 10, 15, 25, 'VTI001', 'DHBKHN'),
                   ('FullName4', '1997-02-04','Male', 14, 15, 40, 'VTI002', 'DHBKHN'),
                   ('FullName5', '1996-02-05','Male', 15, 15, 25, 'VTI005', 'DHBKHN'),
                   ('FullName6', '1998-02-12','Male', 15, 15, 30, 'VTI005', 'DHBKHN'),
                   ('FullName7', '1995-05-06','Male', 15, 15, 30, 'VTI001', 'DHBKHN'),
                   ('FullName8', '1994-04-02','Male', 15, 15, 30, 'VTI002', 'DHBKHN'),
                   ('FullName9', '1990-10-12','Male', 15, 15, 40, 'VTI001', 'DHBKHN'),
                   ('FullName1', '1992-02-12','Male', 10, 15, 40, 'VTI001', 'DHBKHN');
                   
SELECT * FROM Trainee;

-- question 4: viết lệnh để lấy ra tất cả các thực tập sinh đã vượt qua bài test đầu vào
-- và sắp xếp theo ngày sinh ET_IQ > 12, ET_Gmath >= 12, ET_English >= 20
SELECT * FROM Trainee
WHERE ET_IQ > 12 AND ET_Gmath >= 12 AND ET_English >= 20
ORDER BY Birth_Date;

-- question 5: viết lệnh lấy ra thông tin thực tập sinh có tên bắt đầu bằng chữ N và kết thúc bằng C
SELECT * FROM Trainee 
WHERE substring_index(Full_Name," ",-1) LIKE "n%c";

-- question 6: viết lệnh để lấy ra thông tin thực tập sinh mà tên có ký tự thứ 2 là chữ G
SELECT * FROM Trainee 
WHERE substring_index(Full_Name," ",-1) LIKE "_g%";

-- question 7: viết lệnh để lấy ra thông tin thực tập sinh mà tên có 10 ký tự và ký tự cuối cùng là C
SELECT * FROM Trainee 
WHERE length(Full_Name) >= 10 AND substring_index(Full_Name," ",-1) LIKE "%c";

-- question 8: viết lệnh để lấy ra FullName của các thực tập sinh trong lớp, lọc bỏ các tên trùng nhau
SELECT Full_Name from Trainee
GROUP BY Full_Name;