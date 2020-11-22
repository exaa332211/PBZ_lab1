USE Lb1;

drop table if exists teacher;
drop table if exists subjects;
drop table if exists studentGroup;
drop table if exists teacherTeachesInGroups;

CREATE TABLE teacher
(personalNumber varchar(4), 
 surname varchar(50),
 position varchar(20),
 department varchar(50),
 speciality varchar (50),
 homePhone int check (homePhone > 0),
 primary key (personalNumber, speciality)
);

insert into teacher
(personalNumber, surname, position, department, speciality, homePhone)
values
('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'АСОИ', 487 ),
('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'ЭВМ', 487 ),
('222Л', 'Костин', 'Доцент', 'ЭВМ', 'ЭВМ', 543),
('225Л', 'Бойко', 'Профессор', 'АСУ', 'АСОИ', 112 ),
('225Л', 'Бойко', 'Профессор', 'АСУ', 'ЭВМ', 112 ),
('430Л', 'Глазов', 'Ассистент', 'ТФ', 'СД', 421 ),
('110Л', 'Петров', 'Ассистент', 'Экономики', 'Международная экономика', 324 );



CREATE TABLE subjects
(subjectCodeNumber varchar(4) primary key, 
 subjectName varchar(50),
 hoursNumber int check(hoursNumber > 0),
 speciality varchar (50),
 semester int check (semester > 0)
);

insert into subjects
(subjectCodeNumber, subjectName, hoursNumber, speciality, semester)
values
('12П', 'Мини ЭВМ', 36, 'ЭВМ', 1),
('14П', 'ПЭВМ', 72, 'ЭВМ', 2),
('17П', 'СУБД ПК', 48, 'АСОИ', 4),
('18П', 'ВКСС', 52, 'АСОИ', 6),
('34П', 'Физика', 30, 'СД', 6),
('22П', 'Аудит', 24, 'Бухучета', 3);


CREATE TABLE studentGroup
(groupNumber varchar(3) primary key, 
 groupName varchar(5),
 personsNumber int check (personsNumber > 0),
 speciality varchar (50),
 headmanSurname varchar(50)
);

insert into studentGroup
( groupNumber, groupName, personsNumber, speciality, headmanSurname)
values
('8Г', 'Э-12', 18, 'ЭВМ', 'Иванова'),
('7Г', 'Э-15', 22, 'ЭВМ', 'Сеткин'),
('4Г', 'АС-9', 24, 'АСОИ', 'Балабанов'),
('3Г', 'АС-8', 20, 'АСОИ', 'Чижов'),
('17Г', 'С-14', 29, 'СД', 'Амросов'),
('12Г', 'М-6', 16, 'Международная экономика', 'Трубин'),
('10Г', 'Б-4', 21, 'Бухучет', 'Зязюткин');


CREATE TABLE teacherTeachesInGroups
(groupNumber varchar(3), 
 subjectCodeNumber varchar(4),
 personalNumber varchar(4),
 audienceNumber int,
 primary key (groupNumber, subjectCodeNumber,personalNumber, audienceNumber)
);

insert into teacherTeachesInGroups
(groupNumber, subjectCodeNumber, personalNumber, audienceNumber)
values
('8Г', '12П', '222Л', 112), ('8Г', '14П', '221Л', 220),
('8Г', '17П', '222Л', 112), ('7Г', '14П', '221Л', 220),
('7Г', '17П', '222Л', 241), ('7Г', '18П', '225Л', 210),
('4Г', '12П', '222Л', 112), ('4Г', '18П', '225Л', 210),
('3Г', '12П', '222Л', 112), ('3Г', '17П', '221Л', 241),
('3Г', '18П', '225Л', 210), ('17Г', '12П', '222Л', 112),
('17Г', '22П', '110Л', 220), ('17Г', '34П', '430Л', 118),
('12Г', '12П', '222Л', 112), ('12Г', '22П', '110Л', 210),
('10Г', '12П', '222Л', 210), ('10Г', '22П', '110Л', 210);



# 1.1. Получить полную информацию обо всех преподавателях. 
SELECT * FROM teacher;


#1.2. Получить полную информацию обо всех студенческих группах на специальности ЭВМ.
SELECT * FROM studentGroup
WHERE speciality IN  ('ЭВМ');


#1.3. Получить личный номер преподавателя и номера аудиторий, в которых они преподают предмет с кодовым номером 18П.
SELECT DISTINCT teacherTeachesInGroups.personalNumber, teacherTeachesInGroups.audienceNumber
FROM teacherTeachesInGroups
WHERE teacherTeachesInGroups.subjectCodeNumber = '18П';

#1.4. Получить номера предметов и названия предметов, которые ведет преподаватель Костин.
SELECT DISTINCT teacherTeachesInGroups.subjectCodeNumber, subjects.subjectName FROM teacherTeachesInGroups
INNER JOIN subjects
ON teacherTeachesInGroups.subjectCodeNumber = subjects.subjectCodeNumber
WHERE teacherTeachesInGroups.personalNumber = '222Л';

#1.5. Получить номер группы, в которой ведутся предметы преподавателем Фроловым.
SELECT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
WHERE teacherTeachesInGroups.personalNumber = '221Л';

#1.6. Получить информацию о предметах, которые ведутся на специальности АСОИ.
SELECT * FROM subjects
WHERE speciality IN ('АСОИ');

#1.7. Получить информацию о преподавателях, которые ведут предметы на специальности АСОИ. (исправить)
SELECT DISTINCT teacher.* FROM teacher
INNER JOIN teacherTeachesInGroups
ON teacherTeachesInGroups.personalNumber = teacher.personalNumber
WHERE teacherTeachesInGroups.subjectCodeNumber IN ('17П','18П');

#1.8. Получить фамилии преподавателей, которые ведут предметы в 210 аудитории.
SELECT DISTINCT teacher.surname FROM teacher
JOIN teacherTeachesInGroups
ON teacher.personalNumber = teacherTeachesInGroups.personalNumber
WHERE teacherTeachesInGroups.audienceNumber = 210;

#1.9. Получить названия предметов и названия групп, которые ведут занятия в аудиториях с 100 по 200.
SELECT DISTINCT subjects.subjectName, studentGroup.groupName
FROM teacherTeachesInGroups
INNER JOIN subjects
ON teacherTeachesInGroups.subjectCodeNumber = subjects.subjectCodeNumber
INNER JOIN studentGroup
ON teacherTeachesInGroups.groupNumber = studentGroup.groupNumber
WHERE teacherTeachesInGroups.audienceNumber BETWEEN 100 AND 200;

#1.10. Получить пары номеров групп с одной специальности. 
SELECT studGroup1.groupNumber
FROM studentGroup studGroup1, studentGroup studGroup2
WHERE studGroup1.speciality = studGroup2.speciality AND studGroup2.groupNumber != studGroup1.groupNumber; 

#1.11. Получить общее количество студентов, обучающихся на специальности ЭВМ.
SELECT SUM(studentGroup.personsNumber) AS 'Students count' FROM studentGroup
WHERE studentGroup.speciality = 'ЭВМ';

#1.12. Получить номера преподавателей, обучающих студентов по специальности ЭВМ. (под словом номера были поняты домашние номера телефона)
SELECT DISTINCT teacher.homePhone FROM teacher
INNER JOIN teacherTeachesInGroups
ON teacherTeachesInGroups.personalNumber = teacher.personalNumber
WHERE teacherTeachesInGroups.groupNumber IN ('8Г', '7Г');

#1.13. Получить номера предметов, изучаемых всеми студенческими группами.
SELECT teacherTeachesInGroups.subjectCodeNumber FROM teacherTeachesInGroups
GROUP BY teacherTeachesInGroups.subjectCodeNumber
HAVING COUNT(teacherTeachesInGroups.groupNumber) = (SELECT COUNT(*) FROM subjects);

#1.14. Получить фамилии преподавателей, преподающих те же предметы, что и преподаватель преподающий предмет с номером 14П.
SELECT teacher.surname FROM teacher
INNER JOIN teacherTeachesInGroups
ON teacher.personalNumber = teacherTeachesInGroups.personalNumber
WHERE teacherTeachesInGroups.subjectCodeNumber IN
(SELECT teacherTeachesInGroups.subjectCodeNumber FROM teacherTeachesInGroups # предметы, который преподаёт преподаватель
WHERE teacherTeachesInGroups.personalNumber IN (
SELECT teacherTeachesInGroups.personalNumber FROM teacherTeachesInGroups # преподаватель преподающий предмет 14П
WHERE teacherTeachesInGroups.subjectCodeNumber = '14П'
))
group by teacher.surname;

#1.15. Получить информацию о предметах, которые не ведет преподаватель с личным номером 221П.
SELECT DISTINCT subjects.* FROM subjects
INNER JOIN teacherTeachesInGroups
ON teacherTeachesInGroups.subjectCodeNumber = subjects.subjectCodeNumber
WHERE teacherTeachesInGroups.personalNumber != '221Л';

#1.16. Получить информацию о предметах, которые не изучаются в группе М-6.
SELECT DISTINCT subjects.* FROM subjects
WHERE subjects.subjectCodeNumber NOT IN(
SELECT teacherTeachesInGroups.subjectCodeNumber FROM teacherTeachesInGroups
INNER JOIN studentGroup
ON studentGroup.groupNumber = teacherTeachesInGroups.groupNumber
WHERE studentGroup.groupName = 'М-6'
);

#1.17. Получить информацию о доцентах, преподающих в группах 3Г и 8Г.
SELECT DISTINCT teacher.* FROM teacher
INNER JOIN teacherTeachesInGroups
ON teacherTeachesInGroups.personalNumber = teacher.personalNumber
WHERE (teacher.position = 'Доцент' AND teacherTeachesInGroups.groupNumber IN ('8Г', '3Г'));

#1.18. Получить номера предметов, номера преподавателей, номера групп, в которых ведут занятия преподаватели с кафедры ЭВМ, имеющих специальность АСОИ.
SELECT DISTINCT teacherTeachesInGroups.subjectCodeNumber, teacherTeachesInGroups.personalNumber, teacherTeachesInGroups.groupNumber
FROM teacherTeachesInGroups
INNER JOIN teacher
ON teacher.personalNumber = teacherTeachesInGroups.personalNumber
WHERE (teacher.department = 'ЭВМ' AND teacher.speciality = 'АСОИ');

#1.19. Получить номера групп с такой же специальностью, что и специальность преподавателей.
SELECT DISTINCT studentGroup.groupNumber FROM studentGroup
INNER JOIN teacher  
ON studentGroup.speciality = teacher.speciality;

#1.20. Получить номера преподавателей с кафедры ЭВМ, преподающих предметы по специальности, совпадающей со специальностью студенческой группы.
SELECT DISTINCT teacher.homePhone FROM teacher
INNER JOIN teacherTeachesInGroups
ON teacherTeachesInGroups.personalNumber = teacher.personalNumber
INNER JOIN subjects, studentGroup
WHERE teacher.department = 'ЭВМ' AND studentGroup.speciality = subjects.speciality ;


#1.21. Получить специальности студенческой группы, на которых работают преподаватели кафедры АСУ.
SELECT DISTINCT studentGroup.speciality FROM studentGroup
INNER JOIN teacher
ON teacher.speciality = studentGroup.speciality
WHERE teacher.department = 'АСУ';


#1.22. Получить номера предметов, изучаемых группой АС-8.
SELECT teacherTeachesInGroups.subjectCodeNumber FROM teacherTeachesInGroups
INNER JOIN studentGroup
ON studentGroup.groupNumber = teacherTeachesInGroups.groupNumber
WHERE studentGroup.groupName = 'АС-8';

#1.23. Получить номера студенческих групп, которые изучают те же предметы, что и студенческая группа АС-8.
SELECT DISTINCT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
WHERE teacherTeachesInGroups.groupNumber IN (
SELECT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
INNER JOIN studentGroup
ON studentGroup.groupNumber = teacherTeachesInGroups.groupNumber
WHERE studentGroup.groupName = 'АС-8');

#1.24. Получить номера студенческих групп, которые не изучают предметы, преподаваемых в студенческой группе АС-8.
SELECT DISTINCT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
WHERE teacherTeachesInGroups.groupNumber NOT IN(
SELECT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
INNER JOIN studentGroup
ON studentGroup.groupNumber = teacherTeachesInGroups.groupNumber
WHERE studentGroup.groupName = 'АС-8'
);
#1.25. Получить номера студенческих групп, которые не изучают предметы, преподаваемых преподавателем 430Л.
SELECT DISTINCT teacherTeachesInGroups.groupNumber FROM teacherTeachesInGroups
WHERE teacherTeachesInGroups.personalNumber != '430Л';

#1.26. Получить номера преподавателей, работающих с группой Э-15, но не преподающих предмет 12П.
SELECT DISTINCT teacherTeachesInGroups.personalNumber FROM teacherTeachesInGroups
JOIN studentGroup
ON  teacherTeachesInGroups.groupNumber = studentGroup.groupNumber
WHERE studentGroup.groupName = 'Э-15' AND teacherTeachesInGroups.subjectCodeNumber != '12П';


drop table if exists providers;
drop table if exists details;
drop table if exists projects;
drop table if exists dependencies;

CREATE TABLE providers (
  id_provider VARCHAR(5) PRIMARY KEY NOT NULL,
  name_provider VARCHAR(20),
  state VARCHAR(20),
  city VARCHAR(20)
);

CREATE TABLE details (
  id_detail VARCHAR(5) PRIMARY KEY NOT NULL,
  name_detail VARCHAR(20),
  color VARCHAR(20),
  size INT,
  city VARCHAR(20)
);

CREATE TABLE projects (
  id_project VARCHAR(5) PRIMARY KEY NOT NULL,
  name_project VARCHAR(20),
  city VARCHAR(20)
);

CREATE TABLE dependencies (
  id_provider VARCHAR(5),
  id_detail VARCHAR(5),
  id_project VARCHAR(5),
  counter INT
);

INSERT INTO providers VALUES
  ('П1', 'Петров', '20', 'Москва'),
  ('П2', 'Синицын', '10', 'Лондон'),
  ('П3', 'Федоров', '30', 'Лондон'),
  ('П4', 'Чаянов', '20', 'Минск'),
  ('П5', 'Крюков', '30', 'Киев');

INSERT INTO details VALUES
  ('Д1', 'Болт', 'Красный', 12, 'Москва'),
  ('Д2', 'Гайка', 'Зеленый', 17, 'Минск'),
  ('Д3', 'ДИск', 'Черный', 17, 'Вильнюс'),
  ('Д4', 'Диск', 'Черный', 14, 'Москва'),
  ('Д5', 'Корпус', 'Красный', 12, 'Минск'),
  ('Д6', 'Крышки', 'Красный', 19, 'Москва');

INSERT INTO projects VALUES
  ('ПР1', 'ИПР1', 'Минск'),
  ('ПР2', 'ИПР2', 'Лондон'),
  ('ПР3', 'ИПР3', 'Псков'),
  ('ПР4', 'ИПР4', 'Псков'),
  ('ПР5', 'ИПР4', 'Москва'),
  ('ПР6', 'ИПР6', 'Саратов'),
  ('ПР7', 'ИПР7', 'Москва');
  
  INSERT INTO dependencies VALUES
  ('П1','Д1','ПР1','200'),
  ('П1','Д1','ПР2','700'),
  ('П2','Д3','ПР1','400'),
  ('П2','Д2','ПР2','200'),
  ('П2','Д3','ПР3','200'),
  ('П2','Д3','ПР4','500'),
  ('П2','Д3','ПР5','600'),
  ('П2','Д3','ПР6','400'),
  ('П2','Д3','ПР7','800'),
  ('П2','Д5','ПР2','100'),
  ('П3','Д3','ПР1','200'),
  ('П3','Д4','ПР2','500'),
  ('П4','Д6','ПР3','300'),
  ('П4','Д6','ПР7','300'),
  ('П5','Д2','ПР2','200'),
  ('П5','Д2','ПР4','100'),
  ('П5','Д5','ПР5','500'),
  ('П5','Д5','ПР7','100'),
  ('П5','Д6','ПР2','200'),
  ('П5','Д1','ПР2','100'),
  ('П5','Д3','ПР4','200'),
  ('П5','Д4','ПР4','800'),
  ('П5','Д5','ПР4','400'),
  ('П5','Д6','ПР4','500');
  
  # Из-за отсуствия Лондона в базе данных запросы 2, 28 и 30 ничего не выводили. Для демонстрации работы кода Таллин был заменён на Лондон. 
#2  Получить полную информацию обо всех проектах в Лондоне. 
SELECT * FROM projects  WHERE city = 'Лондон';

#5 Получить все сочетания "цвета деталей-города деталей"
SELECT  color, city FROM details;

#6 Получить все такие тройки "номера поставщиков-номера деталей-номера проектов", для которых выводимые поставщик, деталь и проект размещены в одном городе. 
SELECT DISTINCT id_provider, id_detail, id_project 
FROM  providers, details, projects 
WHERE providers.city = details.city AND details.city = projects.city;

#13 Получить номера проектов, обеспечиваемых по крайней мере одним поставщиком не из того же города.
SELECT DISTINCT DP.id_project FROM dependencies DP 
JOIN providers PV ON DP.id_provider = PV.id_provider 
JOIN projects PR ON DP.id_project = PR.id_project 
WHERE PR.city != PV.city;

#18 Получить номера деталей, поставляемых для некоторого проекта со средним количеством больше 320
SELECT id_detail FROM dependencies  group by id_detail HAVING avg(counter) > 320;

#20 Получить цвета деталей, поставляемых поставщиком П1.
SELECT DISTINCT color FROM details det 
JOIN dependencies dep ON dep.id_detail = det.id_detail AND id_provider = 'П1';

#24 Получить номера поставщиков со статусом, меньшим чем у поставщика П1. 
SELECT id_provider FROM providers 
WHERE state < (SELECT state FROM providers WHERE id_provider = 'П1');

#25 Получить номера проектов, город которых стоит первым в алфавитном списке городов. 
SELECT id_project FROM projects ORDER BY city LIMIT 1;

#28 Получить номера проектов, для которых не поставляются красные детали поставщиками из Лондона.
SELECT DISTINCT id_project FROM dependencies
JOIN providers
ON dependencies.id_provider = providers.id_provider
JOIN details
ON dependencies.id_detail = details.id_detail
WHERE providers.city = 'Лондон' and details.color != 'Красный';

#30 Получить номера деталей, поставляемых для лондонских проектов. 
 SELECT DISTINCT id_detail FROM dependencies d 
 JOIN projects p ON d.id_project=p.id_project  AND p.city = 'Лондон';
 
  
