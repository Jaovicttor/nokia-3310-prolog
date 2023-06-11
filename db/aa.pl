disconnect(Connection) :-
    odbc_disconnect(Connection).

getChips(Chips) :-
    connect(Connection),
    findall(Chip,
            odbc_query(Connection,
            'Select * from chips order by id',
            Chip),
        Chips
        ).

getChipById(Chip_id,Chip) :-
    connect(Connection),
    odbc_query(Connection,'Select * from chips where id = \ order by id', Chips).

execute_query(Query,Result) :-
    connect(Connection),
    odbc_query(Connection, Query, Result).

buscar_todos_chips( Result) :-
    Query = 'SELECT * FROM chips where id = 1',
    execute_query(Query, Result).

main:-
    buscar_todos_chips(Result),
    Result = row(Id,Nome,Telefone,On),
    write(Nome).