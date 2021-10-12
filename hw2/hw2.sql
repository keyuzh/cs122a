DROP SCHEMA cs122a_hw CASCADE;
CREATE SCHEMA IF NOT EXISTS cs122a_hw;

-- SQL DDLs for Entities and their supporting tables

DROP TABLE IF EXISTS cs122a_hw.Users;
CREATE TABLE cs122a_hw.Users (
    u_id        integer NOT NULL,
    name_first  text NOT NULL,
    name_last   text NOT NULL,
    email       text NOT NULL,
    PRIMARY KEY (u_id)
);

DROP TABLE IF EXISTS cs122a_hw.Students;
CREATE TABLE cs122a_hw.Students (
    u_id        integer REFERENCES cs122a_hw.Users ON DELETE CASCADE,
    occupation  text,
    PRIMARY KEY(u_id)
);

DROP TABLE IF EXISTS cs122a_hw.Instructors;
DROP TABLE IF EXISTS cs122a_hw.Instructors_degrees;
DROP TABLE IF EXISTS cs122a_hw.Instructors_majors;
DROP TABLE IF EXISTS cs122a_hw.Instructors_schools;
DROP TABLE IF EXISTS cs122a_hw.Instructors_year;
CREATE TABLE cs122a_hw.Instructors (
    u_id        integer REFERENCES cs122a_hw.Users ON DELETE CASCADE,
    title       text,
    PRIMARY KEY(u_id)
);
CREATE TABLE cs122a_hw.Instructors_degrees(
    u_id        integer REFERENCES cs122a_hw.Instructors ON DELETE CASCADE,
    degree      text NOT NULL,
    PRIMARY KEY(u_id, degree)
);
CREATE TABLE cs122a_hw.Instructors_majors(
    u_id        integer REFERENCES cs122a_hw.Instructors ON DELETE CASCADE,
    major       text NOT NULL,
    PRIMARY KEY(u_id, major)
);
CREATE TABLE cs122a_hw.Instructors_schools(
    u_id        integer REFERENCES cs122a_hw.Instructors ON DELETE CASCADE,
    school      text NOT NULL,
    PRIMARY KEY(u_id, school)
);
CREATE TABLE cs122a_hw.Instructors_year(
    u_id        integer REFERENCES cs122a_hw.Instructors ON DELETE CASCADE,
    graduation_year     decimal(4,0) NOT NULL,
    PRIMARY KEY(u_id, graduation_year)
);

DROP TABLE IF EXISTS cs122a_hw.Courses;
CREATE TABLE cs122a_hw.Courses (
    course_id           integer NOT NULL,
    course_name         text NOT NULL,
    course_description  text,
    u_id                integer NOT NULL,
    PRIMARY KEY (course_id),
    FOREIGN KEY (u_id) REFERENCES cs122a_hw.Instructors
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS cs122a_hw.Recurrences;
CREATE TYPE cs122a_hw.days_of_week AS ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');
CREATE TABLE cs122a_hw.Recurrences(
    recurr_id   integer NOT NULL,
    repeat_on   cs122a_hw.days_of_week NOT NULL,
    end_date    date NOT NULL,
    PRIMARY KEY(recurr_id)
);

DROP TABLE IF EXISTS cs122a_hw.Meetings;
CREATE TABLE cs122a_hw.Meetings(
    meeting_id      integer NOT NULL,
    meeting_name    text NOT NULL,
    passcode        text,
    start_at        timestamp NOT NULL,
    mute_participants   boolean NOT NULL,
    duration        time NOT NULL,
    u_id            integer NOT NULL, --fold Host relationship
    -- course_id fold Associated relationship between meetings and courses
    course_id       integer NOT NULL,
    PRIMARY KEY(meeting_id),
    FOREIGN KEY(u_id) REFERENCES cs122a_hw.Instructors
        ON DELETE CASCADE,
    FOREIGN KEY(course_id) REFERENCES cs122a_hw.Courses
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS cs122a_hw.Recordings;
CREATE TABLE cs122a_hw.Recordings(
    recording_id    integer NOT NULL,
    start_time      timestamp,
    end_time        timestamp,
    meeting_id      integer NOT NULL, -- fold Recorded relationship
    PRIMARY KEY(recording_id),
    FOREIGN KEY(meeting_id) REFERENCES cs122a_hw.Meetings
        ON DELETE CASCADE
);

DROP TABLE IF EXISTS cs122a_hw.Posts;
DROP TABLE IF EXISTS cs122a_hw.Posts_topics;
CREATE TABLE cs122a_hw.Posts(
    post_id     integer NOT NULL,
    post_type   text NOT NULL,
    post_body   text,
    created_at  timestamp NOT NULL,
    meeting_id  integer NOT NULL, -- fold PostAbout relationship
    reply_to    integer, -- post_id of original post if the post is a reply to another post
    u_id        integer NOT NULL, -- fold PostedBy relationship
    PRIMARY KEY(post_id),
    FOREIGN KEY(meeting_id) REFERENCES cs122a_hw.Meetings
        ON DELETE CASCADE,
    FOREIGN KEY(u_id) REFERENCES cs122a_hw.Users
        ON DELETE CASCADE
);
CREATE TABLE cs122a_hw.Posts_topics(
    post_id     integer REFERENCES cs122a_hw.Posts ON DELETE CASCADE,
    post_topic  text NOT NULL,
    PRIMARY KEY(post_id, post_topic)
);





--SQL DDLs for Relationships 
DROP TABLE IF EXISTS cs122a_hw.Enrolled_in;
CREATE TABLE cs122a_hw.Enrolled_in(
    u_id        integer REFERENCES cs122a_hw.Students ON DELETE CASCADE,
    course_id   integer REFERENCES cs122a_hw.Courses ON DELETE CASCADE,
    enroll_date date NOT NULL,
    PRIMARY KEY(u_id, course_id)
);

DROP TABLE IF EXISTS cs122a_hw.Teaches;
CREATE TABLE cs122a_hw.Teaches(
    u_id        integer REFERENCES cs122a_hw.Instructors ON DELETE CASCADE,
    course_id   integer REFERENCES cs122a_hw.Courses ON DELETE CASCADE,
    PRIMARY KEY(u_id, course_id)
);

DROP TABLE IF EXISTS cs122a_hw.Attend;
CREATE TABLE cs122a_hw.Attend(
    u_id        integer REFERENCES cs122a_hw.Students ON DELETE CASCADE,
    meeting_id  integer REFERENCES cs122a_hw.Meetings ON DELETE CASCADE,
    PRIMARY KEY(u_id, meeting_id)
);

DROP TABLE IF EXISTS cs122a_hw.RecursOn;
CREATE TABLE cs122a_hw.RecursOn(
    recurr_id   integer REFERENCES cs122a_hw.Recurrences ON DELETE CASCADE,
    meeting_id  integer REFERENCES cs122a_hw.Meetings ON DELETE CASCADE,
    PRIMARY KEY(meeting_id)
);

DROP TABLE IF EXISTS cs122a_hw.ThumbsUp;
CREATE TABLE cs122a_hw.ThumbsUp(
    u_id        integer REFERENCES cs122a_hw.Users ON DELETE CASCADE,
    post_id     integer REFERENCES cs122a_hw.Posts ON DELETE CASCADE,
    PRIMARY KEY(u_id, post_id)
);

DROP TABLE IF EXISTS cs122a_hw.Watched;
DROP TABLE IF EXISTS cs122a_hw.Watched_segments;
CREATE TABLE cs122a_hw.Watched(
    u_id            integer REFERENCES cs122a_hw.Students ON DELETE CASCADE,
    recording_id    integer REFERENCES cs122a_hw.Recordings ON DELETE CASCADE,
    PRIMARY KEY(u_id, recording_id)
);
CREATE TABLE cs122a_hw.Watched_segments(
    u_id            integer,
    recording_id    integer,
    segment_from    time NOT NULL,
    segment_to      time NOT NULL,
    watch_id        integer NOT NULL,
    FOREIGN KEY(u_id, recording_id) REFERENCES cs122a_hw.Watched ON DELETE CASCADE,
    PRIMARY KEY(u_id, recording_id, watch_id)
);
