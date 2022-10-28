-- question 4: tạo store để trả ra id của type question có nhiều câu hỏi nhất
WITH CTE_TypeID AS(
    SELECT COUNT(1) m_count FROM question
    GROUP BY TypeID
)
SELECT TypeID FROM question
GROUP BY TypeID
HAVING COUNT(1) = (SELECT MAX(m_count) FROM CTE_TypeID);

DROP PROCEDURE IF EXISTS THMQ -- typeID have max question
DELIMITER $$
CREATE PROCEDURE THMQ()
BEGIN
		WITH CTE_TypeID AS(
			SELECT COUNT(1) m_count FROM question
			GROUP BY TypeID
		)
		SELECT TypeID FROM question
		GROUP BY TypeID
		HAVING COUNT(1) = (SELECT MAX(m_count) FROM CTE_TypeID);
END $$
DELIMITER ;

CALL THMQ();

-- question 6: viết store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập 
-- vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
-- SELECT IF(g.groupName = 'Mộc Cắc 1', g.groupName, if(a.userName = 'Mộc Cắc 1', a.userName,'')) FROM `account` a
-- JOIN `group` g ON g.CreatorID = a.AccountID;
  
-- question 7: viết 1 store cho phép người dùng nhập vào thông tin fullName, email 
-- và trong store sẽ tự động gán :
--              userName sẽ giống email nhưng bỏ phần @..mail đi 
--              positionID: sẽ có default là developer
--              departmentID: sẽ được cho vào 1 phòng chờ
-- sau đó in ra kết quả tạo thành công

-- question 8: viết store cho phép người dùng nhập vào essay hoặc multiple- choice 
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất

DROP PROCEDURE IF EXISTS Search; -- nhập vào essay hoặc multiple-choice
DELIMITER $$
CREATE PROCEDURE Search(IN search_value VARCHAR(30))
BEGIN
		WITH CTE_length AS(
			SELECT char_length(content) content_length FROM question
            JOIN typequestion tq USING(TypeID)
            WHERE tq.typeName = search_value
		)
		SELECT  tq.TypeName, q.Content, char_length(content) FROM question q
        JOIN typequestion tq USING(TypeID)
		WHERE char_length(content) = (SELECT MAX(content_length) FROM CTE_length);
END $$
DELIMITER ;
				
CALL Search('Essay');


-- question 9: viết 1 store cho phép người dùng xóa exam dựa vào id
DROP PROCEDURE IF EXISTS Delete_byID; -- nhập vào essay hoặc multiple-choice
DELIMITER $$
CREATE PROCEDURE Delete_byID(IN inputID TINYINT)
BEGIN
		DELETE  FROM exam WHERE ExamID = inputID;
END $$
DELIMITER ;

SELECT * FROM exam;
CALL Delete_byID(2);

-- question 10:  tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi(sử dụng store ở câu 9 để xóa)
-- sau đó in số lượng record đã remove từ các table liên quan trong khi removing
SELECT * FROM exam;

DROP TRIGGER IF EXISTS remove_history;
DELIMITER $$
CREATE TRIGGER remove_history
BEFORE DELETE ON exam
FOR EACH ROW
BEGIN
    SELECT * FROM exam 
    WHERE ExamID = OLD.ExamID;
    SIGNAL SQLSTATE '12345'
    SET MESSAGE_TEXT ='bản ghi đã bị xóa';
END $$
DELIMITER ;

DELETE FROM exam WHERE YEAR(CreateDate) < '2019';

-- question 11: viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc 
DROP PROCEDURE IF EXISTS remove_dep;
DELIMITER $$
CREATE PROCEDURE remove_dep(IN depname VARCHAR(30))
BEGIN
     UPDATE department d SET departmentID = 5 AND departmentName = 'default'
     WHERE d.DepartmentName = depname;
END $$
DELIMITER ;

CALL remove_dep('kỹ thuật');

-- question 12:
