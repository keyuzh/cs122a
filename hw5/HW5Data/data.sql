

\COPY swoosh.Users FROM 'users.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Student FROM 'students.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Instructor FROM 'instructors.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.InstructorEducation FROM 'instructor_education.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Course FROM 'courses.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Recurrence FROM 'recurrences.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Meeting FROM 'meetings.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Recording FROM 'recordings.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Post FROM 'posts.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.PostTopics FROM 'post_topics.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Attended FROM 'attended.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Watched FROM 'watched.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.WatchedSegment FROM 'watched_segment.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.EnrolledIn FROM 'enrolled_in.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.Teaches FROM 'teaches.csv' DELIMITER ',' CSV HEADER;
\COPY swoosh.ThumbsUp FROM 'thumbs_up.csv' DELIMITER ',' CSV HEADER;
