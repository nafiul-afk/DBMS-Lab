-- ============================================================
--  University Database Schema
--  Based on the Schema Diagram for University Database
-- ============================================================

-- ----------------------------------------------------------------
-- 1. department
-- ----------------------------------------------------------------
CREATE TABLE department (
    dept_name   VARCHAR(50)     NOT NULL,
    building    VARCHAR(50),
    budget      NUMERIC(12, 2),
    CONSTRAINT pk_department PRIMARY KEY (dept_name)
);

-- ----------------------------------------------------------------
-- 2. course
-- ----------------------------------------------------------------
CREATE TABLE course (
    course_id   VARCHAR(10)     NOT NULL,
    title       VARCHAR(100)    NOT NULL,
    dept_name   VARCHAR(50),
    credits     NUMERIC(2, 0),
    CONSTRAINT pk_course PRIMARY KEY (course_id),
    CONSTRAINT fk_course_dept
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- 3. prereq
-- ----------------------------------------------------------------
CREATE TABLE prereq (
    course_id   VARCHAR(10)     NOT NULL,
    prereq_id   VARCHAR(10)     NOT NULL,
    CONSTRAINT pk_prereq PRIMARY KEY (course_id, prereq_id),
    CONSTRAINT fk_prereq_course
        FOREIGN KEY (course_id)  REFERENCES course (course_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_prereq_prereq
        FOREIGN KEY (prereq_id) REFERENCES course (course_id)
);

-- ----------------------------------------------------------------
-- 4. instructor
-- ----------------------------------------------------------------
CREATE TABLE instructor (
    ID          VARCHAR(10)     NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    dept_name   VARCHAR(50),
    salary      NUMERIC(10, 2),
    CONSTRAINT pk_instructor PRIMARY KEY (ID),
    CONSTRAINT fk_instructor_dept
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- 5. student
-- ----------------------------------------------------------------
CREATE TABLE student (
    ID          VARCHAR(10)     NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    dept_name   VARCHAR(50),
    tot_cred    NUMERIC(4, 0)   DEFAULT 0,
    CONSTRAINT pk_student PRIMARY KEY (ID),
    CONSTRAINT fk_student_dept
        FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- 6. advisor
-- ----------------------------------------------------------------
CREATE TABLE advisor (
    s_id        VARCHAR(10)     NOT NULL,   -- student ID
    i_id        VARCHAR(10),                -- instructor ID
    CONSTRAINT pk_advisor PRIMARY KEY (s_id),
    CONSTRAINT fk_advisor_student
        FOREIGN KEY (s_id) REFERENCES student (ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_advisor_instructor
        FOREIGN KEY (i_id) REFERENCES instructor (ID)
        ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- 7. classroom
-- ----------------------------------------------------------------
CREATE TABLE classroom (
    building    VARCHAR(50)     NOT NULL,
    room_number VARCHAR(10)     NOT NULL,
    capacity    NUMERIC(4, 0),
    CONSTRAINT pk_classroom PRIMARY KEY (building, room_number)
);

-- ----------------------------------------------------------------
-- 8. time_slot
-- ----------------------------------------------------------------
CREATE TABLE time_slot (
    time_slot_id    VARCHAR(10)     NOT NULL,
    day             VARCHAR(10)     NOT NULL,
    start_time      TIME            NOT NULL,
    end_time        TIME            NOT NULL,
    CONSTRAINT pk_time_slot PRIMARY KEY (time_slot_id, day, start_time)
);

-- ----------------------------------------------------------------
-- 9. section
-- ----------------------------------------------------------------
CREATE TABLE section (
    course_id       VARCHAR(10)     NOT NULL,
    sec_id          VARCHAR(10)     NOT NULL,
    semester        VARCHAR(10)     NOT NULL,
    year            NUMERIC(4, 0)   NOT NULL,
    building        VARCHAR(50),
    room_number     VARCHAR(10),
    time_slot_id    VARCHAR(10),
    CONSTRAINT pk_section
        PRIMARY KEY (course_id, sec_id, semester, year),
    CONSTRAINT fk_section_course
        FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_section_classroom
        FOREIGN KEY (building, room_number)
        REFERENCES classroom (building, room_number)
        ON DELETE SET NULL,
    CONSTRAINT fk_section_time_slot
        FOREIGN KEY (time_slot_id) REFERENCES time_slot (time_slot_id)
        ON DELETE SET NULL
);

-- ----------------------------------------------------------------
-- 10. teaches
-- ----------------------------------------------------------------
CREATE TABLE teaches (
    ID          VARCHAR(10)     NOT NULL,   -- instructor ID
    course_id   VARCHAR(10)     NOT NULL,
    sec_id      VARCHAR(10)     NOT NULL,
    semester    VARCHAR(10)     NOT NULL,
    year        NUMERIC(4, 0)   NOT NULL,
    CONSTRAINT pk_teaches
        PRIMARY KEY (ID, course_id, sec_id, semester, year),
    CONSTRAINT fk_teaches_instructor
        FOREIGN KEY (ID) REFERENCES instructor (ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_teaches_section
        FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE
);

-- ----------------------------------------------------------------
-- 11. takes
-- ----------------------------------------------------------------
CREATE TABLE takes (
    ID          VARCHAR(10)     NOT NULL,   -- student ID
    course_id   VARCHAR(10)     NOT NULL,
    sec_id      VARCHAR(10)     NOT NULL,
    semester    VARCHAR(10)     NOT NULL,
    year        NUMERIC(4, 0)   NOT NULL,
    grade       VARCHAR(2),
    CONSTRAINT pk_takes
        PRIMARY KEY (ID, course_id, sec_id, semester, year),
    CONSTRAINT fk_takes_student
        FOREIGN KEY (ID) REFERENCES student (ID)
        ON DELETE CASCADE,
    CONSTRAINT fk_takes_section
        FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE
);

-- ============================================================
--  End of University Database Schema
-- ============================================================
