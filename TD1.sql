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

