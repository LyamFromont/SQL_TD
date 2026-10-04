-- TD1 -- 

--Création des table--
CREATE TABLE EMPLOYE AS SELECT * FROM basetd.employe;
CREATE TABLE SERVICE AS SELECT * FROM basetd.service;
CREATE TABLE PROJET AS SELECT * FROM basetd.projet;
CREATE TABLE TRAVAIL AS SELECT * FROM basetd.travail;
CREATE TABLE CONCERNE AS SELECT * FROM basetd.concerne;

-- Création clé primaire --
ALTER TABLE EMPLOYE ADD CONSTRAINT PK_employe PRIMARY KEY (nuempl); 
ALTER TABLE SERVICE ADD CONSTRAINT PK_service PRIMARY KEY (nuserv); 
ALTER TABLE PROJET ADD CONSTRAINT PK_projet PRIMARY KEY (nuproj); 
ALTER TABLE TRAVAIL ADD CONSTRAINT PK_travail PRIMARY KEY (nuempl,nuproj);
ALTER TABLE CONCERNE ADD CONSTRAINT PK_concerne PRIMARY KEY (nuserv,nuproj); 


-- Création clé étrangère -- 
ALTER TABLE EMPLOYE ADD CONSTRAINT FK_employe FOREIGN KEY (affect) REFERENCES SERVICE(nuserv); 
ALTER TABLE TRAVAIL ADD CONSTRAINT FK_travaille_employe FOREIGN KEY (nuempl) REFERENCES EMPLOYE(nuempl); 
ALTER TABLE TRAVAIL ADD CONSTRAINT FK_travaille_projet FOREIGN KEY (nuproj) REFERENCES PROJET(nuproj); 
ALTER TABLE CONCERNE ADD CONSTRAINT FK_concerne_service FOREIGN KEY (nuserv) REFERENCES SERVICE(nuserv); 
ALTER TABLE CONCERNE ADD CONSTRAINT FK_concerne_projet FOREIGN KEY (nuproj) REFERENCES PROJET(nuproj); 
ALTER TABLE PROJET ADD CONSTRAINT FK_reponsable FOREIGN KEY (resp) REFERENCES EMPLOYE (nuempl);




-- Test insertion et suppression -- 

-- Correct -- 

INSERT INTO SERVICE VALUES (67,'les_profs_cool',15); 
INSERT INTO EMPLOYE VALUES (10,'RAOUL',20,67);
INSERT INTO EMPLOYE VALUES (15,'BERDJUGIN',35,67);
INSERT INTO EMPLOYE VALUES (7,'SIMONNEAU',23,67);
INSERT INTO PROJET VALUES (12,'Tourbillon',7); 
INSERT INTO TRAVAIL VALUES (10,12,2); 
INSERT INTO CONCERNE VALUES (67,12);

DELETE FROM TRAVAIL
WHERE nuempl = 20 ; 
DELETE FROM EMPLOYE
WHERE nuempl = 20 ;


-- Incorrect -- 

INSERT INTO EMPLOYE VALUES (10,'LANOIX',20,67); // clé primaire incorect 
INSERT INTO TRAVAIL VALUES (10,12,2); // clé primaire incorect 
INSERT INTO SERVICE VALUES (67,'les_profs_pas_cool',15); // clé primaire incorect 
INSERT INTO PROJET VALUES (12,'LALA',2); // clé primaire incorect 
INSERT INTO CONCERNE VALUES (67,12); // clé primaire incorect 


// Cleaning
INSERT INTO EMPLOYE VALUES (61,'HERNANDEZ',20,68); 
DELETE FROM SERVICE WHERE nuserv =67 ;
INSERT INTO TRAVAIL VALUES (21,12,3); 
DELETE FROM EMPLOYE WHERE nuempl =10 ;
INSERT INTO TRAVAIL VALUES (10,21,3); 
DELETE FROM PROJET WHERE nuproj =12 ;
INSERT INTO TRAVAIL VALUES (10,21,3); 
DELETE FROM PROJET WHERE nuproj =12 ;
INSERT INTO CONCERNE VALUES (11,12); 
DELETE FROM SERVICE WHERE nuproj =67 ;
INSERT INTO CONCERNE VALUES (11,12); 
DELETE FROM PROJET WHERE nuproj =12 ;


ALTER TABLE SERVICE DROP CONSTRAINT FK_CHEF;
ALTER TABLE EMPLOYE 
ADD CONSTRAINT UNQ_EMPL_AFFECT 





-- AJout de la contraint DIféré --
UNIQUE (nuempl, affect);
ALTER TABLE SERVICE ADD CONSTRAINT FK_CHEF FOREIGN KEY (chef,nuserv) REFERENCES EMPLOYE (nuempl,affect) INITIALLY DEFERRED;


--TEST--
commit;
DELETE FROM employe WHERE nuempl = 99 ; 
DELETE FROM SERVICE WHERE nuserv = 33 ; 

INSERT INTO service VALUES (33,'les_éleves',99);
INSERT INTO employe VALUES (99,'ribaltchanko',20,33);

commit;

INSERT INTO service VALUES (20,'Le_bde',99);

commit;

DELETE FROM employe WHERE nuempl = 99 ; 
 
commit;


-- AUTREE CONSTRAINT -- 

ALTER TABLE EMPLOYE ADD CONSTRAINT K_horraire CHECK (hebdo <=35) ;

-- erreur -- 
INSERT INTO EMPLOYE VALUES (32,'LYYAM',36,33);


-- PARTIE 2 -- 
alter table employe add salaire number ;

--UPDATE EMPLOYE SET salaire = 2500 where nuempl in (SELECT nuempl FROM employe,projet WHERE projet.resp = employe.nuempl and employe.salaire < 2500) ;
---UPDATE EMPLOYE SET salaire = 3500 where nuempl in (SELECT chef FROM service WHERE service.chef = employe.nuempl and employe.salaire < 3500);
--UPDATE EMPLOYE SET salaire = 2000 where nuempl in (SELECT nuempl FROM employe where nuempl not in (Select chef from service) and nuempl not in (select resp from projet) and salaire >2000);

SELECT nuempl FROM employe,projet WHERE projet.resp = employe.nuempl and employe.salaire < 2500;
SELECT nuempl FROM employe,service WHERE service.chef = employe.nuempl and employe.salaire < 3500; 
SELECT nuempl FROM employe where nuempl not in (Select chef from service) and nuempl not in (select resp from projet) and salaire >2000;


-- Test  en rajoutant des salaire 

UPDATE employe 
SET salaire = FLOOR(DBMS_RANDOM.VALUE(1000, 5000));

-- on test les select et puis les update les deux fonctionne (par rapport a l'énoncé du td) 

 
-- employe qui travaille trop --

Select * from employe e where hebdo < ( SELECT SUM(duree) FROM TRAVAIL where e.nuempl = travail.nuempl);


-- Responsable de moin de 3 projet -- 

SELECT resp
FROM projet
GROUP BY resp
HAVING COUNT(*) > 3;

--test-- 
 
insert into projet values(56,'destruction',30) ;
--fonctionne bien on trouve 30
DELETE FROM projet where nuproj = 56;

-- Un chef de service gagne plus que les emploe -- 

SELECT  e.nuempl from employe e 
join service s on e.affect = s .nuserv
JOIN employe chef ON s.chef = chef.nuempl
where e.salaire > chef.salaire;

--test-- 
update employe set salaire =1000000 where nuempl = 7; 
-- ça fonctionne 
update employe set salaire =3499  where nuempl in (SELECT  e.nuempl from employe e 
join service s on e.affect = s .nuserv
JOIN employe chef ON s.chef = chef.nuempl
where e.salaire > chef.salaire);



-- service a que deux projets -- 

SELECT nuserv
FROM concerne 
GROUP BY nuserv
HAVING COUNT(*) > 2;

delete from concerne where nuserv in (SELECT nuserv
FROM concerne 
GROUP BY nuserv
HAVING COUNT(*) > 2);


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