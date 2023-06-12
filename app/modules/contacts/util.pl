:-use_module(library(csv)).

/* Ler um arquivo csv e retorna uma lista de lista. */
lerArquivoCsv(Arquivo, Lists):-
    atom_concat('/Users/jhenriqueax/Desktop/PLP/data/', Arquivo, Path),
    csv_read_file(Path, Rows, []),
    rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
    Row =.. [row|List].

listaContato :-
    lerArquivoCsv('dados.csv', Resultado),
    imprimirResultado(Resultado).

imprimirResultado([]).
imprimirResultado([Lista|Resto]) :-
    writeln(Lista),
    imprimirResultado(Resto).

cadastrarContato(Param):-
    open('/Users/jhenriqueax/Desktop/PLP/data/dados.csv', append, Fluxo),
    writeln(Fluxo, (Param)),
    close(Fluxo).

removegg(_, [], []).
removegg(Nome, [H|T], Z):- (nth1(1, H, Nome) -> Z = H; removegg(Nome, T, Z)).

remove(X, [X|T], T).
remove(X, [H|T], [H|T1]):- remove(X,T,T1).

limpaCsv(Arquivo):-
    atom_concat('/Users/jhenriqueax/Desktop/PLP/data/', Arquivo, Path),
    open(Path, write, Fluxo),
    write(Fluxo, ''),
    close(Fluxo).

funcionariosExcluido:-
     writeln("\nFUNCIONARIO EXCLUIDO COM SUCESSO!").

reescrevePessoa([]).
reescrevePessoa([H|T]):-
    nth0(0, H, Name), % Indice 0
    nth0(1, H, Phone), % Indice 1
    cadastrarPessoa(Name, Phone),
    reescrevePessoa(T).


cadastrarPessoa(Name, Phone):-
    open('/Users/jhenriqueax/Desktop/PLP/data/dados.csv', append, Fluxo),
    writeln(Fluxo, (Name, Phone)),
    close(Fluxo).

contemMember(_, [], false).
contemMember(Busca, [H|T], R):-
    (member(Busca, H) -> R = true ; contemMember(Busca, T, R)
    ).

usuarioCadastrado:-
    writeln("\nUSUÁRIO JÁ CADASTRADO!\n").

contatoExcluido:-
     writeln("\nCONTATO EXCLUIDO COM SUCESSO!\n").

contatoCadastrado:-
     writeln("\nCONTATO CADASTRADO COM SUCESSO!\n").

