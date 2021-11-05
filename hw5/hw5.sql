-- 1. Find the course id of the course with the name ‘Programming’.

SELECT C.course_id
FROM swoosh.Course C
WHERE C.course_name = 'Programming';

-- 2. List the DISTINCT topics of the posts made by users whose last name is ‘Cross’. 

SELECT DISTINCT T.topic
FROM swoosh.Post P, swoosh.PostTopics T 
WHERE P.post_id = T.post_id AND P.user_id IN 
(SELECT U.user_id
FROM swoosh.Users U
WHERE U.last_name = 'Cross');

-- 3. List the recording ids for recordings of meetings about the course ‘Advanced Math’. Order your results by id in 
-- ascending order and limit them to the first 10.
SELECT R.recording_id
FROM swoosh.Recording R, swoosh.Meeting M
WHERE R.meeting_id = M.meeting_id AND M.course_id IN
(SELECT C.course_id FROM swoosh.Course C WHERE C.course_name = 'Advanced Math')
ORDER BY R.recording_id ASC 
LIMIT 10;

-- 4. For recurring meetings that recur on Fridays, find the total number of DISTINCT students who attended these meetings.

SELECT COUNT(DISTINCT A.user_id)
FROM swoosh.attended A
WHERE A.meeting_id IN 
(SELECT M.meeting_id
FROM swoosh.Meeting M, swoosh.Recurrence R
WHERE M.recurr_id = R.recurr_id AND R.repeat_on = 'Fri');

-- 5. List the user_id of students enrolled in courses that are taught by all instructors with title=’Professor’ or 
-- ‘Assistant Professor’.) Order your results by user_id in ascending order, and limit them to the top 10.

SELECT DISTINCT E.user_id
FROM swoosh.EnrolledIn E, swoosh.Teaches T
WHERE E.course_id = T.course_id AND T.user_id IN (
SELECT I.user_id
FROM swoosh.Instructor I
WHERE I.title = 'Professor' OR I.title = 'Assistant Professor')
ORDER BY E.user_id ASC
LIMIT 10;

-- 6. List the post_id of all the non-empty (i.e. the body of the post was not empty) posts about meetings hosted by an 
-- ‘Assistant Professor’. Again, order your results on post_id in descending order and limit them to the first 5 rows.

SELECT P.post_id
FROM swoosh.Post P
WHERE P.body IS NOT NULL AND P.meeting_id IN 
(SELECT M.meeting_id
FROM swoosh.Meeting M, swoosh.Instructor I
WHERE M.instructor_id = I.user_id AND I.title = 'Assistant Professor')
ORDER BY P.post_id DESC
LIMIT 5;

-- 7. Find the post ids and the number of replies for each post that has one or more replies. List only the top five 
-- posts that have the highest number of replies.

SELECT P1.post_id, COUNT(*) AS num_of_replies
FROM swoosh.Post P1, swoosh.Post P2
WHERE P1.post_id = P2.replied_to_post_id
GROUP BY P1.post_id
-- HAVING COUNT(*) >= 1
ORDER BY num_of_replies DESC
LIMIT 5;

-- 8. For posts that have more than two Thumbsup’s, print their post_id, the post author's first and last name, and the
--  number of posts that the post author has posted.

WITH post AS (SELECT T.post_id
                FROM swoosh.ThumbsUp T
                GROUP BY T.post_id
                HAVING COUNT(*) > 2)
SELECT post.post_id, U.first_name, U.last_name, temp.num_posted
FROM post, swoosh.Post P, swoosh.Users U,
                (SELECT P.user_id, COUNT(*) AS num_posted
                FROM swoosh.Post P
                GROUP BY P.user_id) AS temp
WHERE temp.user_id = U.user_id AND post.post_id = P.post_id AND P.user_id = U.user_id;
