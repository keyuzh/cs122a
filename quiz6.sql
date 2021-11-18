Emp (eid: integer PRIMARY KEY, ename: string, age: integer, salary: decimal(8,2));
Works (eid: integer, did: integer, pcttime: integer, PRIMARY KEY (eid, did));
Dept (did: integer PRIMARY KEY, dname: string, budget: decimal(8,2), managerid: integer);

SELECT E.ename, E.salary, D.dname
FROM Dept D, Emp E, Works W
WHERE E.eid = W.eid AND W.did = D.did AND D.did IN 
(SELECT D.did
FROM Emp E, Works W, Dept D
WHERE D.managerid = W.did AND W.eid = E.eid AND E.salary > D.budget);


SELECT E.eid, E.ename, E.age
FROM Emp E
WHERE (SELECT COUNT(DISTINCT W.did) FROM Works W WHERE W.eid = E.eid) = (SELECT COUNT(D.did) FROM Dept D)



SELECT MIN(E.age), MAX(E.age), SUM(E.salary)
FROM Emp E, Dept D, Works W
WHERE D.did = W.did AND W.eid = E.eid AND D.did IN 
(SELECT D.did FROM Dept D GROUP BY D.did HAVING 10 <= (SELECT COUNT(*) FROM Works W WHERE W.did = D.did))


WITH man AS (SELECT D.did, D.managerid AS mid, E.ename as mname
FROM Dept D, Emp E
WHERE D.managerid = E.eid)

SELECT E.eid, E.ename, E.age, W.pcttime, D.did, D.dname, M.mid, M.mname
FROM (Emp E LEFT OUTER JOIN Works W ON E.eid = W.eid) LEFT OUTER JOIN man M ON M.did = W.did

UPDATE Emp
SET salary = salary * 0.9
WHERE eid IN (SELECT E.eid FROM Emp E ORDER BY E.salary DESC LIMIT 1)