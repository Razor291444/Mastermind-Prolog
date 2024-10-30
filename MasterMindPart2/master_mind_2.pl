% TP feuille 5 - Mastermind en Prolog

% Question 1
/* La version proposée ici permet de réduire la complexité temporelle de calcul 
 * (on parle de green cut - l'algorithme se termine une fois qu'une solution est trouvée).*/

% Création du générateur
% Question 2
% version 1 - almost same with the range predicate in the course
listeCouleurs(Min, Min, [Min]).
listeCouleurs(Min, Max, L):-
    Min < Max,
    Min2 is Min + 1,
    listeCouleurs(Min2, Max, Ltmp),
    L=[Min|Ltmp].

% Question 3
gen(_, 0, []).
gen(M, N, L):-
    N > 0,
    M > 0,
    N2 is N - 1,
    gen(M, N2, Ctmp),
    listeCouleurs(1, M, Lc),
    member(Z, Lc),
    L = [Z|Ctmp].

% Question 4 - création du test principal