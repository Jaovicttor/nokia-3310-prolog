:- module(db_connection, [connectionMyDB/1, disconnect/1]).
:- use_module(library(odbc)).

connectionMyDB(Connection) :-
    odbc_connect('nokia-3310', Connection,[]).

disconnect(Connection) :-
    odbc_disconnect(Connection).