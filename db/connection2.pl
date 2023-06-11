:- use_module(library(odbc)).

connectionMyDB(Connection) :-
    odbc_connect('nokia-3310', Connection,[]).

inserir(Nome, Idade) :-
    connectionMyDB(Connection),
    atomic_list_concat(['INSERT INTO chips(owner, number) VALUES (', Nome, ', ', Idade, ')'], Query),
    odbc_query(Connection, Query, _),
    desconectar.