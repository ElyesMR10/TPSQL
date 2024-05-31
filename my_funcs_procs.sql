-- Fonction GET_NB_WORKERS
CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY NUMBER) RETURN NUMBER IS
    nb_workers NUMBER;
BEGIN
    SELECT COUNT(*) INTO nb_workers
    FROM ALL_WORKERS
    WHERE factory_id = FACTORY;
    RETURN nb_workers;
END;
/

-- Fonction GET_NB_BIG_ROBOTS
CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
    nb_big_robots NUMBER;
BEGIN
    SELECT COUNT(*) INTO nb_big_robots
    FROM robots
    WHERE number_of_parts > 3;
    RETURN nb_big_robots;
END;
/

-- Fonction GET_BEST_SUPPLIER
CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
    best_supplier VARCHAR2(100);
BEGIN
    SELECT supplier_name INTO best_supplier
    FROM BEST_SUPPLIERS
    WHERE ROWNUM = 1
    ORDER BY number_of_parts DESC;
    RETURN best_supplier;
END;
/

-- Fonction GET_OLDEST_WORKER
CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
    oldest_worker_id NUMBER;
BEGIN
    SELECT worker_id INTO oldest_worker_id
    FROM ALL_WORKERS
    WHERE ROWNUM = 1
    ORDER BY start_date ASC;
    RETURN oldest_worker_id;
END;
/



-- Procédure SEED_DATA_WORKERS
CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) IS
BEGIN
    FOR i IN 1..NB_WORKERS LOOP
        INSERT INTO workers (worker_id, firstname, lastname, start_date, factory_id)
        VALUES (
            workers_seq.NEXTVAL, 
            'worker_f_' || workers_seq.CURRVAL, 
            'worker_l_' || workers_seq.CURRVAL, 
            (SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))),'J') FROM DUAL),
            FACTORY_ID
        );
    END LOOP;
END;
/

-- Procédure ADD_NEW_ROBOT
CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2) IS
BEGIN
    INSERT INTO robots (robot_id, model_name, factory_id)
    VALUES (robots_seq.NEXTVAL, MODEL_NAME, (SELECT factory_id FROM ROBOTS_FACTORIES WHERE ROWNUM = 1));
END;
/

-- Procédure SEED_DATA_SPARE_PARTS
CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) IS
BEGIN
    FOR i IN 1..NB_SPARE_PARTS LOOP
        INSERT INTO spare_parts (part_id, part_name)
        VALUES (spare_parts_seq.NEXTVAL, 'part_' || spare_parts_seq.CURRVAL);
    END LOOP;
END;
/
