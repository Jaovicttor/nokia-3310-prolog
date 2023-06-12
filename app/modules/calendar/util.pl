:-use_module(library(csv)).

/* Ler um arquivo csv e retorna uma lista de lista. */
lerArquivoCsv(Arquivo, Lists):-
    atom_concat('app/modules/calendar/data/dados.csv', Arquivo, Path),
    csv_read_file(Path, Rows, []),
    rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

listEvent :-
    lerArquivoCsv('dados.csv', Resultado),
    imprimirResultado(Resultado).

imprimirResultado([]).
imprimirResultado([Lista|Resto]) :-
    writeln(Lista),
    imprimirResultado(Resto).

addEventDB(Nome, Data, Comentario) :-
    open('app/modules/calendar/data/dados.csv', append, Fluxo),
    nl(Fluxo),
    format(Fluxo, '~w  - ~w', [Name, Phone]),
    close(Fluxo).
