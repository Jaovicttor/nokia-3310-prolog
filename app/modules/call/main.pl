:- module(call, [mainCalls/0]).
:- use_module(library(odbc)).
:- use_module(library(date)).

getChip(ChipId):- ChipId is 1.

connect:-
    odbc_connect('nokia-3310', _, [
        alias(dbConn)
    ]).

remove_by_index(List, Index, NewList) :-
    nth0(Index, List, _, Rest),
    nth0(Index, NewList, Rest).

integer_to_string(Int, String) :-
    number_codes(Int, Codes),
    atom_codes(String, Codes).

generate_list([], []).
generate_list([X|Rest], [X|List]) :-
    generate_list(Rest, List).

listCalls(ChipId, R) :-
    odbc_prepare(dbConn,
        'SELECT c.*, s.number, r.number FROM calls c JOIN chips s ON c.sented_by = s.id JOIN chips r ON c.received_by = r.id WHERE (sented_by = ? AND has_sender_deleted = false) OR (received_by = ? AND has_receiver_deleted = false) ORDER BY started_at DESC',
        [integer, integer],
        Statement
    ),
    findall(Call,
        odbc_execute(Statement, [ChipId, ChipId], Call),
        Result
    ),
    generate_list(R, Result).

generateRandomCallData(Duration, R):-
    random(0, 100, Value),
    get_time(Time),
    RoundedTime is round(Time),
    FutureTime is Duration * 1000 + RoundedTime,
    (
        Value mod 2 =:= 0 -> R = callData(1, RoundedTime, FutureTime);
        R = callData(0, RoundedTime, FutureTime)
    ).

print_call_time_counter(Seconds):-
    Delay is 1,
    print_counter(0, Seconds, Delay).

print_counter(Current, Seconds, Delay) :-
    Current =< Seconds,
    formatTime(Current, M, T),
    (
        T < 10 -> (
            write('\r'), write(M), write(':'), write('0'), write(T)
        );
        (
            write('\r'), 
            write(M), 
            write(':'),
            write(T)
        )
    ),
    flush_output,
    write("\e[0K"),
    sleep(Delay),
    Next is Current + 1,
    print_counter(Next, Seconds, Delay).

formatTime(S, M, T) :-
    divmod(S, 60, M, T).

execute_call(ChipId, Number):-
    odbc_prepare(dbConn,
        'select * from chips where number = ?;',
        [varchar],
        Statement
    ),
    odbc_execute(Statement, [Number], ReceiverChip),
    arg(1, ReceiverChip, ReceiverChipId),
    arg(4, ReceiverChip, IsChipOn),
    (
        IsChipOn = '1' -> (
            random(5, 30, CallDuration),
            writeln("[+] Chamando..."),
            generateRandomCallData(CallDuration, R),
            arg(1, R, HasAnsweredCall),
            arg(2, R, StartedAt),
            arg(3, R, FinishedAt),
            stamp_date_time(StartedAt, StartedAtDate, 'UTC'),
            stamp_date_time(FinishedAt, FinishedAtDate, 'UTC'),
            format_time(atom(StartedAtString), '%Y-%m-%d %H:%M:%S', StartedAtDate),
            format_time(atom(FinishedAtString), '%Y-%m-%d %H:%M:%S', FinishedAtDate),
            odbc_prepare(dbConn,
                'insert into calls (started_at, finish_at, answered, sented_by, received_by, has_sender_deleted, has_receiver_deleted) values (?, ?, ?, ?, ?, ?, ?)',
                [varchar, varchar, integer, integer, integer, integer, integer],
                InsertStatement
            ),
            odbc_execute(InsertStatement, [StartedAtString, FinishedAtString, HasAnsweredCall, ChipId, ReceiverChipId, 0, 0], _),
            (
                HasAnsweredCall = 1 -> (
                    writeln("[+] Em andamento..."),
                    print_call_time_counter(CallDuration),
                    writeln("[+] Encerrada..."),
                    mainCalls
                );
                HasAnsweredCall = 0 -> (
                    writeln("[!] Ligação Recusada"),
                    mainCalls
                )
            )
        );
        IsChipOn = '0' -> (
            writeln("[!] Número não pode receber chamadas nesse momento"),
            mainCalls
        )
    ).

doCall(ChipId, N):- 
    integer_to_string(N, S),
    string_length(S, L),
    (
        L = 3;
        L = 9;
        L = 11
    ),
    odbc_prepare(dbConn,
        'select id, name, phone, speed_dial from contacts where chip_id = ? and phone = ?',
        [integer, varchar],
        Statement
    ),
    (
        (
            odbc_execute(Statement, [ChipId, S], Contact),
            arg(2, Contact, Name),
            format("~s...\n", [Name])
        );
        (
            format("~s...\n", [S])
        )
    ),
    execute_call(ChipId, S).
doCall(ChipId, N):- 
    N >= 0,
    N =< 9,
    odbc_prepare(dbConn,
        'select id, name, phone, speed_dial from contacts where chip_id = ? and speed_dial = ?',
        [integer, integer],
        Statement
    ),
    (
        (
            odbc_execute(Statement, [ChipId, N], Contact),
            arg(2, Contact, Name),
            arg(3, Contact, Number),
            format("~s...\n", [Name]),
            execute_call(ChipId, Number)
        );
        (
            writeln("[!] Speed Dial não encontrado"),
            mainCalls
        )
    ).
doCall(_, _):- 
    writeln("[!] Número inválido"),
    mainCalls.

deleteCall(ChipId, C, R):-
    writeln("[+] Qual chamada gostaria de apagar ?"),
    read(I),
    Index is I - 1,
    nth0(Index, C, Call),
    arg(1, Call, CallId),
    arg(5, Call, SentedBy),
    arg(6, Call, ReceivedBy),
    (
        SentedBy = ChipId -> (
            odbc_prepare(dbConn,
                'update calls set has_sender_deleted = ? where id = ?;',
            [integer, integer],
            Statement),
            odbc_execute(Statement, [1, CallId], _)
        );
        ReceivedBy = ChipId -> (
            odbc_prepare(dbConn,
                'update calls set has_receiver_deleted = ? where id = ?;',
            [integer, integer],
            Statement),
            odbc_execute(Statement, [1, CallId], _)
        )
    ),
    remove_by_index(C, Index, List),
    generate_list(R, List).

formatCallPrint(ChipId, Call, R):-
    arg(5, Call, SentedBy),
    arg(6, Call, ReceivedBy),
    (
        SentedBy = ChipId -> (
            (
                arg(10, Call, ReceiverNumber),
                odbc_prepare(dbConn,
                    'select id, name, phone, speed_dial from contacts where chip_id = ? and phone = ?',
                [integer, varchar],
                Statement),
                odbc_execute(Statement, [ChipId, ReceiverNumber], Contact),
                arg(2, Contact, Name),
                R = Name
            );
            (
                arg(10, Call, Number),
                R = Number
            )
        );
        ReceivedBy = ChipId -> (
            (
                arg(9, Call, SenderNumber),
                odbc_prepare(dbConn,
                    'select id, name, phone, speed_dial from contacts where chip_id = ? and phone = ?',
                [integer, varchar],
                Statement),
                odbc_execute(Statement, [ChipId, SenderNumber], Contact),
                arg(2, Contact, Name),
                R = Name
            );
            (
                arg(9, Call, Number),
                R = Number
            )
        )
    ).

printCalls([], _).
printCalls([A|B], I):-
    getChip(Id),
    formatCallPrint(Id, A, R),
    format("~d - ~s\n", [I, R]),
    Z is I + 1,
    printCalls(B, Z).
proxySelectedOption(1):-
    writeln("-> Digite o número que deseja ligar: "),
    read(N),
    doCall(1, N).
proxySelectedOption(2):- 
    writeln("-> Seu Histórico"),
    getChip(Id),
    listCalls(Id, C),
    printCalls(C, 1),
    writeln("[x] - apagar chamada"),
    writeln("[0] - menu"),
    read(O),
    (
        O = 'x' -> (
            deleteCall(Id, C, _),
            mainCalls
        );
        O = 0 -> mainCalls;
        (
            writeln("[!] Opção inválida"),
            mainCalls
        )
    ).
proxySelectedOption(0):- !.
proxySelectedOption(_):-
    writeln("[!] Opção inválida"),
    mainCalls.

mainCalls:-
    connect,
    writeln("[1] - Fazer Ligação"),
    writeln("[2] - Listar Histórico"),
    writeln("[0] - Sair"),
    read(O),
    proxySelectedOption(O),
    mainCalls.