:- multifile file_search_path/2.
:- dynamic file_search_path/2.

:- prolog_load_context(directory, Dir),
   asserta(file_search_path(meu_projeto, Dir)).

:- use_module(meu_projeto:'chip').


main:-
    print(meu_projeto),
    getChips(Chips),
    print(Chips).