-- ###########################################
-- ##       TAREA FINAL BASE DE DATOS       ##
-- ###########################################
-- consultas hacia la base de datos.
-- Son 30 consultas

-- 1 : ¿Cuántos empleados hay en total en la base de datos?
select count(*) as EMPLEADOS from employees;

-- 2 : ¿Cuál es el salario más alto y el salario más bajo que se ha pagado en la historia de la empresa?
select max(salary) as MAXIMO, min(salary) as MINIMO from salaries;

-- 3: ¿Cuál es el salario promedio de todos los empleados?
select avg(salary) as PROMEDIO from salaries;

-- 4: Genera un reporte que muestre cuántos empleados hay de cada género (M y F).
select gender, count(*) TOTAL from employees group by gender;

-- 5:  ¿Cuántos empleados han ostentado cada cargo (title) a lo largo del tiempo? Ordena los resultados del cargo más común al menos común.
select title, count(*) as TOTAL from titles group by title order by count(*) desc;

-- 6: Muestra los cargos que han sido ocupados por más de 75,000 personas.
select title, count(*) as TOTAL from titles group by title having count(*) > 75000;

-- 7: ¿Cuántos empleados masculinos y femeninos hay por cada cargo?
select t.title, e.gender, count(*) from titles t join employees e on t.emp_no = e.emp_no group by t.title, e.gender order by t.title, e.gender;

-- 8: Muestra una lista de todos los empleados (emp_no, first_name) junto al nombre del departamento en el que trabajan actualmente.
select e.emp_no, e.first_name, e.last_name, d.dept_name from employees e
join current_dept_emp cde on e.emp_no = cde.emp_no
join departments d on cde.dept_no = d.dept_no;

-- 9: Obtén el nombre y apellido de todos los empleados que trabajan en el departamento de "Marketing".
select e.first_name, e.last_name from employees e
join current_dept_emp cde on e.emp_no = cde.emp_no
join departments d on cde.dept_no = d.dept_no where d.dept_name = "Marketing";

-- 10: Genera una lista de los gerentes de departamento (managers) actuales,
-- mostrando su número de empleado, nombre completo y el nombre del departamento que dirigen.
select e.emp_no, e.first_name, e.last_name, d.dept_name from employees e
join dept_manager dm on e.emp_no = dm.emp_no
join departments d on d m.dept_no = d.dept_no where dm.to_date = "9999-01-01";

-- 11: Calcula el salario promedio actual para cada departamento.
-- El reporte debe mostrar el nombre del departamento y su salario promedio.
SELECT d.dept_name, AVG(s.salary) AS avg_salary FROM departments d
JOIN current_dept_emp cde ON d.dept_no = cde.dept_no
JOIN salaries s ON cde.emp_no = s.emp_no WHERE s.to_date = '9999-01-01'
GROUP BY d.dept_name ORDER BY avg_salary DESC;

-- 12: Muestra todos los cargos que ha tenido el empleado número 10006,
-- junto con las fechas de inicio y fin de cada cargo.
select title, from_date, to_date from titles where emp_no=10096 order by from_date;

-- 13: ¿Hay algún departamento que no tenga empleados asignados?
-- (Esta consulta teórica te ayudará a entender LEFT JOIN).
select a.dept_name from departments as a
left join dept_emp as b on a.dept_no = b.dept_no
where b.emp_no is null;

-- 14: Obtén el nombre, apellido y el salario actual de todos los empleados.
select a.first_name, a.last_name, b.salary
from employees as a
join salaries as b on a.emp_no = b.emp_no
where b.to_date = "9999-01-01" order by a.last_name;

-- 15: Encuentra a todos los empleados cuyo salario actual es mayor que el salario promedio de toda la empresa.
select e.first_name, e.last_name, s.salary
from employees as e
join salaries as s
on e.emp_no = s.emp_no
where s.to_date = "9999-01-01"
and s.salary > (
select avg(s2.salary)
from salaries as s2
where s2.to_date = "9999-01-01" )
order by s.salary desc;

-- 16: Usando una subconsulta con IN, muestra el nombre y apellido de todas las
-- personas que son o han sido gerentes de un departamento.
select first_name, last_name
from employees
where emp_no in (select emp_no from dept_manager);

-- 17: Encuentra a todos los empleados que nunca han sido gerentes de un departamento, usando NOT IN.
select first_name, last_name
from employees
where emp_no not in (select emp_no from dept_manager);

-- 18: ¿Quién es el último empleado que fue contratado? Muestra su nombre completo y fecha de contratación. 
select first_name, last_name hire_date
from employees
order by hire_date
desc limit 1;

-- 19: Obtén los nombres de todos los gerentes que han dirigido el departamento de "Development".
select e.first_name from employees as e
join dept_manager as dm on e.emp_no = dm.emp_no
join departments as d on dm.dept_no = d.dept_no
where d.dept_name = "Development"
group by e.first_name;

-- 20: Encuentra al empleado (o empleados) que tiene el salario más alto registrado en la tabla de salarios
select e.first_name, s.salary
from employees as e
join salaries as s
on e.emp_no = s.emp_no 
where s.salary = (
select max(s2.salary)
from salaries as s2 )
group by e.first_name, s.salary;

-- 21: Muestra una lista de los primeros 100 empleados con su nombre y apellido
-- combinados en una sola columna llamada nombre_completo.
select concat(first_name, " ", last_name)
as NOMBRE_COMPLETO
from employees limit 100;

-- 22: Calcula la antigüedad en años de cada empleado (desde hire_date hasta la fecha actual).
-- Muestra el número de empleado y su antigüedad.
select emp_no, timestampdiff(year, hire_date, curdate()) as AnosDeAntigudad from employees;

-- 23: Clasifica los salarios actuales de los empleados en tres categorías:
-- 'Bajo': si es menor a 50,000.
-- 'Medio': si está entre 50,000 y 90,000.
-- 'Alto': si es mayor a 90,000.
select e.first_name, s.salary,
case
 when s.salary < 50000 then "bajo"
 when s.salary between 50000 and 90000 then "medio"
 when s.salary > 90000 then "alto"
end as Categoria
from employees as e
join salaries as s on e.emp_no = s.emp_no
where s.to_date = "9999-01-01"
order by s.salary desc;

-- 24: Genera un reporte que cuente cuántos empleados fueron contratados
-- en cada mes del año (independientemente del año).
select month(hire_date) as mes,
count(*) as total_empleados
from employees
group by mes order by mes;

-- 25: Crea una columna que muestre las iniciales de cada empleado
-- (por ejemplo, para 'Georgi Facello' sería 'G.F.').
select concat(left(first_name,1)," ", left(last_name,1), ".")
from employees;

-- 26: ¿Qué departamento tiene el salario promedio actual más alto?
select d.dept_name, avg(s.salary) as avg_salary
from departments d join dept_emp de on d.dept_no = de.dept_no
join salaries s on de.emp_no = s.emp_no where s.to_date = "9999-01-01"
group by d.dept_name order by avg_salary desc limit 1;

-- 27: Encuentra al gerente que ha estado en su puesto por más tiempo.
-- Muestra su nombre y el número de días en el cargo.
SELECT e.first_name, e.last_name, 
       DATEDIFF(dm.to_date, dm.from_date) AS dias_en_el_cargo
FROM employees AS e
JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
ORDER BY dias_en_el_cargo DESC
LIMIT 1;

-- 28: Para el empleado 10001, calcula la diferencia entre su primer salario y su salario actual.
select
(select salary from salaries where emp_no=10001 order by from_date desc limit 1) - (select salary from salaries where emp_no=10001 order by from_date asc limit 1) as Incremento;

-- 29: Encuentra todos los pares de empleados que fueron contratados en la misma fecha.
SELECT e1.first_name, e1.last_name, e2.first_name, e2.last_name, e1.hire_date
FROM employees e1
JOIN employees e2 ON e1.hire_date=e2.hire_date
ORDER BY e1.hire_date;

-- 30:  ¿Quién es el 'Senior Engineer' con el salario actual más alto en toda la empresa?
-- Muestra su nombre, apellido y salario.
SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE t.title = 'Senior Engineer'
  AND t.to_date = '9999-01-01'
  AND s.to_date = '9999-01-01'
ORDER BY s.salary DESC
LIMIT 1;
