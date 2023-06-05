mainAlarm :-
    writeln('-----------'),
    writeln('-----Alarmes-----'),
    writeln('1 - Adicionar alarme'),
    writeln('2 - Listar alarmes'),
    writeln('0 - Sair'),
    writeln('-----------'),
    read(Choice),
    select(Choice).

select(0) :-
    true.
select(1) :-
    addAlarm,
    mainAlarm.
select(2) :-
    listAlarms,
    mainAlarm.
select(3) :-
    removeAlarm,
    mainAlarm.
select(4):-
    updateAlarm,
    mainAlarm.
select(5):-
    activeAlarm,
    mainAlarm.
select('-') :-
    true.
select(_) :-
    writeln('Opção inválida!'),
    mainAlarm.



addAlarm :-
    writeln('-----------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme (no formato hh:mm):'),
    read_line_to_string(user_input, TimeInput),
    (TimeInput = '-' ->
        true
    ; (parse_time(TimeInput, Time) ->
        (writeln('Digite o título do alarme:'),
        read_line_to_string(user_input, Title),
        (Title \= '-' ->
            (insertAlarm(Time, Title),
            writeln('Alarme adicionado com sucesso!'))
        ; true))
    ; (writeln("Formato de hora inválido. Por favor, use o formato hh:mm."),
        addAlarm)
    )).

parse_time(TimeInput, Time) :-
    split_string(TimeInput, ':', '', [HourStr, MinuteStr]),
    number_string(Hour, HourStr),
    number_string(Minute, MinuteStr),
    Time = time(Hour, Minute, 0).

listAlarms :-

    writeln('em construcao'),
    writeln('---Listar alarmes----'),
    writeln('3 - Excluir alarme'),
    writeln('4 - Editar alarme'),
    writeln('5 - Ativar/Desativar alarme'),
    writeln('0 - Sair'),
    read(Choice),
    select(Choice).

removeAlarm:-
    writeln('-----------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja remover (no formato hh:mm):'),
    read_line_to_string(user_input, TimeInput),
    (TimeInput = '-' ->
        true
    ;(parse_time(TimeInput, Time) ->
            (writeln('Alarme apagado com sucesso!'),
            deleteAlarm(Time))
        ; true); (writeln("Formato de hora inválido. Por favor, use o formato hh:mm."),
        removeAlarm)).
updateAlarm:-
    writelN('em construcao').

activeAlarm:-
    writeln('em construcao').



