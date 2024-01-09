





-- Проектирование и работа с базой данных
-- Задание 1
-- Спроектировать схему базы данных отражающую следующую информацию о студентах
-- факультета:
-- • ФИО студента
-- • Дата рождения
-- • Адрес проживания (Город, улица, номер дома)
-- • Доступные телефоны для связи (неограниченное количество)
-- • Адрес электронной почты
-- • Группа
-- • Направление обучения
-- • Признак бюджетного/внебюджетного обучения
-- Структура базы данных должна соответствовать третьей нормальной форме и содержать внешние
-- ключи в таблицах.

-- Ответ: СМ файл DB_mysql_data.sql. В нем полностью создается БД. 



-- Задание 2
-- Внести информацию о трех направлениях обучения, по каждому направлению внести не менее
-- трех учебных групп, в каждую группу внести не менее 7 студентов (в разные группы разное
-- количество.

-- Ответ: СМ файл DB_mysql_data.sql. В нем полностью создается БД. 



-- Задание 3
-- На основании внесенных данных создать следующие запросы:
-- • Вывести списки групп по заданному направлению с указание номера группы в формате 
-- ФИО, бюджет/внебюджет. Студентов выводить в алфавитном порядке.
SELECT `Student`.`full_name` as `Full name`, 
		`Student_groups`.`group_name` as `Group name`, 
		if (`Student`.`budget` = 1, "Бюджет", "Внебюджет") as `Budget`
FROM `Student`
JOIN `Student_groups` ON `Student_groups`.`id` = `Student`.`group_id`
ORDER BY `Student`.`full_name`;
 
-- • Вывести студентов с фамилией, начинающейся с первой буквы вашей фамилии, с 
-- указанием ФИО, номера группы и направления обучения. 
SELECT `Student`.`full_name` as `Full name`,
		`Student_groups`.`group_name` as `Group name`,
        `Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Student_groups` ON `Student_groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Student_groups`.`direction_id`
WHERE `Student`.`full_name` LIKE "К%";

-- • Вывести список студентов для поздравления по месяцам в формате Фамилия И.О., день и 
-- название месяца рождения, номером группы и направлением обучения.
SELECT 
-- сначала берем фамилию
CONCAT(LEFT(`full_name`, LOCATE(' ', `full_name`)),
-- получаем и форматируем имя
       CONCAT(LEFT(RIGHT(`full_name`, CHAR_LENGTH(`full_name`) - LOCATE(' ', `full_name`)), 1), '. '),
-- получаем и форматиурем отчество
      CONCAT(LEFT(RIGHT(`full_name`, CHAR_LENGTH(`full_name`) - LOCATE(' ', `full_name`, (LOCATE(' ', `full_name`) + 1))), 1), '.')) 
as `Name`,
-- день 
DAYOFMONTH(`Student`.`date_of_birth`) as `Day`,
-- название месяца
-- для перевода в кириллицу используем case
CASE
	WHEN MONTHNAME(`Student`.`date_of_birth`) = "January" 
    	THEN "Январь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "February" 
    	THEN "Февраль"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "March" 
    	THEN "Март"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "April" 
    	THEN "Апрель"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "May" 
    	THEN "Май"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "June" 
    	THEN "Июнь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "July" 
    	THEN "Июль"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "August" 
    	THEN "Август"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "September" 
    	THEN "Сентябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "October" 
    	THEN "Октябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "November" 
    	THEN "Ноябрь"
    WHEN MONTHNAME(`Student`.`date_of_birth`) = "December" 
    	THEN "Декабрь"
 END AS 'Month',
`Student_groups`.`group_name` as `Group name`,
`Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Student_groups` ON `Student_groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Student_groups`.`direction_id`
ORDER BY MONTH(`Student`.`date_of_birth`); 
-- • Вывести студентов с указанием возраста в годах.
SELECT full_name, (YEAR(CURRENT_DATE()) - YEAR(date_of_birth)) as Age
FROM Student;
-- • Вывести студентов, у которых день рождения в текущем месяце.
SELECT `full_name` as `Name`, `date_of_birth` as `Birthday`
FROM `Student`
WHERE MONTH(`Student`.`date_of_birth`) = MONTH(CURRENT_DATE());

-- • Вывести количество студентов по каждому направлению.
SELECT COUNT(`Student`.`id`) as `Students number`, `Directions_of_study`.`direction_name` as `Direction name`
FROM `Student`
JOIN `Student_groups` ON `Student_groups`.`id` = `Student`.`group_id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Student_groups`.`direction_id`
GROUP BY `Directions_of_study`.`direction_name`;

-- • Вывести количество бюджетных и внебюджетных мест по группам. Для каждой группы
-- вывести номер и название направления.
SELECT 
	Student_groups.group_name, 
    Directions_of_study.direction_name, 
	COUNT(CASE WHEN budget = true THEN 1 ELSE 0 END) as number_of_buget 
FROM Student
	JOIN Student_groups ON Student_groups.id = Student.group_id
    JOIN Directions_of_study ON Directions_of_study.id = Student_groups.direction_id
GROUP BY Student_groups.id




-- Задание 4
-- Добавить в созданную ранее базу данных информацию о преподавателе, предметах и оценках
-- студентов по этим предметам. Для каждого направления регистрируется свой набор учебных
-- предметов и на каждый назначается преподаватель.
-- По каждому предмету студент может получить одну из оценок: 2,3,4,5 и может не иметь оценки
-- Структура базы данных должна соответствовать третьей нормальной форме и содержать внешние
-- ключи в таблицах.
-- Необходимо внести информацию о 7 различных предметах, которые ведут 5 преподавателей.
-- Каждый преподаватель может вести несколько дисциплин.
-- Для каждого направления необходимо внести информацию минимум о трех предметах. Внести
-- оценки минимум 80% студентов по необходимым предметам.

-- Ответ: СМ файл DB_mysql_data.sql. В нем полностью создается БД. 



-- Задание 5
-- • Вывести списки групп по каждому предмету с указанием преподавателя.
SELECT `Disciplines`.`name`, `Student_groups`.`group_name`,`Teachers`.`name`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `DirectionDisciplineTeacher`.`direction_id`
JOIN `Student_groups` ON `Student_groups`.`direction_id` = `Directions_of_study`.`id`
JOIN `Teachers` ON `Teachers`.`id` = `DirectionDisciplineTeacher`.`teacher_id`

-- • Определить, какую дисциплину изучает максимальное количество студентов.
SELECT `Disciplines`.`name` as `disc_name`, COUNT(`Student`.`full_name`) as `s_num`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `Marks` ON `Marks`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`full_name`) DESC 
LIMIT 1

-- • Определить сколько студентов обучатся у каждого их преподавателей.
SELECT `Teachers`.`name`, COUNT(`Student`.`id`) as `s_num`
FROM `Teachers`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`teacher_id` = `Teachers`.`id`
JOIn `Marks` ON `Marks`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `Student`.`id` = `Marks`.`student_id`
GROUP BY `Teachers`.`name`

-- • Определить долю ставших студентов по каждой дисциплине (не оценки или 2 считать не
-- сдавшими).
SELECT `Disciplines`.`name` as `disc_name`, COUNT(IF(`Marks`.`mark` > 2, 1, NULL)) as `s_num`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `Marks` ON `Marks`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`full_name`) DESC

-- • Определить среднюю оценку по предметам (для сдавших студентов)
SELECT `Disciplines`.`name` as `disc_name`, AVG(IF(`Marks`.`mark` > 2, `Marks`.`mark`, NULL)) as `s_avg`
FROM `Disciplines`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`discipline_id` = `Disciplines`.`id`
JOIN `Marks` ON `Marks`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
JOIN `Student` ON `Marks`.`student_id` = `Student`.`id`
GROUP BY `Disciplines`.`name`
ORDER BY COUNT(`Student`.`full_name`) DESC

-- • Определить группу с максимальной средней оценкой (включая не сдавших)
SELECT `Student_groups`.`group_name`, AVG(`Marks`.`mark`) as `average_mark`
FROM `Student_groups`
JOIN `Directions_of_study` ON `Directions_of_study`.`id` = `Student_groups`.`direction_id`
JOIN `DirectionDisciplineTeacher` ON `DirectionDisciplineTeacher`.`direction_id` = `Directions_of_study`.`id`
JOIN `Marks` ON `Marks`.`sub_disc_teach_id` = `DirectionDisciplineTeacher`.`id`
GROUP BY `Student_groups`.`group_name`
LIMIT 1
-- • Вывести студентов со всем оценками отлично и не имеющих несданный экзамен
SELECT Student.full_name, AVG(Marks.mark)
FROM Student
JOIN Marks ON Marks.student_id = Student.id
GROUP BY Student.full_name
HAVING AVG(Marks.mark) = 5.0;
-- • Вывести кандидатов на отчисление (не сдан не менее двух предметов)
SELECT Student.full_name
FROM Student
JOIN Marks ON Marks.student_id = Student.id
WHERE Marks.mark = 2
GROUP BY Student.full_name
HAVING COUNT(*)>1


-- Задание 6
-- Добавить в созданную ранее базу данных информацию
-- • о времени проведения пар (1 пара с 8:00 до 9:30, 2 пара с 9:40 до 11:10 и т.д.),
-- • посещенных студентом занятиях (с привязкой к дате, номеру пары, назначенному
-- предмету и преподавателю.
-- Необходимо внести информацию о посещении для трех групп из разных направлений.


-- Ответ: СМ файл DB_mysql_data.sql. В нем полностью создается БД. 



-- Задание 7
-- На основании внесенных данных создать следующие запросы:
-- • Вывести по заданному предмету количество посещенных занятий.
SELECT COUNT(Attendance.id) as num_presense 
FROM Disciplines
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.discipline_id = Disciplines.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Disciplines.name = "Программирование дискретных структур" AND Attendance.presense = true
GROUP BY Attendance.presense;

-- • Вывести по заданному предмету количество пропущенных занятий.
SELECT COUNT(Attendance.id) as num_presense 
FROM Disciplines
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.discipline_id = Disciplines.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Disciplines.name = "Программирование дискретных структур" AND Attendance.presense = false
GROUP BY Attendance.presense;

-- • Вывести по заданному преподавателю количество студентов на каждом занятии.
SELECT COUNT(Attendance.id) as num_presense, DirectionDisciplineTeacher.id
FROM Teachers
JOIN DirectionDisciplineTeacher ON DirectionDisciplineTeacher.teacher_id = Teachers.id
JOIN Lessons_shedule ON Lessons_shedule.sub_disc_teach_id = DirectionDisciplineTeacher.id
JOIN Attendance ON Attendance.schedule_id = Lessons_shedule.id
WHERE Teachers.name = "Шиловский Дмитрий Михайлович" AND Attendance.presense = true
GROUP BY Lessons_shedule.sub_disc_teach_id;
-- • Для каждого студента вывести общее время, потраченное на изучение каждого предмета.


DROP TRIGGER IF EXISTS student_insert;
DELIMITER //
CREATE TRIGGER student_insert BEFORE INSERT ON Student
FOR EACH ROW BEGIN 

IF (NOT (NEW.email REGEXP "[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+")) THEN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Некорректный email.';
END IF;
IF (NOT (NEW.full_name REGEXP "([A-Я]{1}[а-я]+[[:space:]]){2}[А-Я]{1}[а-я]+")) THEN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Некорректное имя.';
END IF;
IF (NOT (SELECT COUNT(Student_groups.id) FROM Student_groups WHERE Student_groups.id = NEW.group_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой группы не существует.';
END IF;
IF(DATE(NEW.date_of_birth) > DATE(CURDATE())) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Неправильная дата рождения.';
END IF;
END //
DELIMITER ;


DROP TRIGGER IF EXISTS student_update;

DELIMITER //
CREATE TRIGGER student_update BEFORE UPDATE ON Student
FOR EACH ROW BEGIN 

IF (NOT(NEW.email REGEXP "[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+")) THEN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Некорректный email.';
END IF;
IF (NOT(NEW.full_name REGEXP "([A-Я]{1}[а-я]+[[:space:]]){1}[А-Я]{1}[а-я]+")) THEN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Некорректное имя.';
END IF;
IF (NOT(SELECT COUNT(Student_groups.id) FROM Student_groups WHERE Student_groups.id = NEW.group_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой группы не существует. Сначала создайте такую группу';
END IF;
IF(DATE(NEW.date_of_birth) > DATE(CURDATE())) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Неправильная дата рождения.';
END IF;

END //
DELIMITER ;

DROP TRIGGER IF EXISTS student_delete;

DELIMITER //
CREATE TRIGGER student_delete BEFORE DELETE ON Student
FOR EACH ROW BEGIN

DELETE FROM Phone_numbers WHERE Phone_numbers.student_id = OLD.id;
DELETE FROM Attendance WHERE Attendance.student_id = OLD.id;
DELETE FROM Marks WHERE student_id = OLD.id;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS Phone_numbers_insert;

DELIMITER //
CREATE TRIGGER Phone_numbers_insert BEFORE INSERT ON Phone_numbers
FOR EACH ROW BEGIN

IF (NOT(NEW.phone_number REGEXP "^[+]7(9[0-9]{9})$")) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Некорректный номер телефона.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS Phone_numbers_update;

DELIMITER //
CREATE TRIGGER Phone_numbers_update BEFORE UPDATE ON Phone_numbers
FOR EACH ROW BEGIN

IF (NOT(NEW.phone_number REGEXP "^[+]7(9[0-9]{9})$")) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Некорректный номер телефона.';
END IF;

END //
DELIMITER ;


DROP TRIGGER  IF EXISTS Student_groups_insert;
DELIMITER //
CREATE TRIGGER  Student_groups_insert BEFORE INSERT ON Student_groups
FOR EACH ROW BEGIN

IF (NOT(SELECT COUNT(Directions_of_study.id) FROM Directions_of_study WHERE Directions_of_study.id = NEW.direction_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого направления обучения не существует. Сначала создайте его.';
END IF;

END //
DELIMITER ;


DROP TRIGGER  IF EXISTS Student_groups_update;
DELIMITER //
CREATE TRIGGER Student_groups_update BEFORE UPDATE ON Student_groups
FOR EACH ROW BEGIN

IF (NOT(SELECT COUNT(Directions_of_study.id) FROM Directions_of_study WHERE Directions_of_study.id = NEW.direction_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого направления обучения не существует. Сначала создайте его.';
END IF;

END //
DELIMITER ;


DROP TRIGGER  IF EXISTS Student_groups_delete;
DELIMITER //
CREATE TRIGGER Student_groups_delete BEFORE DELETE ON Student_groups
FOR EACH ROW BEGIN

IF ((SELECT COUNT(Student.id) FROM Student WHERE Student.group_id = OLD.id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Вы пытаетесь удалить группу к которой привязан/ны студенты. Сначала перезакрепите их к другим группам.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS marks_insert;
DELIMITER //
CREATE TRIGGER marks_insert BEFORE INSERT ON Marks
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(Student.id) FROM Student WHERE Student.id = NEW.student_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Вы пытаетесь внести оценки для несуществующего студента.';
END IF;
IF(NOT(SELECT COUNT(DirectionDisciplineTeacher.id) FROM DirectionDisciplineTeacher WHERE DirectionDisciplineTeacher.id = NEW.sub_disc_teach_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Вы пытаетесь внести оценку по набору: направление, дисициплина, преподователь; которого не существует.';
END IF;
IF((NEW.mark < 0) OR (NEW.mark > 5)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Поставтье оценку в диапозне от 0 до 5.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS marks_update;
DELIMITER //
CREATE TRIGGER marks_update BEFORE UPDATE ON Marks
FOR EACH ROW BEGIN

IF((NEW.mark < 0) OR (NEW.mark > 5)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Поставтье оценку в диапозне от 0 до 5.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS DirectionDisciplineTeacher_insert;
DELIMITER //
CREATE TRIGGER DirectionDisciplineTeacher_insert BEFORE INSERT ON DirectionDisciplineTeacher
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(Directions_of_study.id) FROM Directions_of_study WHERE Directions_of_study.id = NEW.direction_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого направления обучения не существует.';
END IF;
IF(NOT(SELECT COUNT(Disciplines.id) FROM Disciplines WHERE Disciplines.id = NEW.discipline_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой дисциплины не существует.';
END IF;
IF(NOT(SELECT COUNT(Teachers.id) FROM Teachers WHERE Teachers.id = NEW.teacher_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого преподавателя не существует.';
END IF;
END //
DELIMITER ;


DROP TRIGGER IF EXISTS DirectionDisciplineTeacher_update;
DELIMITER //
CREATE TRIGGER DirectionDisciplineTeacher_update BEFORE UPDATE ON DirectionDisciplineTeacher
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(Directions_of_study.id) FROM Directions_of_study WHERE Directions_of_study.id = NEW.direction_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого направления обучения не существует.';
END IF;
IF(NOT(SELECT COUNT(Disciplines.id) FROM Disciplines WHERE Disciplines.id = NEW.discipline_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой дисциплины не существует.';
END IF;
IF(NOT(SELECT COUNT(Teachers.id) FROM Teachers WHERE Teachers.id = NEW.teacher_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого преподавателя не существует.';
END IF;
END //
DELIMITER ;


DROP TRIGGER IF EXISTS Lessons_shedule_insert;
DELIMITER //
CREATE TRIGGER Lessons_shedule_insert BEFORE INSERT ON Lessons_shedule
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(DirectionDisciplineTeacher.id) FROM DirectionDisciplineTeacher WHERE DirectionDisciplineTeacher.id = NEW.sub_disc_teach_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого набора направления дисциплины и преподавателя не существует.';
END IF;
IF(NOT(SELECT COUNT(Pair_time.id) FROM Pair_time WHERE Pair_time.id = NEW.time_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой пары в расписании нет.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS Lessons_shedule_update;
DELIMITER //
CREATE TRIGGER Lessons_shedule_update BEFORE UPDATE ON Lessons_shedule
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(DirectionDisciplineTeacher.id) FROM DirectionDisciplineTeacher WHERE DirectionDisciplineTeacher.id = NEW.sub_disc_teach_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого набора направления дисциплины и преподавателя не существует.';
END IF;
IF(NOT(SELECT COUNT(Pair_time.id) FROM Pair_time WHERE Pair_time.id = NEW.time_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такой пары в расписании нет.';
END IF;

END //
DELIMITER ;

DROP TRIGGER IF EXISTS Attendance_insert;
DELIMITER //
CREATE TRIGGER Attendance_insert BEFORE INSERT ON Attendance
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(Lessons_shedule.id) FROM Lessons_shedule WHERE Lessons_shedule.id = NEW.schedule_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Вы пытаетесь проставить посещаемость по паре, которой нет в расписании.';
END IF;
IF(NOT(SELECT COUNT(Student.id) FROM Student WHERE Student.id = NEW.student_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого студента нет.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS Attendance_update;
DELIMITER //
CREATE TRIGGER Attendance_update BEFORE UPDATE ON Attendance
FOR EACH ROW BEGIN

IF(NOT(SELECT COUNT(Lessons_shedule.id) FROM Lessons_shedule WHERE Lessons_shedule.id = NEW.schedule_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Вы пытаетесь проставить посещаемость по паре, которой нет в расписании.';
END IF;
IF(NOT(SELECT COUNT(Student.id) FROM Student WHERE Student.id = NEW.student_id)) THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Такого студента нет.';
END IF;

END //
DELIMITER ;


DROP TRIGGER IF EXISTS teachers_insert;
DELIMITER //
CREATE TRIGGER teachers_insert BEFORE INSERT ON Teachers
FOR EACH ROW BEGIN

IF (NOT(NEW.name REGEXP "([A-Я]{1}[а-я]+[[:space:]]){2}[А-Я]{1}[а-я]+")) THEN
    SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Некорректное имя.';
END IF;

END //
DELIMITER ;
