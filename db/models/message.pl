:- use_module(library(odbc)).

connect(Connection):-
    odbc_connect('nokia-3310', Connection, []).

generate_list([], []).
generate_list([X|Rest], [X|List]) :-
    generate_list(Rest, List).

insertMessage(Message, Received_by):-
    connect(Connection),
    odbc_prepare(Connection,
            'insert into messages (message, message_date, sented_by, received_by ) values (?,?,?,?)',
            [varchar, varchar, integer, integer],
            Statement
        ),
    odbc_execute(Statement, [Message, '2023-06-10 00:00:00.000', 1, Received_by], _).

getConversations(Conversations):-
    connect(Connection),
    odbc_prepare(Connection,
            'select c.id, c2.name, c.number from messages m join chips c on (c.id = m.sented_by or c.id  = m.received_by) left join contacts c2 on c2.phone = c.number where ((m.received_by = ? and  available_received_by = true)  or (m.sented_by = ? and available_sented_by = true) ) and (c2.chip_id = ? or c2.chip_id is null) and c.id != ? group by name,number,c.id',
            [integer, integer, integer, integer],
            Statement
        ),
    Chip_id = 1,
    odbc_execute(Statement, [Chip_id, Chip_id, Chip_id, Chip_id], Conversations).

conversationsToString([], _, []):-
conversationsToString((X|Xs), Cont, Conversations_String):- format("~d - ~s\n~s", [Name]) Conversations_String is (Cont +1)