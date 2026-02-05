create database Online_Learning_Platform;

use Online_learning_Platform;

create table students(
student_id int primary key auto_increment,
name varchar(50) Not Null,
email varchar(50) Not Null,
Country varchar(50),
Signup_date date
);

create table instructors(
instructor_id int primary key auto_increment,
name varchar(50),
bio varchar(50),
expertise varchar(50)
);


create table courses(
course_id int primary key auto_increment,
course_title varchar(50),
instructor_id int,
category varchar(50),
price int,
foreign key (instructor_id) references instructors(instructor_id)
);


create table enrollments(
Enrollment_id int primary key auto_increment,
student_id int,
foreign key (student_id) references students(student_id),
course_id int,
foreign key (course_id) references courses(course_id),
enrollment_date date,
completion_date date
);

create table modules(
module_id int primary key auto_increment,
course_id int,
foreign key (course_id) references courses(course_id),
module_title varchar(50),
sequence_number varchar(50));


create table quizzes(
quiz_id int primary key auto_increment,
module_id int,
foreign key(module_id) references modules(module_id),
quiz_title varchar(50),
max_score int);

INSERT INTO students (name, email, country, signup_date) VALUES
('Vaibhav Bhasme', 'vaibhav@gmail.com', 'Luxembourg', '2025-01-10'),
('Yogesh Ghodmare', 'yogesh@gmail.com', 'India', '2025-02-15'),
('Ayush Waghmare', 'ayush@gmail.com', 'USA', '2025-03-05'),
('Vinit Giri', 'vinit@gmail.com', 'Spain', '2025-03-22'),
('Sushrut Deogirkar', 'sushrut@gmail.com', 'Canada', '2025-04-01');

INSERT INTO instructors (name, bio, expertise) VALUES
('Yash Kaswate', 'Data Scientist', 'Data Science'),
('Khushendra Fule', 'Full-stack developer and trainer', 'Web Development'),
('Sofia Martinez', 'Certified Cloud Architect', 'Cloud Computing');


INSERT INTO courses (course_title, instructor_id, category, price) VALUES
('Introduction to Data Science', 1, 'Data Science', 499.99),
('Web Development Bootcamp', 2, 'Programming', 399.50),
('AWS Cloud Fundamentals', 3, 'Cloud Computing', 599.00),
('Advanced Machine Learning', 1, 'AI & ML', 799.99);

INSERT INTO enrollments (student_id, course_id, enrollment_date, completion_date) VALUES
(1, 1, '2025-02-01', '2025-03-15'),
(2, 1, '2025-02-10', NULL),
(3, 2, '2025-03-05', '2025-04-20'),
(4, 3, '2025-03-15', NULL),
(5, 4, '2025-04-10', NULL);

INSERT INTO modules (course_id, module_title, sequence_number) VALUES
(1, 'Introduction to Data', 1),
(1, 'Python for Data Science', 2),
(2, 'HTML & CSS Basics', 1),
(2, 'JavaScript Essentials', 2),
(3, 'AWS Overview', 1),
(3, 'Deploying on AWS', 2),
(4, 'Supervised Learning', 1),
(4, 'Unsupervised Learning', 2);

INSERT INTO quizzes (module_id, quiz_title, max_score) VALUES
(1, 'Data Basics Quiz', 20),
(2, 'Python Quiz', 30),
(3, 'HTML & CSS Quiz', 25),
(4, 'JavaScript Quiz', 30),
(5, 'AWS Overview Quiz', 20),
(6, 'Deployment Quiz', 25),
(7, 'Supervised Learning Quiz', 30),
(8, 'Unsupervised Learning Quiz', 30);

-- Assignment Questions and there Queriesssss

-- Q:-List all courses a specific student is enrolled in

SELECT s.name AS student_name, c.course_title
FROM enrollments e
INNER JOIN students s ON e.student_id = s.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE s.name = 'Vaibhav Bhasme';

-- Q:-Calculate the course completion rate (percentage of enrollments with a completion_date) 
select * from enrollments;
SELECT (COUNT(completion_date) / COUNT(*)) * 100 AS completion_rate_percentage
FROM enrollments;

-- Q:-Find the instructor with the most courses

SELECT i.name AS instructor_name, COUNT(c.course_id) AS total_courses
FROM instructors i
JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id
ORDER BY total_courses DESC
LIMIT 1;

-- Q:-Identify students who have enrolled in more than 5 courses 

SELECT s.name, COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.course_id) > 5;

-- Q:-Calculate the total revenue generated per course category 

SELECT c.category, SUM(c.price) AS total_revenue
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.category;

-- Q:-List all modules for a specific course in sequence order 

SELECT c.course_title, m.module_title, m.sequence_number
FROM modules m
JOIN courses c ON m.course_id = c.course_id
WHERE c.course_title = 'Introduction to Data Science'
ORDER BY m.sequence_number;

-- Q:-Find courses that have no enrolled students

SELECT c.course_title
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;  

-- Q:-Calculate the average number of enrollments per course

SELECT 
    ROUND(COUNT(e.enrollment_id) / COUNT(DISTINCT c.course_id), 2) AS avg_enrollments_per_course
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id; 

-- Q Identify the most popular course category

SELECT c.category, COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.category
ORDER BY total_enrollments DESC
LIMIT 1; 

-- Q:- Find students who have not completed any courses they enrolled in

SELECT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING SUM(CASE WHEN e.completion_date IS NOT NULL THEN 1 ELSE 0 END) = 0; 

