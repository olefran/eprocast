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
%Module for main app


%the tasks are your knowledge base.
%the tasks will proporcionate the time required to finish AND a description

%append to end (from the lecture) (appends the first element to the next one)
append([],List,List).
append([Head|Tail],List2,[Head|Result]):-
    append(Tail,List2,Result).


%quicksort (from the lecture)
pivoting(_,[],[],[]).

pivoting(H,[X|T],[X|L],G):-
	get_dict(time,X,Xt),
	get_dict(time,H,Ht),
	Xt>Ht,pivoting(H,T,L,G).
pivoting(H,[X|T],L,[X|G]):-
	get_dict(time,X,Xt),
	get_dict(time,H,Ht),
	Xt=<Ht,pivoting(H,T,L,G).

quick_sort_time(List,Sorted):-q_sort(List,[],Sorted).
q_sort([],Acc,Acc).
q_sort([H|T],Acc,Sorted):-
	pivoting(H,T,L1,L2),
	q_sort(L1,Acc,Sorted1),q_sort(L2,[H|Sorted1],Sorted).

%task is a dictionary(Description, Days, Hours, Minutes, Seconds).
%the following is a dummy task.
task(act{desc:"",day:0, hour:0, minute:0, second:0}).

%tasks example
%task(act{desc:"Jugar con my perro", day:0, hour:0 , minute:30, second:0}).
%task(act{desc:"Lavar los trastes", day:0, hour:30, minute:0, second:0}).
%task(act{desc:"Desear a mi familia buenos dias", day:0, hour:0, minute:0, second:50}).
%task(act{desc:"Bañarme",day:0, hour:0, minute:30, second:0}).
%task(act{desc:"And another thing!", day:0, hour:0, minute:1, second:0}).



%time are converted to the number of seconds (for manageability)

timeToSec(X,R):-
	task(X),
	get_dict(desc,X,Desc),
	get_dict(day,X,D),
	get_dict(hour,X,H),
	get_dict(minute,X,M),
	get_dict(second,X,S),
	Res is D * 3600 * 24 + H * 3600 + M * 60 + S,
	Res > 0,
	Desc \= "",
	R = X.put([time=Res]).


%tasks are cataloged by id (only use when sorted)
tasksListId([],_,0).


%taskToDict(Desc,D,H,M,S,X,Dict):-
%	timeToSec(Desc,D,H,M,S,X),
%	L = [ desc:Desc, day:D, hour:H, minute:M, time:X ],
%	dict_create(X,Dict,L).

%Now, we make a list of lists of all the tasks

tasksList(Sorted):-
	findall(R,timeToSec(_,R), L),
	quick_sort_time(L,Sorted).


%Save a task in the file
logItIn(L):-
	open("tasks.txt",append, Stream),
	atom_string(L,Text),
	write(Stream,Text),
	nl(Stream),
	close(Stream).

%task to output format
taskToFormat(X):-
	task(X),
	get_dict(desc,X,Desc),
	get_dict(day,X,D),
	get_dict(hour,X,H),
	get_dict(minute,X,M),
	get_dict(second,X,S),
	Res is D + H + M + S,
	Res > 0,
	Desc \= "".

writeIn(Stream,String):-
	write(Stream,String),
	writeln(Stream,'.').

%update the tasks file
logAllIn():-
	open("tasks.txt",write, Stream),
	forall(taskToFormat(X), writeIn(Stream,X)),
	close(Stream).

	read_from_file :-
	    open('tasks.txt', read, Str),
	    read_file(Str,_),
	    close(Str).

	read_file(Stream,[]) :-
	    at_end_of_stream(Stream).

	read_file(Stream,[X|L]) :-
	    \+ at_end_of_stream(Stream),
	    read(Stream,X),
			X \= end_of_file,
			X \= "",
			assertz(task(X)),
	    read_file(Stream,L).

	read_file(Stream,[X|L]) :-
	    \+ at_end_of_stream(Stream),
	    read(Stream,X),
			X = end_of_file;
			X = "",
	    read_file(Stream,L).
