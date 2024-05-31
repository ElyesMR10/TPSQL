-- Trigger pour intercepter l’insertion dans ALL_WORKERS_ELAPSED
CREATE OR REPLACE TRIGGER trg_all_workers_elapsed_insert
INSTEAD OF INSERT ON ALL_WORKERS_ELAPSED
FOR EACH ROW
BEGIN
    INSERT INTO workers (worker_id, firstname, lastname, start_date, factory_id)
    VALUES (:NEW.worker_id, :NEW.firstname, :NEW.lastname, :NEW.start_date, :NEW.factory_id);
END;
/

-- Trigger pour enregistrer la date d’ajout de chaque nouveau robot dans AUDIT_ROBOT
CREATE OR REPLACE TRIGGER trg_new_robot_audit
AFTER INSERT ON robots
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_ROBOT (robot_id, audit_date)
    VALUES (:NEW.robot_id, SYSDATE);
END;
/

-- Trigger pour empêcher les modifications dans ROBOTS_FACTORIES si le nombre d’usines est incorrect
CREATE OR REPLACE TRIGGER trg_check_factories
BEFORE INSERT OR UPDATE OR DELETE ON ROBOTS_FACTORIES
FOR EACH ROW
DECLARE
    num_factories NUMBER;
    num_worker_tables NUMBER;
BEGIN
    SELECT COUNT(*) INTO num_factories FROM FACTORIES;
    SELECT COUNT(*) INTO num_worker_tables FROM all_tables WHERE table_name LIKE 'WORKERS_FACTORY_%';
    
    IF num_factories != num_worker_tables THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le nombre d’usines ne correspond pas au nombre de tables WORKERS_FACTORY.');
    END IF;
END;
/

-- Trigger pour calculer la durée passée dans l’usine lors de l’ajout d’une date de départ
CREATE OR REPLACE TRIGGER trg_calculate_duration
BEFORE UPDATE OF end_date ON workers
FOR EACH ROW
BEGIN
    IF :NEW.end_date IS NOT NULL THEN
        :NEW.duration := :NEW.end_date - :OLD.start_date;
    END IF;
END;
/
