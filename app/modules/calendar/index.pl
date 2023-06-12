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
    imprimirResultado(Resultado).

imprimirResultado([]).
imprimirResultado([Lista|Resto]) :-
    write(index), writeln(Lista),
    imprimirResultado(Resto).

addEventDB(Nome, Data, Comentario) :-
    open('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', append, Fluxo),
    nl(Fluxo),
    format(Fluxo, '~w  - ~w - ~w', [Nome, Data, Comentario]),
    close(Fluxo).

limpaCsv:-
    open('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', write, Fluxo),
    write(Fluxo, ''),
    close(Fluxo).

menu :-
    write('Menu:'), nl,
    write('1. Adicionar Evento'), nl,
    write('2. Remover Evento'), nl,
    write('3. Listar Todos os Eventos'), nl,
    write('4. Voltar'), nl,
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

format_input(Input, FormattedInput) :-
    atom_concat('\'', Input, Temp),
    atom_concat(Temp, '\'', FormattedInput).

cadastrarEvento(Nome, Dia, Mes, Ano, Comentario):-
  Dia > 1 -> Dia =< 31,
  Mes > 1 -> Mes =< 12,
  Ano > 1950 -> Ano =< 2050,
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

reescreveEvento(List):-
    csv_write_file('/Users/lelefarias/Documents/nokia-3310-prolog/app/modules/calendar/data/dados.csv', List),
    write('Evento excluido com sucesso!').

remove_element_by_index(Index, List, NewList) :-
    length(Prefix, Index),
    append(Prefix, [_|Suffix], List),
    append(Prefix, Suffix, NewList).


delete_line_from_csv(File, LineNumber, NewFile) :-
    csv_read_file(File, Rows),
    select_line(Rows, LineNumber, NewRows),
    csv_write_file(NewFile, NewRows),
    write('Evento removido com sucesso!').

select_line(Rows, LineNumber, NewRows) :-
    nth1(LineNumber, Rows, _, RemovedRow),
    select(RemovedRow, Rows, NewRows).

listarTodosEventos :-
  nl, listEvent, nl, menu.
