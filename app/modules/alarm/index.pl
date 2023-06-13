:- module(alarm, [mainAlarm/0,sistemAlarm/0]).
:- use_module(alarme_bd).
:- use_module(library(thread)).
 mainAlarm :-
    connect,
    writeln('-----------------'),
    writeln('-----Alarmes-----'),
    writeln('1 - Adicionar alarme'),
    writeln('2 - Listar alarmes'),
    writeln('3 - Remover alarme'),
    writeln('4 - Atualizar alarme'),
    writeln('0 - Sair'),
    writeln('-----------'),
    read(Choice),
    (Choice == 0 -> nl;
    Choice == 1 -> addAlarm;
    Choice == 2 -> listAlarms;
    Choice == 3 -> removeAlarm;
    Choice == 4 -> updateAlarm;
    writeln("opcao invalida"),mainAlarm).


validar_hora(Hora) :-
    term_string(Hora, String),
    atomic_list_concat([Horas, Minutos], ':', String),
    atom_number(Horas, HorasNum),
    atom_number(Minutos, MinutosNum),
    integer(HorasNum),
    integer(MinutosNum),
    HorasNum >= 0,
    HorasNum < 24,
    MinutosNum >= 0, 
    MinutosNum < 60.

addAlarm :-
    writeln('------------------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme (no formato hh:mm) ou 0 para sair:'),
    read(Timer),
    (Timer \= 0 ->
    (validar_hora(Timer) ->
        writeln('Digite o titulo do alarme ou 0 para sair:'),
        read(Title),
        (Title \= 0 -> 
            writeln('Adicionado com sucesso!'),
            term_string(Timer,TimerString),
            term_string(Title,TitleString),
            insertAlarm(TimerString, TitleString),
            mainAlarm
        ;   
            writeln('Operacao cancelada.'),
            mainAlarm
        )
    ;
        writeln('Hora informada nao esta adequada (no formato hh:mm)'),
        writeln('-----------'),
        addAlarm
    )
;
    writeln('Operacao cancelada.'),
    writeln('-----------'),
    mainAlarm
).


listAlarms :-
    writeln('---Listar alarmes----'),
    getAlarms(Alarms),
    printAlarms(Alarms),
    mainAlarm.

printAlarms([]).
printAlarms([Alarm|Rest]) :-
    printAlarm(Alarm),
    printAlarms(Rest).

printAlarm(Alarm) :-
    arg(2, Alarm, Time),
    arg(3, Alarm, Title),
    arg(4, Alarm, Active),
    arg(1,Time,Hora),
    arg(2,Time,Minutos),
    write('Time: '), format("~d:~d",[Hora,Minutos]),nl,
    write('Title: '), writeln(Title),
    write('Active: '), writeln(Active).

removeAlarm :-
    writeln('-----------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja remover (no formato hh:mm):'),
    read(Timer),
    (Timer \= 0 ->
        (validar_hora(Timer) ->
                term_string(Timer,TimerString),
                deleteAlarms(TimerString),
                writeln('alarme apagado com sucesso'),
                mainAlarm
            ;   
                writeln('Hora informada não está adequada (no formato hh:mm)'),
                writeln('-----------'),
                removeAlarm
            )
            ; 
            writeln('Operação cancelada.'),
                mainAlarm).
    
updateAlarm :-
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja alterar (no formato hh:mm) ou 0 para sair:'),
    read(Timer),
    (Timer \= 0 ->
    (validar_hora(Timer) ->
           writeln('Digite o novo horario do alarme (no formato hh:mm) ou 0 para sair:'),
            read(Newtimer),
            (Timer \= 0 ->
                (validar_hora(Newtimer) ->
                    writeln('Digite o titulo do alarme ou 0 para sair:'),
                    read(Title),
                    (Title \= 0 -> 
                        term_string(Timer,TimerString),
                        term_string(Title,TitleString),
                        term_string(Newtimer,NewtimerString),
                        upAlarms(TimerString,NewtimerString,Title),
                        writeln('Alterado com sucesso!'),
                        mainAlarm
                    ;   
                    writeln('Operacao cancelada.'),mainAlarm
                    )
                    ;
                    writeln('Hora informada nao esta adequada (no formato hh:mm)'),
                    writeln('-----------'),
                    updateAlarm
                    )
                ;
                writeln('Operacao cancelada.'),
                writeln('-----------'),mainAlarm)
    ;
        writeln('Hora informada nao esta adequada (no formato hh:mm)'),
        writeln('-----------'),
        updateAlarm
    )
;
    writeln('Operacao cancelada.'),
    writeln('-----------'),mainAlarm
).


sistemAlarm:-
    get_time(Timer),
    stamp_date_time(Timer, TimerAd, 'UTC'),
    format_time(atom(StartedAtString), '%H:%M', TimerAd),
    verificationAlarms(StartedAtString,E),
    (E -> writeln('Alarme disparou'), sleep(20),sistemAlarm ; (sleep(20),sistemAlarm)).

create_thread :-
    thread_create(SistemAlarm, _, [detached(true)]).

