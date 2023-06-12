:- module(calendar, [menuCalendar/0]).

:-use_module(library(csv)).

/* Metodos para persistência. */
readCsv(Lists):-
    csv_read_file('./app/modules/calendar/data/dados.csv', Rows, []),
    rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

listEvent :-
    readCsv(Resultado),
    printResult(Resultado, Resultado).

printResult([], _).
printResult([Head|Tail], FirstList) :-
    element_index(Head, FirstList, Index),
    write(Index), write(' - '), writeln(Head),
    printResult(Tail, FirstList).

element_index(Element, List, Index) :-
    nth1(Index, List, Element).

addEventDB(Nome, Data, Comentario) :-
    open('./app/modules/calendar/data/dados.csv', append, Fluxo),
    nl(Fluxo),
    format(Fluxo, '~w  - ~w - ~w', [Nome, Data, Comentario]),
    close(Fluxo).

cleanCsv:-
    open('./app/modules/calendar/data/dados.csv', write, Fluxo),
    write(Fluxo, ''),
    close(Fluxo).

writeCsv(Line):-
    open('./app/modules/calendar/data/dados.csv', append, Fluxo),
    format(Fluxo, '~w', Line),
    close(Fluxo).

/* Metodos para escolha de menu */
menuCalendar :-
    writeln('-------------------NOKIA-------------------'),  
    writeln('-------------------menu:-------------------'),
    writeln('  1. Adicionar Evento'),
    writeln('  2. Remover Evento'),
    writeln('  3. Listar Todos os Eventos'),
    writeln('  4. Deletar Todos os Eventos'),
    writeln('  5. Voltar'),
    writeln('-------------------------------------------'),
    read_option(Choice),
    process_option(Choice).

read_option(Choice) :-
    write('Enter your choice: '),
    read(Choice).

process_option(1) :-
    write('Adicionar Evento'), nl, addEvent. 

process_option(2) :-
    write('Remover Evento'), nl, removeEvent. 

process_option(3) :-
    write('Listar Todos os Eventos'), nl, listAll. 

process_option(4) :-
    write('Deletas Todos os Eventos'), nl, cleanCsv, menuCalendar. 

process_option(5) :-
     write('Voltar'), nl. 

process_option(_) :-
    write('Opção inválida!'), nl, menuCalendar.

/* Metodos de funcinalidades do programa*/

/* Adicionar */
addEvent :-
    writeln('--------------Adicionar Evento-------------'),
    writeln('Nomes e Comentários com espaçamento devem'),
    writeln('ser postos entre aspas simples.'),
    write('Nome do evento: '), nl,
    read(Nome),
    writeln('Data do evento (DD/MM/AAAA): '), 
    write('Dia: '), read(Dia), 
    write('Mês: '), read(Mes), 
    write('Ano: '), read(Ano), 
    write('Escreva um Comentário: '), nl,
    read(Comentario),
    registerEvent(Nome, Dia, Mes, Ano, Comentario), 
    writeln('-------------------------------------------'),
    menuCalendar.

registerEvent(Nome, Dia, Mes, Ano, Comentario):-
  Dia > 0 -> Dia =< 31,
  Mes > 0 -> Mes =< 12,
  Ano > 0 -> Ano =< 9999,
  Data = Dia/Mes/Ano,
  write('Data válida!'), 
  writeln('Evento cadastrado com sucesso!'),
  addEventDB(Nome, Data, Comentario),
  nl, !.

registerEvent(_, _, _, _, _):-
  write('Data inválida!'), nl, !.

/* Remover */
removeEvent :-
    writeln('---------------Remover Evento--------------'),
    listEvent, nl,
    write('Index do evento: '),
    read(Index),
    readCsv(ListaEventos),
    remove_element_by_index(Index, ListaEventos, ListaEventosAtualizada),
    cleanCsv,
    rewriteEvent(ListaEventosAtualizada),
   writeln('--------------------------------------------'),
    menuCalendar.

rewriteEvent([]):-
    write('Evento excluido com sucesso!').
rewriteEvent([Head|Tail]):-
    writeCsv(Head),
    rewriteEvent(Tail).

remove_element_by_index(Index, List, NewList):-
    newIndex(Index, NI),
    length(Prefix, NI),
    append(Prefix, [_|Suffix], List),
    append(Prefix, Suffix, NewList).

newIndex(Index, Result):- 
    Result is Index - 1.

/* Listar */
listAll :-
  writeln('----------Listar Todos os Eventos----------'),
  nl, listEvent, nl,
  writeln('-------------------------------------------'),
  menuCalendar.
