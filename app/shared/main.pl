:- use_module('../modules/call/main.pl').
:- use_module('../modules/message/message.pl').

main :-
    writeln('-----------NOKIA------------'),   
    writeln('1 - Contatos'),
    writeln('2 - Ligação'),
    writeln('3 - Mensagens'),
    writeln('4 - Calendário'),
    writeln('5 - Alarmes'),
    writeln('0 - Desligar'),
    writeln('----------------------------'),
    read(Op),
    (
        Op == 0       -> writeln("Desligando...");
        (
            (
                Op == 1       -> ln;
                Op == 2       -> mainCalls;
                Op == 3       -> mainMessage;
                Op == 4       -> mainContacts;
                Op == 5       -> ln;
                writeln('Opcao invalida')
            ), main
        )
        
    ).