% TP4 Mastermind
% Question 1
% Prédicat BienPlace
nBienPlace([], [], 0).
nBienPlace([X|Xr], [X|Yr], BP):- 
    nBienPlace(Xr, Yr, BPr), 
    BP is BPr+1.
nBienPlace([_|Xr], [_|Yr], BP):- 
    nBienPlace(Xr, Yr, BP).

% Prédicat longueur
longueur([], 0).
longueur([_|Y], Lg):- 
    longueur(Y, Lgn), 
    Lg is Lgn+1.

% Prédicat Gagne
gagne(X, Y):- 
    longueur(X, Lgx), 
    nBienPlace(X, Y, Lgy), 
    Lgx=:=Lgy.


% Question 2
% Prédicat élément
element(X, [X|_]).
element(X, [_|Y]):- element(X, Y).

% Prédicat enleve
enleve(_, [], []).
enleve(X, [X|Y], Y).
enleve(Y, [X|L], Z):- 
    enleve(Y, L, Zb), 
    Z=[X|Zb].

% Prédicat enleveBP
enleveBP([], [], [], []).
enleveBP([], C1, [], C1).
enleveBP(C1, [], C1, []).
enleveBP([X|Xr], [Y|Yr], Code1, Code2):- 
    enleveBP(Xr, Yr, Code1Bis, Code2Bis), 
    Code1=[X|Code1Bis], 
    Code2=[Y|Code2Bis],
    X =\= Y.
enleveBP([X|Xr], [X|Yr], Code1Bis, Code2Bis):- enleveBP(Xr, Yr, Code1Bis, Code2Bis).

% 2.4
% nMalPlaces : 
%   - enleveBP
%   - appelle NmalPlaceAux
nMalPlaces(L1, L2, N) :-
    enleveBP(L1, L2, L1_temp, L2_temp),
    nMalPlacesAux(L1_temp, L2_temp, N).


% nMalPlacesAux :
%   - itére liste 1
%   - si élément courant est dans liste 2 [element]
%       - enleve élément courant de liste 2 [enleve]
%   - appel récursif sur liste 1 (cdr) et 2 (ayant l'élément enlever) [NmalPlaceAux]

nMalPlacesAux([],_ , 0).
nMalPlacesAux([T|Q], L2, N) :-
    element(T, L2),
    enleve(T, L2, L2_temp),
    nMalPlacesAux(Q, L2_temp, N_temp),
    N is N_temp + 1.

nMalPlacesAux([T|Q], L2, N) :-
    \+ element(T, L2),
    nMalPlacesAux(Q, L2, N).



% Ecriture d'un codeur
% Question 3
codeur(_, 0, []).
codeur(M, N, [X|Code]) :-
    N > 0,
    N1 is N-1,
    Mtemp is M+1,
    codeur(M, N1, Code),
    random(1, Mtemp, X).

% Question 4
jouons(M, N, Max) :-
    codeur(M, N, Secret),
    write("\nC est parti !\n"),
    write("Il reste "),
    write(Max),
    write(" coup(s).\nDonner un code : "),
    read(Code),
    jouer(Max, Secret, Code, 0).
jouer(0, Secret, _, Nb_coups) :-
    write("Perdu !\nLe code etait : "),
    write(Secret),
    write("\nTu as joue "),
    write(Nb_coups),
    write(" coups.\nVas-y, le prochain tour sera le bon !").
jouer(Essais, Secret, Code, Nb_coups) :-
    \+ gagne(Code, Secret),
    nBienPlace(Code, Secret, BienPlace),
    nMalPlaces(Code, Secret, MalPlace),
    write("BP : "),
    write(BienPlace),
    write(" / MP : "),
    write(MalPlace),
    write("\n"),
    Essais1 is Essais - 1,
    Nb_coups1 is Nb_coups + 1,
    Essais1 > 0,
    write("\n--------\nIl reste "),
    write(Essais1),
    write(" coup(s).\nDonner un code : "),
    read(Code1),
    jouer(Essais1, Secret, Code1, Nb_coups1).
jouer(Essais, Secret, Code, Nb_coups) :-
    \+ gagne(Code, Secret),
    nBienPlace(Code, Secret, BienPlace),
    nMalPlaces(Code, Secret, MalPlace),
    write("BP : "),
    write(BienPlace),
    write(" / MP : "),
    write(MalPlace),
    write("\n"),
    Essais1 is Essais - 1,
    Nb_coups1 is Nb_coups + 1,
    Essais1 = 0,
    jouer(0, Secret, Code, Nb_coups1).
jouer(_, Secret, Code, Nb_coups) :-
    gagne(Code, Secret),
    write("Gagne !\nTu as trouve en "),
    write(Nb_coups),
    write(" coups !\nBravo champion !\n").