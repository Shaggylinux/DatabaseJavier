-- Sección 1: Consultas de Agregación y Agrupación (Conceptos Fundamentales)

-- 1. Conteo General: ¿Cuántos empleados hay en total en la base de datos?
SELECT
  COUNT(*) AS total_empleados
FROM employees;

-- 2. Salarios Extremos: ¿Cuál es el salario más alto y el salario más bajo que se ha
--    pagado en la historia de la empresa?
SELECT
  MAX(salary) AS salario_mas_alto,
  MIN(salary) AS salario_mas_bajo
FROM salaries;

-- 3. Promedio Salarial: ¿Cuál es el salario promedio de todos los empleados?
SELECT
  AVG(salary) AS salario_promedio
FROM salaries;

-- 4. Agrupación por Género: Genera un reporte que muestre cuántos empleados hay
--    de cada género (M y F).
SELECT
  gender,
  COUNT(*) AS numero_de_empleados
FROM employees
GROUP BY
  gender;

-- 5. Conteo de Cargos: ¿Cuántos empleados han ostentado cada cargo (title) a lo largo
--    del tiempo? Ordena los resultados del cargo más común al menos común.
SELECT
  title,
  COUNT(*) AS numero_de_empleados
FROM titles
GROUP BY
  title
ORDER BY
  numero_de_empleados DESC;

-- 6. Filtro de Grupos con HAVING: Muestra los cargos que han sido ocupados por más
--    de 75,000 personas.
SELECT
  title,
  COUNT(*) AS numero_de_empleados
FROM titles
GROUP BY
  title
HAVING
  COUNT(*) > 75000;

-- 7. Agrupación Múltiple: ¿Cuántos empleados masculinos y femeninos hay por cada
--    cargo?
SELECT
  t.title,
  e.gender,
  COUNT(e.emp_no) AS numero_de_empleados
FROM titles AS t
JOIN employees AS e
  ON t.emp_no = e.emp_no
GROUP BY
  t.title,
  e.gender
ORDER BY
  t.title,
  e.gender;


-- Sección 2: JOINs y Combinación de Múltiples Tablas

-- 8. Nombres de Departamentos: Muestra una lista de todos los empleados (emp_no,
--    first_name) junto al nombre del departamento en el que trabajan actualmente.
SELECT
  e.emp_no,
  e.first_name,
  e.last_name,
  d.dept_name
FROM employees AS e
JOIN current_dept_emp AS cde
  ON e.emp_no = cde.emp_no
JOIN departments AS d
  ON cde.dept_no = d.dept_no;

-- 9. Empleados de un Departamento Específico: Obtén el nombre y apellido de todos
--    los empleados que trabajan en el departamento de "Marketing".
SELECT
  e.first_name,
  e.last_name
FROM employees AS e
JOIN current_dept_emp AS cde
  ON e.emp_no = cde.emp_no
JOIN departments AS d
  ON cde.dept_no = d.dept_no
WHERE
  d.dept_name = 'Marketing';

-- 10. Gerentes Actuales: Genera una lista de los gerentes de departamento
--     (managers) actuales, mostrando su número de empleado, nombre completo y el
--     nombre del departamento que dirigen.
SELECT
  e.emp_no,
  e.first_name,
  e.last_name,
  d.dept_name
FROM employees AS e
JOIN dept_manager AS dm
  ON e.emp_no = dm.emp_no
JOIN departments AS d
  ON dm.dept_no = d.dept_no
WHERE
  dm.to_date = '9999-01-01';

-- 11. Salario por Departamento: Calcula el salario promedio actual para cada
--     departamento. El reporte debe mostrar el nombre del departamento y su salario
--     promedio.
SELECT
  d.dept_name,
  AVG(s.salary) AS salario_promedio
FROM departments AS d
JOIN current_dept_emp AS cde
  ON d.dept_no = cde.dept_no
JOIN salaries AS s
  ON cde.emp_no = s.emp_no
WHERE
  s.to_date = '9999-01-01'
GROUP BY
  d.dept_name
ORDER BY
  salario_promedio DESC;

-- 12. Historial de Cargos de un Empleado: Muestra todos los cargos que ha tenido el
--     empleado número 10006, junto con las fechas de inicio y fin de cada cargo.
SELECT
  title,
  from_date,
  to_date
FROM titles
WHERE
  emp_no = 10006
ORDER BY
  from_date;

-- 13. Departamentos sin Empleados (LEFT JOIN): ¿Hay algún departamento que no
--     tenga empleados asignados?
SELECT
  d.dept_name
FROM departments AS d
LEFT JOIN dept_emp AS de
  ON d.dept_no = de.dept_no
WHERE
  de.emp_no IS NULL;

-- 14. Salario Actual del Empleado: Obtén el nombre, apellido y el salario actual de
--     todos los empleados.
SELECT
  e.first_name,
  e.last_name,
  s.salary
FROM employees AS e
JOIN salaries AS s
  ON e.emp_no = s.emp_no
WHERE
  s.to_date = '9999-01-01'
ORDER BY
  e.last_name;


-- Sección 3: Subconsultas (Consultas Anidadas)
departmentsdept_nodept_name
-- 15. Salarios por Encima del Promedio: Encuentra a todos los empleados cuyo salario
--     actual es mayor que el salario promedio de toda la empresa.
SELECT
  e.first_name,
  e.last_name,
  s.salary
FROM employees AS e
JOIN salaries AS s
  ON e.emp_no = s.emp_no
WHERE
  s.to_date = '9999-01-01' AND s.salary > (
    SELECT
      AVG(salary)
    FROM salaries
    WHERE
      to_date = '9999-01-01'
  )
ORDER BY
  s.salary DESC;

-- 16. Nombres de los Gerentes: Usando una subconsulta con IN, muestra el nombre y
--     apellido de todas las personas que son o han sido gerentes de un departamento.
SELECT
  first_name,
  last_name
FROM employees
WHERE
  emp_no IN (
    SELECT
      emp_no
    FROM dept_manager
  );

-- 17. Empleados que no son Gerentes: Encuentra a todos los empleados que nunca
--     han sido gerentes de un departamento, usando NOT IN.
SELECT
  first_name,
  last_name
FROM employees
WHERE
  emp_no NOT IN (
    SELECT
      emp_no
    FROM dept_manager
  );

-- 18. Último Empleado Contratado: ¿Quién es el último empleado que fue contratado?
--     Muestra su nombre completo y fecha de contratación.
SELECT
  first_name,
  last_name,
  hire_date
FROM employees
ORDER BY
  hire_date DESC
LIMIT 1;

-- 19. Jefes del Departamento de "Development": Obtén los nombres de todos los
--     gerentes que han dirigido el departamento de "Development".
SELECT
  e.first_name,
  e.last_name
FROM employees AS e
JOIN dept_manager AS dm
  ON e.emp_no = dm.emp_no
JOIN departments AS d
  ON dm.dept_no = d.dept_no
WHERE
  d.dept_name = 'Development'
GROUP BY
  e.first_name,
  e.last_name;

-- 20. Empleados con el Salario Máximo: Encuentra al empleado (o empleados) que
--     tiene el salario más alto registrado en la tabla de salarios.
SELECT
  e.first_name,
  e.last_name,
  s.salary
FROM employees AS e
JOIN salaries AS s
  ON e.emp_no = s.emp_no
WHERE
  s.salary = (
    SELECT
      MAX(salary)
    FROM salaries
  )
GROUP BY
  e.first_name,
  e.last_name,
  s.salary;


-- Sección 4: Funciones Avanzadas (Manipulación de Datos)

-- 21. Nombres Completos: Muestra una lista de los primeros 100 empleados con su
--     nombre y apellido combinados en una sola columna llamada nombre_completo.
SELECT
  CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM employees
LIMIT 100;

-- 22. Antigüedad del Empleado: Calcula la antigüedad en años de cada empleado
--     (desde hire_date hasta la fecha actual). Muestra el número de empleado y su
--     antigüedad.
SELECT
  emp_no,
  TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS antiguedad_en_anos
FROM employees;

-- 23. Categorización de Salarios con CASE: Clasifica los salarios actuales de los
--     empleados en tres categorías: 'Bajo', 'Medio', 'Alto'.
SELECT
  e.first_name,
  e.last_name,
  s.salary,
  CASE
    WHEN s.salary < 50000
    THEN 'Bajo'
    WHEN s.salary >= 50000 AND s.salary <= 90000
    THEN 'Medio'
    ELSE 'Alto'
  END AS categoria_salario
FROM employees AS e
JOIN salaries AS s
  ON e.emp_no = s.emp_no
WHERE
  s.to_date = '9999-01-01'
ORDER BY
  s.salary DESC;

-- 24. Mes de Contratación: Genera un reporte que cuente cuántos empleados fueron
--     contratados en cada mes del año (independientemente del año).
SELECT
  MONTH(hire_date) AS mes,
  COUNT(*) AS numero_de_contrataciones
FROM employees
GROUP BY
  mes
ORDER BY
  mes;

-- 25. Iniciales de Empleados: Crea una columna que muestre las iniciales de cada
--     empleado (por ejemplo, para 'Georgi Facello' sería 'G.F.').
SELECT
  CONCAT(LEFT(first_name, 1), '.', LEFT(last_name, 1), '.') AS iniciales
FROM employees;


-- Sección 5: Desafío Final (Combinando Todo)

-- 26. Departamento con el Mejor Salario Promedio: ¿Qué departamento tiene el
--     salario promedio actual más alto?
SELECT
  d.dept_name
FROM departments AS d
JOIN current_dept_emp AS cde
  ON d.dept_no = cde.dept_no
JOIN salaries AS s
  ON cde.emp_no = s.emp_no
WHERE
  s.to_date = '9999-01-01'
GROUP BY
  d.dept_name
ORDER BY
  AVG(s.salary) DESC
LIMIT 1;

-- 27. Gerente con Más Tiempo en el Cargo: Encuentra al gerente que ha estado en su
--     puesto por más tiempo. Muestra su nombre y el número de días en el cargo.
SELECT
  e.first_name,
  e.last_name,
  DATEDIFF(
    dm.to_date,
    dm.from_date
  ) AS dias_en_el_cargo
FROM employees AS e
JOIN dept_manager AS dm
  ON e.emp_no = dm.emp_no
ORDER BY
  dias_en_el_cargo DESC
LIMIT 1;

-- 28. Incremento Salarial por Empleado: Para el empleado 10001, calcula la diferencia
--     entre su primer salario y su salario actual.
SELECT
  (
    (
      SELECT
        salary
      FROM salaries
      WHERE
        emp_no = 10001
      ORDER BY
        from_date DESC
      LIMIT 1
    )
  ) - (
    (
      SELECT
        salary
      FROM salaries
      WHERE
        emp_no = 10001
      ORDER BY
        from_date ASC
      LIMIT 1
    )
  ) AS incremento_salarial;

-- 29. Empleados Contratados el Mismo Día: Encuentra todos los pares de empleados
--     que fueron contratados en la misma fecha.
SELECT
  e1.first_name AS empleado1_nombre,
  e1.last_name AS empleado1_apellido,
  e2.first_name AS empleado2_nombre,
  e2.last_name AS empleado2_apellido,
  e1.hire_date
FROM employees AS e1
JOIN employees AS e2
  ON e1.hire_date = e2.hire_date AND e1.emp_no < e2.emp_no
ORDER BY
  e1.hire_date;

-- 30. El Ingeniero Mejor Pagado: ¿Quién es el 'Senior Engineer' con el salario actual
--     más alto en toda la empresa? Muestra su nombre, apellido y salario.
SELECT
  e.first_name,
  e.last_name,
  s.salary
FROM employees AS e
JOIN titles AS t
  ON e.emp_no = t.emp_no
JOIN salaries AS s
  ON e.emp_no = s.emp_no
WHERE
  t.title = 'Senior Engineer' AND t.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
ORDER BY
  s.salary DESC
LIMIT 1;
