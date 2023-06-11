:- module(message, [mainMessage/0]).
:- use_module(message_bd).

mainMessage :-
    showConversations,
    writeln('x - Iniciar conversa'),
    writeln('1 - Ler conversa'),
    writeln('2 - Apagar conversa'),
    writeln('0 - Sair'),
    read(Op),
    (
        Op == 'x'     -> startConversation;
        Op == 1       -> formConversation;
        Op == 2       -> formDeleteConversation;
        Op == 0       -> nl;
        writeln('Opcao invalida'), mainMessage
    ).
showConversations :-
    writeln('----------------------------'),   
    getConversations(Conversations),
    printList(Conversations,1),
    writeln('----------------------------').

startConversation :-
    writeln('Numero:'),
    read(Number),
    integer_to_string(Number, Number_String),
    findByNumber(Number_String,Chip),
    (
        Chip == [] -> writeln('Numero invalido');
        (
            Chip = row(Received_by),
            sendMessage(Received_by),
            writeln('Mensagem enviada com sucesso.')
        )
    ),
    mainMessage.
    

formConversation :- 
    showConversations,
    writeln("Informe o nº da conversa:"),
    read(Conversation_number),
    writeln("----------------------------"),
    CN is Conversation_number - 1,
    findConversation(CN).

findConversation(Conversation_number) :- 
    getConversations(Conversations),
    (
        (
            nth0(Conversation_number,Conversations,Conversation),
            showConversation(Conversation)
        );
        (
            writeln("Conversa nao encontrada")
        )
    
    ),
    mainMessage.
   
showConversation(Conversation):-
    toStringConversation(Conversation, Name),
    Conversation = row(Id,_,_),
    getMessages(Id, Messages),
    toStringMessage(Messages,1,Name),
    writeln("----------------------------"),
    writeln("x - Enviar mensagem"),
    writeln("0 - Sair"),
    read(Op),
    (
        Op == 'x'     -> (
                            sendMessage(Id),
                            showConversation(Conversation)
                        );
        Op == 0       -> nl;
        (
            writeln('Opcao invalida'), 
            showConversation(Conversation)
        )
    ).

sendMessage(Received_by):-
    writeln('Message:'),
            read(Message),
            insertMessage(Message,Received_by),
            writeln("----------------------------").

formDeleteConversation :-
    showConversations,
    writeln("Informe o nº da conversa:"),
    read(Conversation_number),
    writeln("----------------------------"),
    CN is Conversation_number - 1,
    delConversation(CN).


delConversation(Conversation_number) :-
   getConversations(Conversations),
    (
        (
            nth0(Conversation_number,Conversations,Conversation),
            Conversation = row(Id,_,_),
            deleteConversation(Id),
            writeln("Conversa apagada com sucesso.")

        );
        (
            writeln("Conversa nao encontrada")
        )
    
    ),
    mainMessage.

printList([X|Xs], K):-
    X = row(_, Name, Phone),
    write(K),
    write(" - "),
    (
        Name = ''       -> write(Phone);
        Name = '$null$' -> write(Phone);
        write(Name)
    ),
    nl,
    C is K +1,
    printList(Xs,C).
printList(_,_):- nl.

toStringConversation(C, S):-
    C = row(_,Name,Phone),
    (
        Name = '$null$' -> S = Phone;
        Name = '' -> S = Phone;
        S = Name
    ).

toStringMessage([M|Ms], Chip_id, Name):-
    M = row(Message, Sented_by,_),
    (
        Sented_by = Chip_id -> format("Voce: ~s\n",[Message]);
        format("~s: ~s\n",[Name,Message])
    ),
    toStringMessage(Ms, Chip_id, Name).
toStringMessage(_,_,_):- nl.