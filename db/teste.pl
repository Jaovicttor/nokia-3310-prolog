:- use_module(connection).

getChips(Chips) :-
    connectionMyDB(Connection),
    findall(Chip,
            odbc_query(Connection,
            'Select * from chips order by id',
            Chip),
        Chips
        ).

main:-
    getChips(Chips),
    print(Chips).