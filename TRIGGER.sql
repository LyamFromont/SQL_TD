create or replace TRIGGER trg_verif_salaire

AFTER UPDATE OF salaire ON EMPLOYE

FOR EACH ROW

BEGIN

if :new.salaire < :old.salaire then

raise_application_error

(-20001,'viol de la règle :un salaire ne peut etre diminué') ;

end if ;

END;

create or replace TRIGGER trg_verif_hebdo

AFTER UPDATE OF hebdo ON EMPLOYE

FOR EACH ROW

BEGIN

if :new.hebdo > :old.hebdo then

raise_application_error

(-20001,'viol de la règle :Le temps hebdo ne peux pas être augmenter') ;

end if ;

END;

create or replace TRIGGER TRG_SUPPRESSION_EMP_TRA

AFTER DELETE ON EMPLOYE

BEGIN

DELETE TRAVAIL WHERE nuempl NOT IN (SELECT nuempl from employe);

END;

create or replace TRIGGER TRG_SUPPRIMER_PROJET

AFTER DELETE ON projet

BEGIN

DELETE TRAVAIL WHERE nuproj NOT IN (SELECT nuproj from projet);

DELETE concerne WHERE nuproj NOT IN (SELECT nuproj from projet);

END;

create or replace TRIGGER TRIGGER_SUM_HEBDO

AFTER INSERT OR UPDATE OF DUREE ON TRAVAIL

DECLARE

REC_employe employe%ROWTYPE;

BEGIN

Select * INTO REC_employe from employe e

where (select sum(duree) from travail t where e.nuempl=t.nuempl)> hebdo ;

raise_application_error

(-20001,'viol de la règle 1 erreur :trop d heure par rapport a la limite hebdo') ;

EXCEPTION

WHEN NO_DATA_FOUND THEN NULL;

WHEN TOO_MANY_ROWS THEN raise_application_error

(-20001,'viol de la règle plusieurs erreurs:trop d heure par rapport a la limite hebdo') ;

END;

create or replace TRIGGER TRIGGER_SUM_HEBDO2

AFTER UPDATE OF HEBDO ON EMPLOYE

DECLARE

REC_employe employe%ROWTYPE;

BEGIN

Select * INTO REC_employe from employe e

where (select sum(duree) from travail t where e.nuempl=t.nuempl)> hebdo ;

raise_application_error

(-20001,'viol de la règle 1 erreur :trop d heure par rapport a la limite hebdo') ;

EXCEPTION

WHEN NO_DATA_FOUND THEN NULL;

WHEN TOO_MANY_ROWS THEN raise_application_error

(-20001,'viol de la règle plusieurs erreurs :trop d heure par rapport a la limite hebdo') ;

END;

create or replace TRIGGER "TRIGGER_RESP_MAX" AFTER INSERT OR UPDATE OF RESP ON PROJET

DECLARE

REC_employe employe%ROWTYPE;

BEGIN

Select * INTO REC_employe from employe e

where (select count(*) from projet p where e.nuempl=p.resp)> 3 ;

raise_application_error

(-20001,'viol de la règle 1 erreur :trop de projet pour un employe') ;

EXCEPTION

WHEN NO_DATA_FOUND THEN NULL;

WHEN TOO_MANY_ROWS THEN raise_application_error

(-20001,'viol de la règle plusieurs erreurs :trop de projet pour un employe') ;

END;

create or replace TRIGGER TRIGGER_2PROJET

AFTER INSERT OR UPDATE OF NUSERV ON CONCERNE

DECLARE

REC_service service%ROWTYPE;

BEGIN

SELECT * INTO REC_service

FROM service s

WHERE (SELECT COUNT(*) FROM concerne c WHERE c.nuserv = s.nuserv) > 2;

raise_application_error

(-20001,'viol de la règle 1 erreur:trop de projet pour un service') ;

EXCEPTION

WHEN NO_DATA_FOUND THEN NULL;

WHEN TOO_MANY_ROWS THEN raise_application_error

(-20001,'viol de la règle plusieurs erreurs:trop de projet pour un service') ;

END;

create or replace TRIGGER TRIGGER1

AFTER INSERT OR UPDATE OF CHEF ON SERVICE

DECLARE

REC_service servic%ROWTYPE;

BEGIN;

SELECT * INTO REC_service

FROM service s

WHERE

(SELECT e.nuempl from employe e

join service s on e.affect = s .nuserv

JOIN employe chef ON s.chef = chef.nuempl

where e.salaire > chef.salaire);

raise_application_error

(-20001,'viol de la règle 1 erreur :trop de projet pour un employe') ;

EXCEPTION

WHEN NO_DATA_FOUND THEN NULL;

WHEN TOO_MANY_ROWS THEN raise_application_error

(-20001,'viol de la règle plusieurs erreurs :trop de projet pour un employe') ;

END;