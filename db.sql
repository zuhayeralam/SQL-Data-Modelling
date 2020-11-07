/*
* SQL text file for KIT102 Data Modeling Assignment 2019
* Creates tables for Orange University Database and,
* populates the tables with minimum two values 
* (Some tables needed more values for design)
*	@author Zuhayer Alam
*	@Version 10 October 2019
*/
USE zalam;
/*The next statement deletes all the tables considering the order of dependencies*/
DROP TABLE IF EXISTS
MEMBERSHIPFORSTUDENT,MEMBERSHIPFORSTAFF,TEACHES,PREPARESEXAMS,TUTORS,
MARKSEXAMS,DELIVERSLECTURE,SUPERVISION,ACADEMICSTAFF,REGULARSTUDENT,
PHDSTUDENT,TUTOR,SHORTCOURSE,MAINCOURSE,CLUB,TUTORIAL,LECTURES,EXAMS,ALLCOURSE,STAFF,STUDENTDETAILS;

/*contact number type is varchar for plus signs and dashes*/	
CREATE TABLE STUDENTDETAILS (
  StudentNumber int(6) NOT NULL,
  StudentName varchar(100) NOT NULL,
  PreferredName varchar(50) DEFAULT NULL,
  DateOfBirth date NOT NULL,
  Gender enum('MALE','FEMALE','OTHER') NOT NULL,
  InternationalStatus enum('YES','NO') NOT NULL,
  ContactNumber varchar(12) NOT NULL, 
  PRIMARY KEY (StudentNumber)) ENGINE=InnoDB;

CREATE TABLE STAFF (
  StaffID int(9) NOT NULL,
  StaffName varchar(100) NOT NULL,
  Gender enum('MALE','FEMALE','OTHER') NOT NULL,
  ContactNumber varchar(12) NOT NULL,
  Positon enum('PROFESSOR','ASSOCIATE PROFESSOR','SENIOR LECTURER','LECTURER','TUTOR','PHD STUDENT') NOT NULL,
  PRIMARY KEY (StaffID)) ENGINE=InnoDB;

CREATE TABLE ALLCOURSE (
  CourseCode varchar(7) NOT NULL,
  CourseName varchar(100) NOT NULL,
  PRIMARY KEY (CourseCode)) ENGINE=InnoDB;

CREATE TABLE EXAMS (
  UnitCode varchar(6) NOT NULL,
  UnitName varchar(100) NOT NULL,
  ExamDate date NOT NULL,
  PRIMARY KEY (UnitCode)) ENGINE=InnoDB;

CREATE TABLE LECTURES (
  UnitCode varchar(6) NOT NULL,
  UnitName varchar(100) NOT NULL,
  LectureDay enum('MON','TUE','WED','THU','FRI') NOT NULL,
  LectureTime time NOT NULL,
  PRIMARY KEY (UnitCode)) ENGINE=InnoDB;

CREATE TABLE TUTORIAL (
  UnitCode varchar(6) NOT NULL,
  UnitName varchar(100) NOT NULL,
  TutorialDay enum('MON','TUE','WED','THU','FRI') NOT NULL,
  TutorialTime time NOT NULL,
  PRIMARY KEY (UnitCode)) ENGINE=InnoDB;

CREATE TABLE CLUB (
  ClubID int(5) NOT NULL,
  ClubName varchar(100) NOT NULL,
  HeadMemberName varchar(100) NOT NULL,
  OpenDate date NOT NULL,
  Category enum('OUTDOOR SPORT','INDOOR SPORT','HEALTH & WELLNESS','SCIENCE') NOT NULL,
  PRIMARY KEY (ClubID)) ENGINE=InnoDB;
/*this table's (MAINCOURSE) primary key is a foreign key which refers to the primary key of the table named ALLCOURSE.
*  All other foreign key constraints are similar following "fk_current table name _ referred table name _ key name" convention
*/
CREATE TABLE MAINCOURSE (
  CourseCode varchar(7) NOT NULL,
  CourseName varchar(100) NOT NULL,
  CourseType enum('BACHELOR','HONOUR','MASTER') NOT NULL,
  PRIMARY KEY(CourseCode),
  CONSTRAINT `fk_maincourse_allcourse_CourseCode` FOREIGN KEY (CourseCode) REFERENCES ALLCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE) ENGINE=InnoDB;
	
CREATE TABLE SHORTCOURSE (
  CourseCode varchar(7) NOT NULL,
  CourseName varchar(100) NOT NULL,
  DurationWeeks tinyint(1) NOT NULL DEFAULT '3',
  PRIMARY KEY (CourseCode), 
CONSTRAINT `fk_shortcourse_allcourse_CourseCode` FOREIGN KEY (CourseCode) REFERENCES ALLCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE TUTOR (
  TutorID int(9) NOT NULL,
  Position enum('TUTOR','LECTURER','PHD STUDENT') NOT NULL,
  PRIMARY KEY (TutorID),
  CONSTRAINT `fk_tutor_staff_TutorID` FOREIGN KEY (TutorID) REFERENCES STAFF (StaffID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PHDSTUDENT (
  StudentNumber int(6) NOT NULL,
  ResearchTopic varchar(255) NOT NULL,
  ShortCourseCode varchar(7) DEFAULT NULL,
  PRIMARY KEY (StudentNumber),
  
  CONSTRAINT `fk_phdstudent_shortcourse_CourseCode` FOREIGN KEY (ShortCourseCode) REFERENCES SHORTCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_phdstudent_studentdetails_StudentNumber` FOREIGN KEY (StudentNumber) REFERENCES STUDENTDETAILS (StudentNumber) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE REGULARSTUDENT (
  StudentNumber int(6) NOT NULL,
  MainCourseCode varchar(7) NOT NULL,
  ShortCourseCode1 varchar(7) DEFAULT NULL,
  ShortCourseCode2 varchar(7) DEFAULT NULL,
  ShortCourseCode3 varchar(7) DEFAULT NULL,
  PRIMARY KEY (StudentNumber),
  
  CONSTRAINT `fk_regularstudent_maincourse_MainCourseCode` FOREIGN KEY (MainCourseCode) REFERENCES MAINCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_regularstudent_shortcourse_ShortCourseCode1` FOREIGN KEY (ShortCourseCode1) REFERENCES SHORTCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_regularstudent_shortcourse_ShortCourseCode2` FOREIGN KEY (ShortCourseCode2) REFERENCES SHORTCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_regularstudent_shortcourse_ShortCourseCode3` FOREIGN KEY (ShortCourseCode3) REFERENCES SHORTCOURSE (CourseCode) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_regularstudent_studentdetails_StudentNumber` FOREIGN KEY (StudentNumber) REFERENCES STUDENTDETAILS (StudentNumber) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ACADEMICSTAFF (
  StaffID int(9) NOT NULL,
  Position enum('PROFESSOR','ASSOCIATE PROFESSOR','SENIOR LECTURER','LECTURER') NOT NULL,
  PRIMARY KEY (StaffID),
  CONSTRAINT `fk_academicstaff_staff_StaffID` FOREIGN KEY (StaffID) REFERENCES STAFF (StaffID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SUPERVISION (
  PhDStudentNumber int(6) NOT NULL,
  SupervisorID int(9) NOT NULL,
  RoleOfSupervisor enum('FIRST SUPERVISOR','SECOND SUPERVISOR','THIRD SUPERVISOR') NOT NULL,
  PRIMARY KEY (PhDStudentNumber,SupervisorID),
  
  CONSTRAINT `fk_supervision_academicstaff_SupervisorID` FOREIGN KEY (SupervisorID) REFERENCES ACADEMICSTAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_supervision_phdstudent_PhDStudentNumber` FOREIGN KEY (PhDStudentNumber) REFERENCES PHDSTUDENT (StudentNumber) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE DELIVERSLECTURE (
  LecturerID int(11) NOT NULL,
  UnitCode varchar(6) NOT NULL,
  PRIMARY KEY (LecturerID,UnitCode),
  
  CONSTRAINT `fk_deliverslecture_academicstaff_LecturerID` FOREIGN KEY (LecturerID) REFERENCES ACADEMICSTAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_deliverslecture_lectures_UnitCode` FOREIGN KEY (UnitCode) REFERENCES LECTURES (UnitCode) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE MARKSEXAMS (
  ExaminerID int(11) NOT NULL,
  UnitCode varchar(6) NOT NULL,
  PRIMARY KEY (ExaminerID,UnitCode),
  
  CONSTRAINT `fk_marksexams_academicstaff_ExaminerID` FOREIGN KEY (ExaminerID) REFERENCES ACADEMICSTAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_marksexams_exams_UnitCode` FOREIGN KEY (UnitCode) REFERENCES EXAMS (UnitCode) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE TUTORS (
  TutorID int(11) NOT NULL,
  UnitCode varchar(6) NOT NULL,
  PRIMARY KEY (TutorID,UnitCode),

  CONSTRAINT `fk_tutors_tutor_TutorID` FOREIGN KEY (TutorID) REFERENCES TUTOR (TutorID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_tutors_tutorial_UnitCode` FOREIGN KEY (UnitCode) REFERENCES TUTORIAL (UnitCode) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE PREPARESEXAMS (
  ExaminerID int(11) NOT NULL,
  UnitCode varchar(6) NOT NULL,
  PRIMARY KEY (ExaminerID,UnitCode),

  CONSTRAINT `fk_preparesexams_academicstaff_ExaminerID` FOREIGN KEY (ExaminerID) REFERENCES ACADEMICSTAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_preparesexams_exams_UnitCode` FOREIGN KEY (UnitCode) REFERENCES EXAMS (UnitCode) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE TEACHES (
  AcademicStaffID int(11) NOT NULL,
  CourseCode varchar(7) NOT NULL,
  PRIMARY KEY (AcademicStaffID,CourseCode),

  CONSTRAINT `fk_teaches_academicstaff_AcademicStaffID` FOREIGN KEY (AcademicStaffID) REFERENCES ACADEMICSTAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_teaches_allcourse_coursecode` FOREIGN KEY (CourseCode) REFERENCES ALLCOURSE (CourseCode) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE MEMBERSHIPFORSTAFF (
  ClubID int(5) NOT NULL,
  StaffID int(11) NOT NULL,
  PRIMARY KEY (ClubID,StaffID),

  CONSTRAINT `fk_membershipforstaff_club_ClubID` FOREIGN KEY (ClubID) REFERENCES CLUB (ClubID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_membershipforstaff_staff_staffID` FOREIGN KEY (StaffID) REFERENCES STAFF (StaffID) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE MEMBERSHIPFORSTUDENT (
  ClubID int(5) NOT NULL,
  StudentNumber int(11) NOT NULL,
  PRIMARY KEY (ClubID,StudentNumber),

  CONSTRAINT `fk_membershipforstudent_club_ClubID` FOREIGN KEY (ClubID) REFERENCES CLUB (ClubID) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_membershipforstudent_studentdetails_StudentNumber` FOREIGN KEY (StudentNumber) REFERENCES STUDENTDETAILS (StudentNumber) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;
/*all the information here are random. I have included my name in the STUDENTDETAILS table.*/
INSERT INTO STUDENTDETAILS (StudentNumber, StudentName, PreferredName, DateOfBirth, Gender, InternationalStatus, ContactNumber) VALUES (510356, 'Zuhayer Alam', 'Zuhayer', '1998-10-27', 'MALE', 'YES', '+6146618733'),(798433, 'James Charles', NULL, '1999-06-18', 'MALE', 'NO', '+61235534999'),(889333, 'Yurima Psy', 'David', '1996-09-09', 'MALE', 'YES', '+61343256799'),(990432, 'Melanie Potter', 'Melanie', '1994-04-17', 'FEMALE', 'NO', '+61779805679'),(609340, 'Alan Walker', 'Alan', '1997-07-01', 'MALE', 'YES', '+61346618733');


INSERT INTO STAFF (StaffID, StaffName, Gender, ContactNumber, Positon) VALUES(609340, 'Alan Walker', 'MALE', '+61346618733', 'PHD STUDENT'),(1226969, 'David Rose', 'MALE', '+61677846888', 'TUTOR'),(2342211, 'Kylie Ames', 'FEMALE', '+61577446968', 'ASSOCIATE PROFESSOR'),(3442299, 'Bill Musk', 'OTHER', '+61547946553', 'LECTURER'),(7773210, 'Misaki Ayuzawa', 'FEMALE', '+61355518706', 'LECTURER'),(8834222, 'Amanda Gates', 'FEMALE', '+61333569104', 'SENIOR LECTURER');

/*inserted more than two values in ALLCOURSE because SHORTCOURSE,MAINCOURSE both tables refer to this table*/
INSERT INTO ALLCOURSE (CourseCode, CourseName) VALUES ('ICT166', 'Bachelors of Games Technology'),('ICT177', 'Honours of Software Engineering'),('ICT401', 'Masters of Software Engineering'),('ICT409', 'Masters of Network Security'),('SICT126', 'Natural Language Processing'),('SICT433', 'Data Science'),('SICT456', 'Artificial Intelligence'),('SICT666', 'Data Management'),('SICT933', 'Computer Vision');	


INSERT INTO EXAMS (UnitCode, UnitName, ExamDate) VALUES('TIK144', 'Introduction to Operating Systems', '2019-10-07'),('TIK156', 'Web Programming', '2019-11-11');


INSERT INTO LECTURES (UnitCode, UnitName, LectureDay, LectureTime) VALUES('TIK707', 'Server Adminstration', 'FRI', '11:00:00'),('TIK999', 'VR Technology', 'TUE', '15:00:00');


INSERT INTO TUTORIAL (UnitCode, UnitName, TutorialDay, TutorialTime) VALUES('TIK107', 'Database Manipulation', 'MON', '17:00:00'),('TIK766', 'Computational Science 2', 'THU', '09:00:00');


INSERT INTO CLUB (ClubID, ClubName, HeadMemberName, OpenDate, Category) VALUES(45000, 'Young Dragons Club', 'Yujie Tanaka', '1994-01-01', 'OUTDOOR SPORT'),(69009, 'Astronomy Society', 'Dexter Royal', '1999-07-30', 'SCIENCE');


INSERT INTO MAINCOURSE (CourseCode, CourseName, CourseType) VALUES('ICT409', 'Masters of Network Security', 'MASTER'),('ICT177', 'Honours of Software Engineering', 'HONOUR');


INSERT INTO SHORTCOURSE (CourseCode, CourseName, DurationWeeks) VALUES('SICT126', 'Natural Language Processing', '3'),('SICT433', 'Data Science', '3'),('SICT456', 'Artificial Intelligence', '3'),('SICT666', 'Data Management', '3'),('SICT933', 'Computer Vision', '3');


INSERT INTO TUTOR (TutorID, Position) VALUES (609340, 'PHD STUDENT'),(1226969, 'TUTOR'),(7773210, 'LECTURER');


INSERT INTO PHDSTUDENT (StudentNumber, ResearchTopic, ShortCourseCode) VALUES (609340, 'BlockChain Technology', 'SICT433'),(798433, 'Internet of Things', NULL);


INSERT INTO REGULARSTUDENT (StudentNumber, MainCourseCode, ShortCourseCode1, ShortCourseCode2, ShortCourseCode3) VALUES (889333, 'ICT409', 'SICT126', 'SICT933', NULL),(990432, 'ICT177', NULL, NULL, NULL);


INSERT INTO ACADEMICSTAFF (StaffID, Position) VALUES (2342211, 'ASSOCIATE PROFESSOR'),(3442299, 'LECTURER'),(7773210, 'LECTURER'),(8834222, 'SENIOR LECTURER');


INSERT INTO SUPERVISION (PhDStudentNumber, SupervisorID, RoleOfSupervisor) VALUES (609340, 2342211, 'FIRST SUPERVISOR'),(798433, 3442299, 'SECOND SUPERVISOR'),(798433, 8834222, 'FIRST SUPERVISOR');


INSERT INTO DELIVERSLECTURE (LecturerID, UnitCode) VALUES (8834222, 'TIK707'),(7773210, 'TIK999');



INSERT INTO MARKSEXAMS (ExaminerID, UnitCode) VALUES (3442299, 'TIK144'),(2342211, 'TIK156');


INSERT INTO TUTORS (TutorID, UnitCode) VALUES (609340, 'TIK107'),(1226969, 'TIK766');



INSERT INTO PREPARESEXAMS (ExaminerID, UnitCode) VALUES (7773210, 'TIK144'),(8834222, 'TIK156');


INSERT INTO TEACHES (AcademicStaffID, CourseCode) VALUES (3442299, 'ICT166'),(2342211, 'ICT409');


INSERT INTO MEMBERSHIPFORSTAFF (ClubID, StaffID) VALUES (45000, '1226969'),(69009, '2342211');


INSERT INTO MEMBERSHIPFORSTUDENT (ClubID, StudentNumber) VALUES (45000, '889333'),(45000, '990432');
