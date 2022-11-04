DROP DATABASE IF EXISTS QL_DoAn;
Create Database QL_DoAn;

USE QL_DoAn;
-- tạo table GiangVien
DROP TABLE IF EXISTS GiangVien;
CREATE TABLE GiangVien(
   Id_GV  SMALLINT UNSIGNED AUTO_INCREMENT,
   Ten_GV VARCHAR(40) NOT NULL,
   Tuoi   TINYINT UNSIGNED,
   HocVi  ENUM('Ths','Ts','PGS','GS') NOT NULL,
   PRIMARY KEY(Id_GV)
);

INSERT INTO giangvien(Ten_GV, Tuoi, HocVi)
VALUES               ('TenGV1', 30,   'Ths'),
					 ('TenGV2', 30,   'Ths'),
                     ('TenGV3', 31,   'Ts'),
                     ('TenGV4', 32,   'Ths'),
                     ('TenGV5', 33,   'Ths'),
                     ('TenGV6', 35,   'Ts'),
                     ('TenGV7', 32,   'Ths'),
                     ('TenGV8', 29,   'Ths'),
                     ('TenGV9', 37,   'GS'),
                     ('TenGV10', 40,  'GS'),
                     ('TenGV11', 35,  'PGS');
-- tạo table SinhVien
DROP TABLE IF EXISTS SinhVien;
CREATE TABLE SinhVien(
   Id_SV     SMALLINT UNSIGNED AUTO_INCREMENT,
   Ten_SV    VARCHAR(40) NOT NULL,
   NamSinh   SMALLINT UNSigned,
   QueQuan   VARCHAR(30),
   PRIMARY KEY(Id_SV)
);

INSERT INTO sinhvien(Ten_SV,  NamSinh, QueQuan)
VALUES              ('TenSV1', 1998,  'BN'),
                    ('TenSV2', 1997,  'BG'),
                    ('TenSV3', 1998,  'BG'),
                    ('TenSV4', 1999,  'HN'),
                    ('TenSV5', 2000,  'HN'),
                    ('TenSV6', 2001,  'BN'),
                    ('TenSV7', 1998,  'BN'),
                    ('TenSV8', 2000,  'QB'),
                    ('TenSV9', 1995,  'QB'),
                    ('TenSV10', 2000, 'HN');

-- tạo table DeTai
DROP TABLE IF EXISTS DeTai;
CREATE TABLE Detai(
   Id_DeTai  SMALLINT UNSIGNED AUTO_INCREMENT,
   Ten_DeTai VARCHAR(40) NOT NULL,
   PRIMARY KEY(Id_DeTai)
);

INSERT INTO detai(Ten_DeTai)
VALUES           ('Ngiên Cứu CSDL'),
                 ('Nghiên Cứu Giải Thuật'),
                 ('Lập Trình Web'),
                 ('Đồ Án 1'),
                 ('Đồ Án 2'),
                 ('Đồ Án 3'),
                 ('Đồ Án 4'),
                 ('Đồ Án 5'),
                 ('Đồ Án 6'),
                 ('Đồ Án 7');
                 
-- tạo table HuongDan
DROP TABLE IF EXISTS HuongDan;
CREATE TABLE HuongDan(
   Id        SMALLINT UNSIGNED AUTO_INCREMENT,
   Id_SV     SMALLINT UNSIGNED,
   Id_DeTai  SMALLINT UNSIGNED,
   Id_GV     SMALLINT UNSIGNED,
   Diem      Float UNSIGNED,
   FOREIGN KEY(Id_SV) REFERENCES SinhVien(Id_SV),
   FOREIGN KEY(Id_DeTai) REFERENCES DeTai(Id_DeTai),
   FOREIGN KEY(Id_GV) REFERENCES GiangVien(Id_GV),
   PRIMARY KEY(Id)
);

INSERT INTO HuongDan(Diem)
VALUES              (8),
					(9),
                    (7.5),
                    (8.5),
                    (9.25),
                    (9.5),
                    (7),
                    (6.5),
                    (6),
                    (8);
                    
-- -----------------------------------------------------------------------------------------------------
-- Questions
-- 1. thêm ít nhất 10 bản ghi vào table done

-- 2. viết lệnh để
-- a) lấy tất cả các sinh viên chưa có đề tài hướng dẫn
SELECT Ten_SV FROM sinhvien sv
LEFT JOIN huongdan hd USING(Id_SV)
WHERE hd.Id_DeTai IS NULL OR ( sv.Id_SV NOT IN(SELECT Id_SV FROM huongdan) );

-- b) lấy ra số sinh viên làm đề tài DeTai6
SELECT dt.Ten_DeTai, COUNT(1) amount FROM huongdan hd
JOIN DeTai dt ON dt.Id_DeTai = hd.Id_DeTai
GROUP BY hd.Id_DeTai
HAVING dt.Ten_DeTai = 'DeTai6';

-- 3. Tạo view có tên là "SinhVienInfo" lấy thông tin về học sinh bao gồm:
-- mã số, họ tên và tên đề tài
-- (nếu sinh viên chưa có đề tài thì column tên đề tài in "ra chưa có")
CREATE OR REPLACE VIEW SinhVienInfo AS
SELECT sv.Id_SV, sv.Ten_SV, IFNULL(dt.Ten_DeTai,'Chưa có') DeTai FROM HuongDan hd
RIGHT JOIN SinhVien sv ON hd.Id_SV = sv.Id_SV
LEFT JOIN DeTai dt USING(Id_DeTai);


