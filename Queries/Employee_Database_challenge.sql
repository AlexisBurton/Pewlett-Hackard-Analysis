SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
	INTO retirement_titles
	FROM employees as e
	LEFT JOIN title as t ON (e.emp_no = t.emp_no)
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