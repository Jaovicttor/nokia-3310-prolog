:- module(message_bd, [integer_to_string/2, connect/1, insertMessage/2, findByNumber/2, getConversations/1, deleteConversation/1, getMessages/2]).
:- use_module(library(odbc)).
:- use_module(chip_bd).

integer_to_string(Int, String) :-
    number_codes(Int, Codes),
    atom_codes(String, Codes).


connect(Connection):-
    odbc_connect('nokia-3310', Connection, []).

insertMessage(Message, Received_by):-
    connect(Connection),
    get_time(Time),
    odbc_prepare(Connection,
            'insert into messages (message, message_date, sented_by, received_by ) values (?,?,?,?)',
            [varchar, timestamp, integer, integer],
            Statement
        ),
    myChip(Chip_id),
    odbc_execute(Statement, [Message, Time, Chip_id, Received_by], _).

findByNumber(Number, Chip):-
    connect(Connection),
    odbc_prepare(Connection,
                'select id from chips where number = ?',
                [varchar],
                Statement
            ),
            (
                odbc_execute(Statement, [Number], Chip);
                Chip = []
            ).

getConversations(Conversations):-
    connect(Connection),
    myChip(Chip_id),
    odbc_prepare(Connection,
            'select c.id, c2.name, c.number from messages m join chips c on (c.id = m.sented_by or c.id  = m.received_by) left join contacts c2 on c2.phone = c.number where ((m.received_by = ? and  available_received_by = true)  or (m.sented_by = ? and available_sented_by = true) ) and (c2.chip_id = ? or c2.chip_id is null) and c.id != ? group by name,number,c.id',
            [integer, integer, integer, integer],
            Statement
        ),

    findall(Conversation,
            odbc_execute(Statement,[Chip_id, Chip_id, Chip_id, Chip_id],Conversation),
        Conversations
        ).

deleteConversation(Received_by):-
    deleteSentedMessage(Received_by),
    deleteReceivedMessage(Received_by).

deleteSentedMessage(RB):-
    connect(Connection),
    odbc_prepare(Connection,
            'update messages set available_sented_by = false where sented_by = ? and received_by = ? and available_sented_by = true;',
            [integer, integer],
            Statement
        ),
    myChip(Chip_id),
    odbc_execute(Statement, [Chip_id, RB], _).

deleteReceivedMessage(RB):-
    connect(Connection),
    odbc_prepare(Connection,
            'update messages set available_received_by = false where sented_by = ? and received_by = ? and available_received_by = true;',
            [integer, integer],
            Statement
        ),
    myChip(Chip_id),
    odbc_execute(Statement, [RB, Chip_id], _).

getMessages(RB, Messages):-
    connect(Connection),
    odbc_prepare(Connection,
            'select m.message, m.sented_by, m.received_by from messages m where (m.sented_by = ? and m.received_by = ? and available_sented_by = true ) or (m.sented_by = ? and m.received_by = ? and available_received_by = true) order by m.message_date',
            [integer, integer, integer, integer],
            Statement
        ),
    myChip(Chip_id),
    findall(Message,
            odbc_execute(Statement,[Chip_id, RB, RB, Chip_id],Message),
        Messages
        ).

