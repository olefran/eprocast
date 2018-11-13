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
%the tasks are your knowledge base.
%the tasks will proporcionate the time required to finish AND a description


%task(Description, Days, Hours, Minutes, Seconds).


task("Jugar con my perro", 0, 0 , 30, 0).
task("Lavar los trastes", 0, 1, 0, 0).
task("Desear a mi familia buenos dias", 0, 0, 0, 50).
task("Bañarme",0, 0, 30, 0).


%tasks are converted into a list.

%time are converted to the number of seconds (for manageability)

timeToSec(Desc,X):-
	task(Desc,D,H,M,S),
	X is D * 3600 * 24 + H * 3600 + M * 60 + S.


%Now, we make a list of all the task lists and we sort it

tasksList(Sorted):-
	findall(X-[Desc], timeToSec(Desc, X), L),
	keysort(L, Sorted).


%Save a task in the file
logItIn(L):-
	open("tasks.txt",append, Stream),
	atom_string(L,Text),
	write(Stream,Text),
	nl(Stream),
	close(Stream).

%task to output format
taskToFormat(Desc,D,H,M,S, Output):-
	task(Desc,D,H,M,S),
	L = [Desc, D, H, M, S],
	atomics_to_string(L,",",Output).


%update the tasks file
logAllIn():-
	open("tasks.txt",write, Stream),
	writeln(Stream,"--------- Tasks -----------"),
	nl(Stream),
	forall(taskToFormat(_,_,_,_,_,Output), writeln(Stream,Output)),
	close(Stream).
