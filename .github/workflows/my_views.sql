-- 1. Créer la vue ALL_WORKERS
CREATE VIEW ALL_WORKERS AS
SELECT first_name AS firstname, last_name AS lastname, age, first_day AS start_date
FROM WORKERS_FACTORY_1
WHERE last_day IS NULL
UNION
SELECT first_name, last_name, age, start_date
FROM WORKERS_FACTORY_2
WHERE end_date IS NULL
ORDER BY start_date DESC;

-- 2. Créer la vue ALL_WORKERS_ELAPSED
CREATE VIEW ALL_WORKERS_ELAPSED AS
SELECT firstname, lastname, age, start_date, 
       ROUND((SYSDATE - start_date), 0) AS days_elapsed
FROM ALL_WORKERS;

-- 3. Créer la vue BEST_SUPPLIERS
CREATE VIEW BEST_SUPPLIERS AS
SELECT s.name AS supplier_name, SUM(sbf1.quantity + sbf2.quantity) AS total_pieces_delivered
FROM SUPPLIERS s
LEFT JOIN SUPPLIERS_BRING_TO_FACTORY_1 sbf1 ON s.supplier_id = sbf1.supplier_id
LEFT JOIN SUPPLIERS_BRING_TO_FACTORY_2 sbf2 ON s.supplier_id = sbf2.supplier_id
GROUP BY s.name
HAVING SUM(sbf1.quantity + sbf2.quantity) > 1000
ORDER BY total_pieces_delivered DESC;

-- 4. Créer la vue ROBOTS_FACTORIES
CREATE VIEW ROBOTS_FACTORIES AS
SELECT r.model AS robot_id, f.main_location AS factory_name
FROM ROBOTS r
JOIN ROBOTS_FROM_FACTORY rff ON r.id = rff.robot_id
JOIN FACTORIES f ON rff.factory_id = f.id;
