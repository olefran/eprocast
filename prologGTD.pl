/**
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, version 3.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

%prologGTD


%Use sorting functions
:- ensure_loaded(sortbytime).


%Modules used on this project (all given by prolgo)
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(st/st_render)).

%start the server in localhost
:- server(8000).

%PrologGTD initial page (index.html).
:- http_handler(root(.), index, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

index(_Request) :-
        current_output(Out),
        st_render_file(index, _{
        title: 'Hello',
        items: [
        _{ title: 'Item 1', content: 'Abc 1' },
        _{ title: 'Item 1', content: 'Abc 2' }
        ]
      }, Out, _{ frontend: semblance, undefined: false }).
