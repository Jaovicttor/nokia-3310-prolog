mainAlarm :- 
    writeln("-----------"),
    writeln("-----Alarmes-----"),
    writeln("1 - Adicionar alarme"),
    writeln("2 - Listar alarmes"),
    writeln("0 - Sair"),
    writeln("-----------"),
    read(Choice),
    select(Choice).

select("0") :-
    true.
select("1") :-
    addAlarm,
    mainAlarm.
select("2") :-
    listAlarms,
    mainAlarm.
processselect("-") :-
    true.
processselect(_) :-
    writeln("Opção inválida!"),
    mainAlarm.


addAlarm :-
    writeln("-----------"),
    writeln("-----Alarmes------"),
    writeln("Digite a hora do alarme (no formato hh:mm):"),
    read_line_to_string(user_input, TimeInput),
    (parse_time(TimeInput, Time) ->
        (checkAlarm(Time, Var),
        (Var = true ->
            (writeln("Digite o título do alarme:"),
            read_line_to_string(user_input, Title),
            (Title \= "-" ->
                (insertAlarm(Time, Title, MyChipId),
                writeln("Alarme adicionado com sucesso!"))
                ; true)
                )
            ; (writeln("Alarme já existe"),
                addAlarm)
            )
            )
        ; (TimeInput = "-" ->
            true
        ; (writeln("Formato de hora inválido. Por favor, use o formato hh:mm."),
            addAlarm)
        )).
    
    parse_time(TimeInput, Time) :-
        split_string(TimeInput, ":", "", [HourStr, MinuteStr]),
        number_string(Hour, HourStr),
        number_string(Minute, MinuteStr),
        Time = time(Hour, Minute, 0).

        listAlarms :-
            writeln("Listar alarmes").