:-use_module(library(csv)).

/* Ler um arquivo csv e retorna uma lista de lista. */
lerArquivoCsv(Lists):-
    csv_read_file('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', Rows, []),
    rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

listEvent :-
    lerArquivoCsv(Resultado),
    imprimirResultado(Resultado, Resultado).

imprimirResultado([], _).
imprimirResultado([Head|Tail], FirstList) :-
    element_index(Head, FirstList, Index),
    write(Index), write(' - '), writeln(Head),
    imprimirResultado(Tail, FirstList).

element_index(Element, List, Index) :-
    nth1(Index, List, Element).

addEventDB(Nome, Data, Comentario) :-
    open('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', append, Fluxo),
    nl(Fluxo),
    format(Fluxo, '~w  - ~w - ~w', [Nome, Data, Comentario]),
    close(Fluxo).

limpaCsv:-
    open('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', write, Fluxo),
    write(Fluxo, ''),
    close(Fluxo).

writeCsv(Line):-
    open('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', append, Fluxo),
    format(Fluxo, '~w', Line),
    close(Fluxo).

menu :-
    write('Menu:'), nl,
    write('1. Adicionar Evento'), nl,
    write('2. Remover Evento'), nl,
    write('3. Listar Todos os Eventos'), nl,
    write('4. Deletar Todos os Eventos'), nl,
    write('5. Voltar'), nl,
    read_option(Choice),
    process_option(Choice).

read_option(Choice) :-
    write('Enter your choice: '),
    read(Choice).

process_option(1) :-
    write('Adicionar Evento'), nl, adicionarEvento. 

process_option(2) :-
    write('Remover Evento'), nl, removerEvento. 

process_option(3) :-
    write('Listar Todos os Eventos'), nl, listarTodosEventos. 

process_option(4) :-
    write('Deletas Todos os Eventos'), nl, limpaCsv, menu. 

process_option(5) :-
     write('Voltar'), nl. 

process_option(_) :-
    write('Opção inválida!'), nl, menu.

adicionarEvento :-
    write('-----Adicionar Evento-----'), nl,
    write('Nomes e Comentários com espaçamento devem ser postos entre aspas simples.'), nl,
    write('Nome do evento: '), nl,
    read(Nome),
    write('Data do evento (DD/MM/AAAA): '), nl,
    write('Dia: '), read(Dia), 
    write('Mês: '), read(Mes), 
    write('Ano: '), read(Ano), 
    write('Escreva um Comentário: '), nl,
    read(Comentario),
    cadastrarEvento(Nome, Dia, Mes, Ano, Comentario),
    write('Evento cadastrado com sucesso!'), nl, menu.

cadastrarEvento(Nome, Dia, Mes, Ano, Comentario):-
  Dia > 0 -> Dia =< 31,
  Mes > 0 -> Mes =< 12,
  Ano > 0 -> Ano =< 9999,
  Data = Dia/Mes/Ano,
  write('Data válida!'), 
  addEventDB(Nome, Data, Comentario),
  nl, !.

cadastrarEvento(_, _, _, _, _):-
  write('Data inválida!'), nl, !.

removerEvento :-
    listEvent, nl,
    write('Index do evento: '),
    read(Index),
    lerArquivoCsv(ListaEventos),
    remove_element_by_index(Index, ListaEventos, ListaEventosAtualizada),
    limpaCsv,
    reescreveEvento(ListaEventosAtualizada),
    menu.

reescreveEvento([]):-
    write('Evento excluido com sucesso!').
reescreveEvento([Head|Tail]):-
    writeCsv(Head),
    reescreveEvento(Tail).
    

remove_element_by_index(Index, List, NewList):-
    newIndex(Index, NI),
    length(Prefix, NI),
    append(Prefix, [_|Suffix], List),
    append(Prefix, Suffix, NewList).

newIndex(Index, Result):- 
    Result is Index - 1.

listarTodosEventos :-
  nl, listEvent, nl, menu.

clean_csv_file(File) :-
    csv_read_file(File, Rows),
    process_rows(Rows, CleanedRows),
    csv_write_file(File, CleanedRows, []).

process_rows([], []).
process_rows([Row | Rows], [CleanedRow | CleanedRows]) :-
    process_row(Row, CleanedRow),
    process_rows(Rows, CleanedRows).

process_row(Row, CleanedRow) :-
    exclude(=(unwanted_value), Row, CleanedRow).
