CREATE TABLE regions (
    region_id     INT,
    region_name   VARCHAR(25)
);

CREATE TABLE countries (
    country_id    CHAR(2),
    country_name  VARCHAR(40),
    region_id     INT
);

CREATE TABLE locations (
    location_id    INT,
    street_address VARCHAR(25),
    postal_code    VARCHAR(12),
    city           VARCHAR(30),
    state_province VARCHAR(12),
    country_id     CHAR(2)
);

CREATE TABLE departments (
    department_id   INT,
    department_name VARCHAR(30),
    manager_id      INT,
    location_id     INT
);

CREATE TABLE employees (
    employee_id    INT,
    first_name     VARCHAR(20),
    last_name      VARCHAR(25),
    email          VARCHAR(25),
    phone_number   VARCHAR(20),
    hire_date      DATE,
    job_id         VARCHAR(10),
    salary         DECIMAL(10,2),
    commission_pct DECIMAL(5,2),
    manager_id     INT,
    department_id  INT
);

CREATE TABLE jobs (
    job_id     VARCHAR(10),
    job_title  VARCHAR(35),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
);

CREATE TABLE job_grades (
    grade_level VARCHAR(2),
    lowest_sal  DECIMAL(10,2),
    highest_sal DECIMAL(10,2)
);

CREATE TABLE job_history (
    employee_id   INT,
    start_date    DATE,
    end_date      DATE,
    job_id        VARCHAR(10),
    department_id INT
);

