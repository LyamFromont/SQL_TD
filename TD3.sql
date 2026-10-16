

--Exercice 3 :
-- A B C

SELECT * FROM employe;
SELECT * FROM projet;
SELECT * FROM travail;
SELECT * FROM service;

---------------------------------------------------------
-- 0. TESTS POUR Creer_employe
---------------------------------------------------------

-- Erreur ORA-20101 :
CALL MAJ.creer_employe(7, '..',30,1,2000);
-- Erreur ORA-20102 : 
CALL MAJ.creer_employe(69, '..',30,90,2000);
-- Erreur ORA-20103 :
CALL MAJ.creer_employe(69, '..',40,1,2000);
-- Erreur ORA-20104 :
CALL MAJ.creer_employe(69, '..',4000,1,2000);
-- Erreur ORA-20104 :
CALL MAJ.creer_employe(69, '.............................................................................................................',4,1,2000);
-- Fonctionne :
CALL MAJ.creer_employe(69,'Jean',30,1,2000);



---------------------------------------------------------
-- 1. TESTS POUR UPDATE_HEBDO
---------------------------------------------------------
-- Erreur ORA-20200 :
CALL MAJ.UPDATE_HEBDO(999, 30); 

-- Erreur ORA-20201 :
CALL MAJ.UPDATE_HEBDO(10, 1); 

-- Erreur ORA-20202 :
CALL MAJ.UPDATE_HEBDO(20, 40); 

-- Erreur ORA-20104 : 
CALL MAJ.UPDATE_HEBDO(20, 999999); 

-- Fonctionne :
CALL MAJ.UPDATE_HEBDO(20, 30); 


---------------------------------------------------------
-- 2. TESTS POUR UPDATE_SALAIRE
---------------------------------------------------------
-- Erreur ORA-20300 :
CALL MAJ.UPDATE_SALAIRE(999, 3000); 

-- Erreur ORA-20301 :
CALL MAJ.UPDATE_SALAIRE(20, 2000); 

-- Erreur ORA-20302 :
CALL MAJ.UPDATE_SALAIRE(20, 4000); 

-- Erreur ORA-20104 : 
CALL MAJ.UPDATE_SALAIRE(20, 99999999); 

-- Fonctionne :
CALL MAJ.UPDATE_SALAIRE(20, 2800); 


---------------------------------------------------------
-- 3. TESTS POUR AJOUTER_PROJET
---------------------------------------------------------
-- Erreur ORA-20401 : 
CALL MAJ.AJOUTER_PROJET(12, 'Test', 7, 5); 

-- Erreur ORA-20402 : 
CALL MAJ.AJOUTER_PROJET(13, 'Test', 999, 5); 

-- Erreur ORA-20403 :
CALL MAJ.AJOUTER_PROJET(14, 'Nouveau Projet', 42, 25); 

-- Erreur ORA-20404 :
CALL MAJ.AJOUTER_PROJET(99999999, 'Test', 42, 5); 

-- Erreur ORA-20405 :
CALL MAJ.AJOUTER_PROJET(15, 'Un nom de projet qui est vraiment beaucoup trop long pour rentrer dans la table', 42, 5); 

-- Fonctionne :
CALL MAJ.AJOUTER_PROJET(16, 'Projet X', 41, 5); 


---------------------------------------------------------
-- 4. TESTS POUR UPDATE_DUREE_TRAVAIL
---------------------------------------------------------
-- Erreur ORA-20300 :
CALL MAJ.UPDATE_DUREE_TRAVAIL(10, 99, 5); 

-- Erreur ORA-20501 :
CALL MAJ.UPDATE_DUREE_TRAVAIL(10, 12, 25); 

-- Erreur ORA-20504 :
CALL MAJ.UPDATE_DUREE_TRAVAIL(10, 12, 999999); 

-- Fonctionne :
CALL MAJ.UPDATE_DUREE_TRAVAIL(10, 12, 5); 


---------------------------------------------------------
-- 5. TESTS POUR INSERER_TRAVAIL
---------------------------------------------------------
-- Erreur ORA-20601 :
CALL MAJ.INSERER_TRAVAIL(10, 12, 5); 

-- Erreur ORA-20602 :
CALL MAJ.INSERER_TRAVAIL(999, 12, 5); 

-- Erreur ORA-20603 :
CALL MAJ.INSERER_TRAVAIL(42, 12, 25); 

-- Erreur ORA-20604 :
CALL MAJ.INSERER_TRAVAIL(42, 12, 999999); 

-- Fonctionne :
CALL MAJ.INSERER_TRAVAIL(42, 12, 5); 


---------------------------------------------------------
-- 6. TESTS POUR INSERER_SERVICE
---------------------------------------------------------
-- Erreur ORA-20701 :
CALL MAJ.INSERER_SERVICE(1, 'Logistique', 48); 

-- Erreur ORA-20702 :
CALL MAJ.INSERER_SERVICE(6, 'Logistique', 999); 

-- Erreur ORA-20704 :
CALL MAJ.INSERER_SERVICE(99999999, 'Logistique', 48); 

-- Erreur ORA-20705 :
CALL MAJ.INSERER_SERVICE(6, 'Un nom de service beaucoup beaucoup trop long', 48); 

-- Fonctionne :
CALL MAJ.INSERER_SERVICE(6, 'Logistique', 48); 

-- On vérifie que tout a bien fonctionné et on valide nos changements positifs
SELECT * FROM employe;
SELECT * FROM projet;
SELECT * FROM travail;
SELECT * FROM service;
ROLLBACK; 



--D
--------------------
--Tests Pour le package lecture
--------------------

-- Test qui retourne les bonne valeurs

call lecture.liste_employe;
call lecture.liste_proj_empl(7);
call lecture.liste_proj_serv(67);


-- Test erreure
call lecture.liste_proj_empl(999);
call lecture.liste_proj_serv(999);
