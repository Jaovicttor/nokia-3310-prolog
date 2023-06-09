:- module(model_chip, [getChips/1]).

getChips(Chips) :-
    connect(Connection),
    findall(Chip,
            odbc_query(Connection,
            'Select * from chips order by id',
            Chip),
        Chips
        ).