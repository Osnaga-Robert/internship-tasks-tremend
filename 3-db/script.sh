#! /bin/bash

CONTAINER_NAME="postgres_container"
DB_NAME="company_db"
USER_NAME="ituser"
USER_PASS="itpass"
ADMIN_NAME="admin_cee"
ADMIN_PASS="admin_cee"
LOG_FILE="log.log"

docker run --name $CONTAINER_NAME -e POSTGRES_DB=$DB_NAME -e POSTGRES_USER=$USER_NAME -e POSTGRES_PASSWORD=$USER_PASS -d postgres

sleep 10

docker exec -i $CONTAINER_NAME psql -U $USER_NAME -d $DB_NAME -c "CREATE USER $ADMIN_NAME WITH PASSWORD '$ADMIN_PASS';"

docker cp dump.sql $CONTAINER_NAME:/dump.sql

docker exec -i $CONTAINER_NAME psql -U $USER_NAME -d $DB_NAME -f /dump.sql

docker exec -i postgres_container psql  -U ituser -d company_db -c "
SELECT COUNT(*) FROM employees;" > $LOG_FILE

read -p "Write the department: " department && docker exec -i postgres_container psql -U ituser -d company_db -c "
SELECT e.first_name, e.last_name FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name ='$department';" >> $LOG_FILE

docker exec -i postgres_container psql  -U ituser -d company_db -c "
SELECT d.department_name, MIN(s.salary), MAX(s.salary) FROM departments d 
JOIN employees e ON d.department_id = e.department_id 
JOIN salaries s ON s.employee_id = e.employee_id 
GROUP BY d.department_name;" >> $LOG_FILE

