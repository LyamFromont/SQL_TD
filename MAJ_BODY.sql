create or replace package  BODY MAJ is 
PROCEDURE CREER_EMPLOYE (LE_NUEMPL IN NUMBER, LE_NOMEMPL IN VARCHAR2, LE_HEBDO IN NUMBER, LE_AFFECT IN NUMBER,LE_SALAIRE IN NUMBER) is
BEGIN
SET TRANSACTION READ WRITE;
INSERT INTO employe VALUES(LE_NUEMPL, LE_NOMEMPL, LE_HEBDO, LE_AFFECT,LE_SALAIRE);
COMMIT;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE=-00001 THEN ROLLBACK;
          RAISE_APPLICATION_ERROR (-20101, 'Un employe avec le meme numero existe deja');
    ELSIF SQLCODE=-02291 then rollback;
            RAISE_APPLICATION_ERROR (-20102,'Le service auquel il est affecte n existe pas');
    ELSIF SQLCODE = -02290 THEN 
          RAISE_APPLICATION_ERROR (-20103, 'la durée hebdomadaire d un employé doit être inférieure ou égale à 35h');
    ELSIF SQLCODE = -1438 THEN 
          RAISE_APPLICATION_ERROR (-20104, 'Une valeur (nombre) dépasse le nombre de caractères autorisés');
    ELSIF SQLCODE = -12899 THEN 
          RAISE_APPLICATION_ERROR (-20105, 'Une valeur (chaine de caractère) dépasse le nombre de caractères autorisés');
    ELSIF SQLCODE = -20008 THEN
          RAISE_APPLICATION_ERROR (-20106, 'Un employe gagne plus que son chef de service');

    
    ELSE 
        RAISE_APPLICATION_ERROR (-20999,'Erreur Inatendu'||SQLcode);
END IF; 
END;
PROCEDURE UPDATE_HEBDO (LE_NUEMPL IN NUMBER, LE_HEBDO IN NUMBER) is
BEGIN
SET TRANSACTION READ WRITE;
UPDATE employe set hebdo = le_hebdo where nuempl = LE_NUEMPL ;
IF SQL%NOTFOUND THEN 
        RAISE_APPLICATION_ERROR(-20200, 'L employe n existe pas');
    END IF;
COMMIT;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE=-20004 THEN ROLLBACK;
          RAISE_APPLICATION_ERROR (-20201, '"La durée hebdomadaire ne doit pas être Superieur au nombre d’heure de travail"');
    ELSIF SQLCODE=-02290 then rollback;
            RAISE_APPLICATION_ERROR (-20202,'"la durée hebdomadaire d’un employé doit être inférieure ou égale à 35h"');
    ELSIF SQLCODE = -1438 THEN 
          RAISE_APPLICATION_ERROR (-20104, 'Une valeur (nombre) dépasse le nombre de caractères autorisés');

    
    ELSE 
        RAISE_APPLICATION_ERROR (-20999,'Erreur Inatendu'||SQLcode);
END IF; 
END;    
PROCEDURE UPDATE_SALAIRE  (LE_NUEMPL IN NUMBER, LE_SALAIRE IN NUMBER) is
BEGIN
SET TRANSACTION READ WRITE;
UPDATE employe set salaire = le_salaire where nuempl = le_nuempl;
IF SQL%NOTFOUND THEN 
        RAISE_APPLICATION_ERROR(-20300, 'L employe n existe pas');
    END IF;
COMMIT;
EXCEPTION WHEN OTHERS THEN ROLLBACK;
    IF SQLCODE=-20001 THEN ROLLBACK;
          RAISE_APPLICATION_ERROR (-20301, 'Un salaire ne peut pas être diminuer');
    ELSIF SQLCODE=-20008 then rollback;
            RAISE_APPLICATION_ERROR (-20302,'Un employe ne peut pas gagner plus que son chef');
    ELSIF SQLCODE = -20010 THEN 
          RAISE_APPLICATION_ERROR (-20303, 'Un employe ne peut pas gagner plus que son Responsable');
    ELSIF SQLCODE = -1438 THEN 
          RAISE_APPLICATION_ERROR (-20104, 'Une valeur (nombre) dépasse le nombre de caractères autorisés');
    

    
    ELSE 
        RAISE_APPLICATION_ERROR (-20999,'Erreur Inatendu'||SQLcode);
END IF; 
END;
PROCEDURE AJOUTER_PROJET (LE_NUPROJ IN NUMBER, LE_NOMPROJ IN VARCHAR2, LE_RESP IN NUMBER, LA_DUREE IN NUMBER) IS
BEGIN
    SET TRANSACTION READ WRITE;
    
    INSERT INTO projet (nuproj, nomproj, resp) VALUES (LE_NUPROJ, LE_NOMPROJ, LE_RESP);
    
    INSERT INTO travail (nuempl, nuproj, duree) VALUES (LE_RESP, LE_NUPROJ, LA_DUREE);
    
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN 
        IF SQLCODE = -00001 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20401, 'Un projet avec le meme numero existe deja');
            
        ELSIF SQLCODE = -02291 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20402, 'n existe pas');
            
        ELSIF SQLCODE = -20004 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20403, 'Superieur au nombre d heure de travail');
            
        ELSIF SQLCODE = -1438 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20404, 'de caracteres autorises');
            
        ELSIF SQLCODE = -12899 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20405, 'Une valeur (chaine de caractere) depasse le nombre de caracteres autorises');
            
        ELSE 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20999, 'Erreur inattendue : ' || SQLCODE);
        END IF; 
END;


PROCEDURE UPDATE_DUREE_TRAVAIL (LE_NUEMPL IN NUMBER, LE_NUPROJ IN NUMBER, LA_NOUVELLE_DUREE IN NUMBER) IS
BEGIN
    SET TRANSACTION READ WRITE;
    
    UPDATE travail 
    SET duree = LA_NOUVELLE_DUREE 
    WHERE nuempl = LE_NUEMPL AND nuproj = LE_NUPROJ;
    
    IF SQL%NOTFOUND THEN 
        RAISE_APPLICATION_ERROR(-20300, 'pas sur ce projet ou le projet n existe pas');
    END IF;
    
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN  
        IF SQLCODE = -20004 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20501, 'Superieur au nombre d heure de travail');
            
        ELSIF SQLCODE = -1438 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20504, 'nombre de caracteres autorises');
             
        ELSE 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20999, 'Erreur inattendue : ' || SQLCODE);
        END IF;
END;





PROCEDURE INSERER_TRAVAIL (LE_NUEMPL IN NUMBER, LE_NUPROJ IN NUMBER, LA_DUREE IN NUMBER) IS
BEGIN
    SET TRANSACTION READ WRITE;
    
    INSERT INTO travail (nuempl, nuproj, duree) VALUES (LE_NUEMPL, LE_NUPROJ, LA_DUREE);
    
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN 
        IF SQLCODE = -00001 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20601, 'pas sur ce projet ou le projet n existe pas');
            
        ELSIF SQLCODE = -02291 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20602, 'n existe Pas, ou le projet auquel il est affecte n existe pas');
            
        ELSIF SQLCODE = -20004 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20603, 'Superieur au nombre d heure de travail');
            
        ELSIF SQLCODE = -1438 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20604, 'nombre de caracteres autorises');
            
        ELSE 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20999, 'Erreur inattendue : ' || SQLCODE);
        END IF;
END;


PROCEDURE INSERER_SERVICE (LE_NUSERV IN NUMBER, LE_NOMSERV IN VARCHAR2, LE_NUEMPL_CHEF IN NUMBER) IS
BEGIN
    SET TRANSACTION READ WRITE;
    
    INSERT INTO service (nuserv, nomserv, chef) VALUES (LE_NUSERV, LE_NOMSERV, LE_NUEMPL_CHEF);
    
    UPDATE employe SET affect = LE_NUSERV WHERE nuempl = LE_NUEMPL_CHEF;
    
    IF SQL%NOTFOUND THEN 
        RAISE_APPLICATION_ERROR(-20702, 'n existe Pas ou l employe est deja chef');
    END IF;
    
    COMMIT;
EXCEPTION 
    WHEN OTHERS THEN 
        IF SQLCODE = -00001 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20701, 'Service deja existant');
             
        ELSIF SQLCODE = -02291 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20702, 'n existe Pas ou l employe est deja chef');
            
        ELSIF SQLCODE = -1438 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20704, 'de caracteres autorises');
            
        ELSIF SQLCODE = -12899 THEN 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20705, 'Une valeur (chaine de caractere) depasse le nombre de caracteres autorises');
            
        ELSE 
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20999, 'Erreur inattendue : ' || SQLCODE);
        END IF;
END;
END;
