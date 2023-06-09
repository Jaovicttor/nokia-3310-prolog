 mainAlarm :-
    writeln('-----------------'),
    writeln('-----Alarmes-----'),
    writeln('1 - Adicionar alarme'),
    writeln('2 - Listar alarmes'),
    writeln('0 - Sair'),
    writeln('-----------'),
    read_line_to_string(user_input,Choice),
    select(Choice),
    halt.

select("0") :-
    true.
select("1") :-
    addAlarm,
    mainAlarm.
select("2") :-
    listAlarms,
    mainAlarm.
select("3") :-
    removeAlarm,
    mainAlarm.
select("4") :-
    updateAlarm,
    mainAlarm.
select("5") :-
    activeAlarm,
    mainAlarm.
select(_) :-
    writeln('Opção inválida!'),
    mainAlarm.

validar_hora(Hora) :-
    atomic_list_concat([Horas, Minutos], ':', Hora),
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
    read_line_to_string(user_input,Timer),
    (Timer \= "0" ->
    (validar_hora(Timer) ->
        writeln('Digite o titulo do alarme ou 0 para sair:'),
        read_line_to_string(user_input, Title),
        (Title \= "0" -> 
            alarme()
            writeln('Adicionado com sucesso!')
        ;   
            writeln('Operacao cancelada.')
        )
    ;
        writeln('Hora informada nao esta adequada (no formato hh:mm)'),
        writeln('-----------'),
        addAlarm
    )
;
    writeln('Operacao cancelada.'),
    writeln('-----------')
).


listAlarms :-
    writeln('---Listar alarmes----'),
    writeln('3 - Excluir alarme'),
    writeln('4 - Editar alarme'),
    writeln('5 - Ativar/Desativar alarme'),
    writeln('0 - Sair'),
    read_line_to_string(user_input,Choice),
    select(Choice).

removeAlarm :-
    writeln('-----------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja remover (no formato hh:mm):'),
    read_line_to_string(user_input, Timer),
    (Timer \= "0" ->
        (validar_hora(Timer) ->
                writeln('alarme apagado com sucesso')
            ;   
                writeln('Hora informada não está adequada (no formato hh:mm)'),
                writeln('-----------'),
                removeAlarm
            )
            ; 
            writeln('Operação cancelada.'),
                mainAlarm).
    
updateAlarm :-
    writeln('------------------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja alterar (no formato hh:mm) ou 0 para sair:'),
    read_line_to_string(user_input,Timer),
    (Timer \= "0" ->
    (validar_hora(Timer) ->
           writeln('Digite o novo horario do alarme (no formato hh:mm) ou 0 para sair:'),
            read_line_to_string(user_input,Newtimer),
            (Timer \= "0" ->
                (validar_hora(Newtimer) ->
                    writeln('Digite o titulo do alarme ou 0 para sair:'),
                    read_line_to_string(user_input, Title),
                    (Title \= "0" -> 
                        writeln('Alterado com sucesso! (em construcao)')
                    ;   
                    writeln('Operacao cancelada.')
                    )
                    ;
                    writeln('Hora informada nao esta adequada (no formato hh:mm)'),
                    writeln('-----------'),
                    updateAlarm
                    )
                ;
                writeln('Operacao cancelada.'),
                writeln('-----------'))
    ;
        writeln('Hora informada nao esta adequada (no formato hh:mm)'),
        writeln('-----------'),
        updateAlarm
    )
;
    writeln('Operacao cancelada.'),
    writeln('-----------')
).

activeAlarm :-
    writeln('-----------'),
    writeln('-----Alarmes------'),
    writeln('Digite a hora do alarme que deseja desativar/ativar (no formato hh:mm):'),
    read_line_to_string(user_input, Timer),
    (Timer \= "0" ->
        (validar_hora(Timer) ->
                writeln('alarme alterado com sucesso')
            ;   
                writeln('Hora informada não está adequada (no formato hh:mm)'),
                writeln('-----------'),
                activeAlarm
            )
            ; 
            writeln('Operação cancelada.'),
                mainAlarm).
