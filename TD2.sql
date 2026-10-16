
--TD2--

-- Création Premier TRIGGER 
    
-- Test du Trigger --

Update employe set salaire = 0 where nuempl = 7 ;

-- Création TRIGGER hebdo

-- Test du Trigger --
Update employe set hebdo = 35 where nuempl = 7 ; 


--EXO2
-- Création triggers suppression Employe 

-- Test du Trigger --

ALTER TABLE TRAVAIL DROP CONSTRAINT FK_travaille_employe;
ALTER TABLE TRAVAIL ADD CONSTRAINT FK_travaille_employe FOREIGN KEY (nuempl) REFERENCES EMPLOYE(nuempl) INITIALLY DEFERRED ; 


select * FROM TRAVAil where nuempl = 19;
DElete employe where nuempl = 19; 
select * FROM TRAVAil where nuempl = 19;
rollback;



-- Création triggers suppression projet 

-- Test du Trigger --

ALTER TABLE TRAVAIL DROP CONSTRAINT FK_travaille_projet;
ALTER TABLE TRAVAIL ADD CONSTRAINT FK_travaille_projet FOREIGN KEY (nuproj) REFERENCES PROJET(nuproj)INITIALLY DEFERRED ;
ALTER TABLE CONCERNE DROP CONSTRAINT FK_concerne_projet;
ALTER TABLE CONCERNE ADD CONSTRAINT FK_concerne_projet FOREIGN KEY (nuproj) REFERENCES PROJET(nuproj)INITIALLY DEFERRED; 


select * FROM TRAVAil where nuproj = 370;
DElete projet where nuproj = 370; 
select * FROM TRAVAil where nuproj = 370;
rollback;

-- EXO3
--Création triggers sum hebdo  
-- modificaation sur la table employe ou travail et insert sur travail 

-- Test du Trigger --

select * From travail;


-- Test sur travail
INSERT INTO travail values (23,20,20);
--Ereur 1

INSERT ALL INTO travail values (23,20,20) 
            INTO travail values (20,237,50) 
            SELECT * FROM DUAL ;
--Ereurs multiple

update travail set duree = 20 where nuempl = 23 and nuproj = 237;
--Ereur 

INSERT INTO travail values (23,20,2);
delete from travail where nuproj = 20 and nuempl = 23;
--Fonctionne 

--Test sur employe

update employe set hebdo = 1 where nuempl = 23 ; 
-- Ereur 1

update employe set hebdo = 1 ; 
--Ereurs multiple 

-- Création du trigger un employé est responable au plus sur 3 projets

-- Test du Trigger 
select * from projet; 
insert into projet values(676,'Test',30);
--Ereur 1
insert ALL into projet values(676,'Test',30)
        into projet values(858,'Test',57)
        into projet values(999,'Test',57)
        SELECT * FROM DUAL
;
--Ereurs multiple 

insert into projet values(676,'Test',20);
rollback;
--Fonctionne


update projet set resp = 30 where nuproj = 370;
--Ereur


 -- Création  du trigger un service ne peut être concerné par plus de 3 projets
 
 --Test du trigger 
select * from concerne;
insert into concerne values (5,101);
--Ereur 1
INSERT ALL into concerne values (5,101)
            into concerne values (67,237)
            into concerne values (67,20)
        SELECT * FROM DUAL
;
--Ereur multiple

insert into concerne values (67,101);
delete from concerne where nuproj = 101;
--Fonctionne

update concerne set nuserv = 5 where nuserv = 67 ;
--Ereur
--


--Création du trigger TRIGGER_SALAIRE_SERV
--Test du triggers sur service 
update service SET chef = 7 where nuserv = 67; 
--Erreur

--Création du trigger TRIGGER_SALAIRE_CHEF
--Test du triggers sur employe 
update employe SET salaire = 5000 where nuempl = 7;
--Ereure

INSERT ALL into employe values (200,'paul',20,67,7000) 
 into employe values (210,'jean',31,67,6000)
 select * FROM DUAL ; 
--Erreus Multiple


--Création du trigger TRIGGER_SALAIRE_PROJ
--Test sur la Table projet 
update projet set resp = 28 where nuproj=237; 
--ERREUR

--Création du trigger TRIGGER_SALAIRE_RESP
--Test sur la table employe
update employe set salaire = 4000 where nuempl = 10;
--ERREUR

--Création du trigger TRIGGER_SALAIRE_TRAVAIL

--Test sur la table travail
insert into travail values (99,12,1);
--ERREUR 

insert All into travail values(99,12,1)
 into travail values(41,12,3) 
 select * FROM DUAL ; 
--ERREURS MULTIPLES


--Exercice 4 --
Create table EMPLOYE_ALERT AS select * from employe where 1=2 ; --Permet de récuper uniquement les attribut



DELETE projet where projet.nuproj = 370 or nuproj = 135 or nuproj = 103 or nuproj = 492 or nuproj = 160 or nuproj = 237; -- Clear de la base pour faire le test du triggers car probleme 

commit;
insert into service values(50,'TEST',89);


    
insert into employe values (89,'marc',20,50,7000);
insert into employe values (95,'paul',20,50,2000);
commit;
select * FROM employe_alert;
-- On retrouve bien marc 
update employe set salaire = 5001 where nuempl = 95;
select * FROM employe_alert;
-- OIn retrouve bien les deux 
