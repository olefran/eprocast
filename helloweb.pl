%Oscar Lerma A01380817
%prologGTD
%PrologGTD initial page (index.html).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

:- http_handler(root(.), say_hi, []). %Anonimous calls in prolog files!!

server(Port) :-	
        http_server(http_dispatch, [port(Port)]).

say_hi(_Request) :-
        format('Content-type: text/plain~n~n'),
        format('Hello World!~n').
