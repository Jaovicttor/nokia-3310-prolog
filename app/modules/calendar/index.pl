#menu 
menu :-
    write('Menu:'), nl,
    write('1. Adicionar Evento'), nl,
    write('2. Remover Evento'), nl,
    write('3. Listar Todos os Eventos'), nl,
    write('4. Listar Eventos Anteriores'), nl,
    write('5. Listar Próximos Eventos'), nl,
    write('6. Voltar'), nl,
    read_option(Choice),
    process_option(Choice).

read_option(Choice) :-
    write('Enter your choice: '),
    read(Choice).

process_option(1) :-
    write('Adicionar Evento'), nl, adicionarEvento. 

process_option(2) :-
    write('Remover Evento'), nl, removerEvento. #todo remover evento

process_option(3) :-
    write('Listar Todos os Eventos'), nl, listarTodosEventos.  #todo Listar evento choice

process_option(4) :-
    write('Listar Eventos Anteriores'), nl, listarEventosAnteriores.  #todo Listar evento choice

process_option(5) :-
    write('Listar Próximos Eventos'), nl, listarEventosProximos.  #todo Listar evento choice

process_option(6) :-
     write('Voltar'), nl. #todo voltar para tela incial

process_option(_) :-
    write('Invalid choice'), nl.


adicionarEvento :-
    write('Nome do evento: '),
    read(Nome),
    write('Data do evento (DD/MM/AAAA): '),
    write('Dia: '), read(Dia), 
    write('Mês: '), read(Mes), 
    write('Ano: '), read(Ano), 
    write('Escreva um Comentário: '),
    read(Comentario),
    cadastrarEvento(Nome, Dia, Mes, Ano, Comentario), 
    write('Evento cadastrado com sucesso!'), nl.

cadastrarEvento(Nome, Dia, Mes, Ano, Comentario):-
  Dia > 1 -> Dia =< 31,
  Mes > 1 -> Mes =< 12,
  Ano > 1950 -> Ano =< 2050,
  Data = Dia/Mes/Ano,
  write('Data válida!'), nl.
  #todo call insert DB

cadastrarEvento(Nome, _, _, _, Comentario):-
  write('Data inválida!'), nl, adicionarEvento.

#todo formatacao listagem de eventos
removerEvento :-
    write('Nome do evento: '),
    read(Nome),
    write('Data do evento (DD/MM/AAAA): '),
    read(Data),
    (removerEvento(Nome, Data) -> 
            write('Evento removido com sucesso!'), nl; write('Erro ao remover evento!'), nl).

removerEvento(Nome, Data):-
    #call all in a list
    #choice de remove one
    #todo call remove DB

listarTodosEventos :-
    #todo call list all DB

listarEventosAnteriores :-
    #todo call list previus DB

listarEventosProximos :-
    #todo call list next DB

#Trabalhar nas validacoes

