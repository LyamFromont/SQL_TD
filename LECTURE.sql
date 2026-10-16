create or replace package lecture is 
type cur_empl is REF CURSOR ;

procedure liste_employes( liste out cur_empl) ; 
type curl_projet is REF CURSOR;
procedure liste_proj_empl (le_nuempl in NUMBER, liste out curl_projet);
type curl_projet_serv is REF CURSOR;
procedure liste_proj_serv (le_nuserv in NUMBER, liste out curl_projet_serv);
end ; 
