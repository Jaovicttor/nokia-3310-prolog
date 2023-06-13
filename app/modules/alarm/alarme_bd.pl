:- module(alarme_bd, [connect/0, insertAlarm/2, getAlarms/1, deleteAlarms/1, checkAlarm/1,upAlarms/3,verificationAlarms/2]).
:- use_module(library(odbc)).
:- use_module('../../modules/message/chip_bd.pl').

connect:-
    odbc_connect('nokia-3310', Connection, [alias(dbConn)]).

insertAlarm(Timer, Title) :-
    myChip(Chip_id), 
    odbc_prepare(dbConn,
        'INSERT INTO alarms (deadline, title, active, chip_id) VALUES (?, ?, ?, ?)',
        [varchar, varchar, integer, integer],
        Statement
    ),
    odbc_execute(Statement, [Timer, Title, 1, Chip_id], _).

generate_list([], []).
generate_list([X|Rest], [X|List]) :-
    generate_list(Rest, List).

getAlarms(Resultado) :-
    myChip(Chip_id),
    odbc_prepare(dbConn,
        'select * FROM alarms WHERE chip_id = ? ORDER BY deadline',
        [integer],
        Statement),
    findall(Alarms,
            odbc_execute(Statement,[Chip_id],Alarms),
        Result
        ),generate_list(Resultado,Result).

deleteAlarms(Timer) :-
    myChip(Chip_id),
    odbc_prepare(dbConn,
        'DELETE FROM alarms WHERE chip_id = ? AND deadline = ?',
        [integer, varchar],
        Statement),
         odbc_execute(Statement, [Chip_id, Timer], _).


upAlarms(OldTimer, CurrentTimer, Title):-
    myChip(Chip_id),
    odbc_prepare(dbConn,
        'UPDATE alarms SET deadline = ?, title = ? WHERE chip_id = ? AND deadline = ?',
        [varchar, varchar, integer, varchar],
        Statement),
        odbc_execute(Statement, [CurrentTimer, Title,Chip_id,OldTimer], _).


verificationAlarms(Timer,E) :-
    connect,
    myChip(Chip_id),
    odbc_prepare(dbConn,
        'SELECT * FROM alarms WHERE chip_id = ? AND deadline = ?',
        [integer, varchar],
        Statement),
        (odbc_execute(Statement, [Chip_id,Timer], Result)-> E is Result; E = false).    