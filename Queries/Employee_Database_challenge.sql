--Deliverable 1

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
	INTO retirement_titles
	FROM employees as e
	INNER JOIN title as t ON (e.emp_no = t.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY e.emp_no;

SELECT DISTINCT ON(emp_no)emp_no, first_name, last_name, title
	INTO unique_titles
	FROM retirement_titles
	ORDER BY emp_no,
			 to_date DESC;

SELECT COUNT (title), title
	INTO retiring_titles
	FROM unique_titles	
	GROUP BY title
	ORDER BY count DESC;

--Deliverable 2

SELECT DISTINCT ON (e.emp_no)e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, t.title
	INTO mentorship_eligibility
	FROM employees as e
	INNER JOIN dept_emp as de ON (e.emp_no = de.emp_no)
	INNER JOIN title as t ON (e.emp_no = t.emp_no)
	WHERE (de.to_date = '9999-01-01') 
		AND (e.birth_date BETWEEN '01-01-1965' AND '12-31-1965')
	ORDER BY e.emp_no,
			 t.to_date DESC;

-- Deliverable 3
-- Added information: 
  --Compare retirees to total workforce of each dept
    SELECT e.emp_no, e.first_name, e.last_name, de.dept_no,d.dept_name
        INTO current_employees
        FROM employees as e
        INNER JOIN dept_emp as de ON (e.emp_no = de.emp_no)
        INNER JOIN departments as d ON (de.dept_no = d.dept_no)
        WHERE (de.to_date = '9999-01-01');

    SELECT ce.dept_no, ce.dept_name, COUNT(ce.emp_no)as total_emp, rbd.count as retiring_emp
    	INTO loss_by_dept
    	FROM current_employees as ce
    	INNER JOIN ret_by_dept as rbd ON (ce.dept_no = rbd.dept_no)
    	GROUP BY ce.dept_name,
			 rbd.count,
			 ce.dept_no
    	ORDER BY ce.dept_no; 

  -- Compare mentorship eligible to retiring by dept
    SELECT ce.dept_no, ce.dept_name, count(me.emp_no) as mentorship_eligible 
    	INTO mentorship_by_dept
    	FROM mentorship_eligibility as me
    	INNER JOIN current_employees as ce ON (me.emp_no = ce.emp_no)
    	GROUP BY ce.dept_no,
    			 ce.dept_name;

    SELECT mbd.dept_no, mbd.dept_name, mbd.mentorship_eligible, rbd.count as retiring
    	INTO mentor_v_retiring
    	FROM mentorship_by_dept as mbd
    	INNER JOIN ret_by_dept as rbd ON (mbd.dept_no = rbd.dept_no)
  
  -- Compare mentorship eligible to retiring by title
    SELECT m.count as mentorship_eligible, r.count as retiring, r.title
        INTO mentor_v_retiring_title
        FROM retiring_titles as r
        LEFT JOIN mentorship_by_title as m ON (r.title = m.title)
