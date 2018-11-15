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


%Modules used on this project
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(st/st_render)). %rla simple template
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_client)).


%PrologGTD initial page (index.html).

:- http_handler(root(.), index, []).


:- http_handler(root('createtask'),create_task, []).
:- http_handler(root('deletetask'),remove_task, []).
:- http_handler(root('createfile'),create_file, []).
:- http_handler(root('readfile'),read_file,[]).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

%start the server in localhost
:- server(8000).

%render main page
index(_Request) :-
        make,
        tasksList(L),
        L = [H|T],
        format('Content-type: text/html~n~n'),
        format('<!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>PrologGTD</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
                <style>
                body {
                    background-color: #e9ebee;
                }

                .card {
                    margin-top: 1em;
                }

                /* IMG displaying */
                .person-card {
                    margin-top: 5em;
                    padding-top: 5em;
                }
                .person-card .card-title{
                    text-align: center;
                }
                .person-card .person-img{
                    width: 12em;
                    position: absolute;
                    top: -7em;
                    left: 50%;
                    margin-left: -7em;
                    border-radius: 100%;
                    overflow: hidden;
                    background-color: white;
                }

                #imgcont {
                  max-width: 750px;
                  padding: 15px;
                }
                #red{
                    color: red;
                }

                ::placeholder {
                    color: blue;
                    opacity: .4; /* Firefox */
                }

                :-ms-input-placeholder { /* Internet Explorer 10-11 */
                   color: rgba(0, 255, 0, 0.4);
                }

                ::-ms-input-placeholder { /* Microsoft Edge */
                   color: rgba(0, 255, 0, 0.4);
                }
                </style>
              </head>
              <body>
                <nav class="navbar navbar-expand-lg navbar-light bg-light">
          <a class="navbar-brand" href="#">PrologGTD</a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
            <div class="navbar-nav">
            </div>
          </div>
        </nav>'),
        current_output(Out),
        st_render_file(index, _{
        title: 'PrologGTD',
        first: H,
        items: T
      }, Out, _{ frontend: semblance, undefined: false }),
      format('</body></html>').

      index(_Request) :-
              make,
              tasksList(L),
              L = [],
              format('Content-type: text/html~n~n'),
              format('<!DOCTYPE html>
              <html lang="en">
                  <head>
                      <meta charset="UTF-8" />
                      <meta name="viewport" content="width=device-width, initial-scale=1">
                      <title>PrologGTD</title>
                      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
                      <style>
                      body {
                          background-color: #e9ebee;
                      }

                      .card {
                          margin-top: 1em;
                      }

                      /* IMG displaying */
                      .person-card {
                          margin-top: 5em;
                          padding-top: 5em;
                      }
                      .person-card .card-title{
                          text-align: center;
                      }
                      .person-card .person-img{
                          width: 12em;
                          position: absolute;
                          top: -7em;
                          left: 50%;
                          margin-left: -7em;
                          border-radius: 100%;
                          overflow: hidden;
                          background-color: white;
                      }

                      #imgcont {
                        max-width: 750px;
                        padding: 15px;
                      }
                      #red{
                          color: red;
                      }

                      ::placeholder {
                          color: blue;
                          opacity: .4; /* Firefox */
                      }

                      :-ms-input-placeholder { /* Internet Explorer 10-11 */
                         color: rgba(0, 255, 0, 0.4);
                      }

                      ::-ms-input-placeholder { /* Microsoft Edge */
                         color: rgba(0, 255, 0, 0.4);
                      }
                      </style>
                    </head>
                    <body>
                      <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <a class="navbar-brand" href="#">PrologGTD</a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
                  <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
                  <div class="navbar-nav">
                  </div>
                </div>
              </nav>'),
              current_output(Out),
              st_render_file(index, _{
              title: 'PrologGTD'
            }, Out, _{ frontend: semblance, undefined: false }),
            format('</body></html>').


:- multifile
        user:head//2.


%knowledge base of parameters
param(desc,[string]).
param(day,[integer]).
param(hour,[integer]).
param(minute,[integer]).
param(second,[integer]).

%create a task
create_task(Request) :-
      http_parameters(Request,
                      [ desc(Desc),
                        day(Day),
                        hour(Hour),
                        minute(Minute),
                        second(Second)
                      ],
                      [ attribute_declarations(param)
                      ]),
        member(method(post), Request), !,
        assertz(task(act{desc:Desc ,day:Day,hour:Hour,minute:Minute,second:Second})),
        index(Request).

remove_task(Request) :-
      http_parameters(Request,
                      [ desc(Desc),
                        day(Day),
                        hour(Hour),
                        minute(Minute),
                        second(Second)
                      ],
                      [ attribute_declarations(param)
                      ]),
        member(method(post), Request), !,
        retract(task(act{desc:Desc ,day:Day,hour:Hour,minute:Minute,second:Second})),
        index(Request).

create_file(_) :-
      logAllIn,
      format('Content-type: text/html~n~n'),
      format('<!DOCTYPE html>
<html>
<head>
 <!-- HTML meta refresh URL redirection -->
 <meta http-equiv="refresh"
 content="3; url=/">
</head>
<body>
<h5>Written succeeded</h5><br><p>Check your tasks.txt</p><br><p>Wait 3 seconds or...<a href="/">ok , take me back!</a></p>
</body>
</html>').


read_file(Request) :-
    read_from_file,
    index(Request).
