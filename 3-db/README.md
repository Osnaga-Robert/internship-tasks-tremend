# PostgreSQL Container

## 1. Pull and run a PostgreSQL container

- docker run --name postgres_container -e POSTGRES_DB=company_db -e POSTGRES_USER=ituser -e POSTGRES_PASSWORD=ituser -d postgres
- --name flag: to name the container
- -e flag: to set the environment variables
  - POSTGRES_DB: to set the name of the database
  - POSTGRES_USER: to set the username
  - POSTGRES_PASSWORD: to set the password
- -d flag: to run the container in the background

## 2. Create a dataset using the sql script

- docker cp populatedb.sql postgres_container:/populatedb.sql
- docker exec -i postgres_container psql -U ituser -d company_db -f populatedb.sql

## 3. Run queries on the database

### 3.1. Find the total number of employees

- docker exec -i postgres_container psql -U ituser -d company_db -c "SELECT COUNT(*) FROM employees;"
- -c flag: to run the command
- SELECT COUNT(*): to count the number of rows in the employees table

### 3.2 Retrieve the names of employees in a specific department


- read -p "Write the department: " department && docker exec -i postgres_container psql -U ituser -d company_db -c "SELECT e.first_name, e.last_name FROM employees e JOIN departments d ON e.department_id = d.department_id WHERE d.department_name ='$department';"
- I used the read command to get the department name from the user using -p flag for the prompt message
- join the employees and departments tables to get the first name and last name of employees in the specified department

### 3.3 Find the minimum and maximum salary for each department

- docker exec -i postgres_container psql -U ituser -d company_db -c "SELECT d.department_name, MIN(s.salary), MAX(s.salary) FROM departments d JOIN employees e ON d.department_id = e.department_id JOIN salaries s ON s.employee_id = e.employee_id GROUP BY d.department_name";
- join the departments, employees, and salaries tables
- group by department name and calculate the minimum and maximum salary for each department
- use the MIN and MAX functions to get the minimum and maximum salary

## 4. Dump the dataset into a file

- docker exec -i postgres_container pg_dump -U ituser company_db > dump.sql

## 5.Write a Bash script

- I used constants for values that can be changed
- after running the script, I put a sleep command to keep the container formatting
- for importing the dataset, I used the psql command with the -f flag to specify the file
- for saving the queries from step 3, I append the output to a file using for the first query '>' and for the rest '>>'

## Bonus (Mount a persistent volume to store PostgreSQL data.)

- docker stop postgres_container
- docker remove postgres_container
- docker volume create pg_data
- docker run --name postgres_container -e POSTGRES_DB=company_db -e POSTGRES_USER=ituser -e POSTGRES_PASSWORD=ituser -v pg_data:/var/lib/postgresql/data -d postgres
- -v flag: to mount the volume
  - pg_data:/var/lib/postgresql/data: to mount the volume pg_data to the container's data directory
- for testing, I imported the dataset and run one query, removed the container, and created a new one with the same volume, and the data was still there after running the same query

# Conclusion

I was not familiar with PostgreSQL before, I was using MySQL, but I found it very similar.\
The populatedb.sql script needed some changes to work with PostgreSQL, but it was easy to fix.\
I really didn't knwo what was a dump file before, but I found it very useful to backup the database.\
After a little bit of recapping, the SQL queries were easy to write.\
The script was a little tricky, about that sleep period that I needed to let the container process.
