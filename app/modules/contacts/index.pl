:- include('util.pl').

consult('dados.pl').

mainContacts :-
    menuLoop.

menuLoop :-
    write('1 - Listar Contatos'), nl,
    write('2 - Adicionar Contato'), nl,
    write('3 - Remover Contato'), nl,
    write('0 - Voltar ao Menu'), nl,
    read(Choice),
    processChoice(Choice).

processChoice(1) :-
    listContact,
    menuLoop.
processChoice(2) :-
    addContact,
    menuLoop.
processChoice(3) :-
    removeContact,
    menuLoop.
processChoice(0) :-
    write('TODO'), halt.
processChoice(_) :-
    write('Opção inválida! Tente novamente.'), nl,
    menuLoop.

addContact():-
      write("Primeiro Nome:"),
      read(Nome),
      write("Contato:"),
      read(Cpf),
      contemMember(Nome,Resultado,Resultado2),
      (Resultado2 -> usuarioCadastrado, menuLoop ; write("")),
      lerArquivoCsv('dados.csv',Resultado),
      cadastrarPessoa(Nome, Cpf),
      contatoCadastrado.


listContact :-
    write('-----Lista de Contatos-----'), nl,
    nl, listaContato, nl,
    menuLoop.

removeContact :-
    write('-----Remover Contatos-----'), nl,
    nl, listaContato, nl,
    write("digite nome: "),
    read(Name),
    lerArquivoCsv('dados.csv',Resultado),
    removegg(Name,Resultado, Z),
    remove(Z,Resultado,NameExlcuidos),
    limpaCsv('dados.csv'),
    reescrevePessoa(NameExlcuidos),
    contatoExcluido.


