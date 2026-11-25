% busca_astar - A* com heurística manhattan adaptada a chaves
:- module(busca_astar, [buscar_astar/4]).

:- use_module(regras).

% buscar_astar(+MapaID, -Caminho, -Passos, -NosExpandidos)
buscar_astar(MapaID, Caminho, Passos, NosExpandidos) :-
    estado_inicial(MapaID, EstadoIni),
    heuristica(MapaID, EstadoIni, H0),
    NoInicial = no(H0, 0, EstadoIni, [EstadoIni]),
    astar_loop(MapaID, [NoInicial], [], 0, CaminhoReverso, Passos, NosExpandidos),
    reverse(CaminhoReverso, Caminho).

% caso base: fronteira vazia (mapa sem solução; fallha limpa)
astar_loop(_, [], _, _, _, _, _) :- !, fail.

% caso base: primeiro nó da fila (menor F) atingiu o objetivo
astar_loop(MapaID, [no(_, G, EstadoAtual, Caminho) | _], _, NosAcc, Caminho, G, NosExpandidos) :-
    estado_objetivo(MapaID, EstadoAtual), !,
    NosExpandidos is NosAcc + 1.

% caso em que o estado atual já foi expandido anteriormente (descarta e continua)
astar_loop(MapaID, [no(_, _, EstadoAtual, _) | RestoFronteira], Visitados, NosAcc, Caminho, Passos, NosExpandidos) :-
    memberchk(EstadoAtual, Visitados), !,
    astar_loop(MapaID, RestoFronteira, Visitados, NosAcc, Caminho, Passos, NosExpandidos).

% caso recurssivo: expande vizinhos, calcula F = G + H e insere na fronteira ordenada
astar_loop(MapaID, [no(_, G, EstadoAtual, Caminho) | RestoFronteira], Visitados, NosAcc, CaminhoFinal, Passos, NosExpandidos) :-
    NovoNosAcc is NosAcc + 1,
    NovosVisitados = [EstadoAtual | Visitados],
    findall(
        no(NovoF, NovoG, ProxEstado, [ProxEstado | Caminho]),
        (
            proximo_estado(MapaID, EstadoAtual, _, ProxEstado, CustoPasso),
            \+ memberchk(ProxEstado, NovosVisitados),
            NovoG is G + CustoPasso,
            heuristica(MapaID, ProxEstado, H),
            NovoF is NovoG + H
        ),
        Sucessores
    ),
    append(RestoFronteira, Sucessores, FronteiraNaoOrdenada),
    msort(FronteiraNaoOrdenada, NovaFronteira),
    astar_loop(MapaID, NovaFronteira, NovosVisitados, NovoNosAcc, CaminhoFinal, Passos, NosExpandidos).

% heurística
heuristica(MapaID, estado(X, Y, ChavesColetadas), H) :-
    user:objetivo(MapaID, ObjX, ObjY),
    findall(
        DistTotal,
        (
            chave(MapaID, CX, CY, Cor),
            \+ memberchk(Cor, ChavesColetadas),
            manhattan(X, Y, CX, CY, D1),
            manhattan(CX, CY, ObjX, ObjY, D2),
            DistTotal is D1 + D2
        ),
        DistanciasChaves
    ),
    ( DistanciasChaves \= [] -> min_list(DistanciasChaves, H) ; manhattan(X, Y, ObjX, ObjY, H) ).

manhattan(X1, Y1, X2, Y2, Dist) :-
    Dist is abs(X1 - X2) + abs(Y1 - Y2).