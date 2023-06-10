
mainMessage :-
    writeln('x - Iniciar conversa'),
    writeln('1 - Ler conversa'),
    writeln('2 - Apagar conversa'),
    writeln('0 - Sair'),
    read(Op),
    (
        Op == 'x'   -> write('Enviar mensagem');
        Op == 1     -> write('Ler conversa');
        Op == 2     -> write('Apagar conversa');
        Op =\=      -> write('Opção inválida'), mainMessage
    ).