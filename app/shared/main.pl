:- use_module('../modules/call/main.pl').
:- use_module('../modules/message/message.pl').
:- use_module('../modules/contacts/agenda.pl').
:- use_module('../modules/calendar/index.pl').

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
    process(Op).

process(0) :- writeln("Desligando...");
process(1) :- mainAgenda.
process(2) :- mainCalls.
process(3) :- mainMessage.
process(4) :- mainCalendar.
process(5) :- writeln("Alarmes").
process(_) :- writeln("Opção inválida!"), main.

main([]) :-
    main.