
create or replace package BODY lecture is
    procedure liste_employes(liste out cur_empl) is
        begin
        set transaction read only;
        open liste for select e.*,s.nomserv,(SELECT NVL(SUM(duree), 0) FROM travail t WHERE t.nuempl = e.nuempl) AS total_heures from service s,employe e,travail t  where e.affect = s.nuserv and t.nuempl = e.nuempl;
        -- LE NVL Permet de remplacer le null si un employe n'a pas de travail par 0 pour que la somme fonctionne. https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/NVL.html
        commit;
    end;
    procedure liste_proj_empl (le_nuempl in NUMBER, liste out curl_projet) is 
        begin 
        set TRANSACTION read only; 
        open liste for select p.* from projet p, travail t where t.nuempl = le_nuempl and t.nuproj = p.nuproj;
    end;
    procedure liste_proj_serv (le_nuserv in NUMBER, liste out curl_projet_serv) is
        begin 
        set TRANSACTION read only; 
        open liste for select p.* from projet p, travail t, employe e where t.nuempl = e.nuempl and t.nuproj = p.nuproj and e.affect = le_nuserv;
    end;
end;
