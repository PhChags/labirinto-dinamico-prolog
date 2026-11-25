% main.pl - main do sistema
:- use_module(regras).
:- use_module(busca_astar).
% após implementação:
% :- use_module(busca_bfs).
% :- consult(mapas_autorais).
% :- consult(mapa_externo).
:- consult(mapa_mock).

% resolver(+MapaID, +Algoritmo, -Caminho, -Passos, -NosExpandidos, -TempoMs)
resolver(MapaID, Algoritmo, Caminho, Passos, NosExpandidos, TempoMs) :-
    get_time(T0),
    (   executar_busca(Algoritmo, MapaID, Caminho, Passos, NosExpandidos)
    ->  get_time(T1),
        TempoMs is (T1 - T0) * 1000,
        exibir_resultado(MapaID, Algoritmo, Caminho, Passos, NosExpandidos, TempoMs)
    ;   get_time(T1),
        TempoMs is (T1 - T0) * 1000,
        format('~n=== [~w | ~w] ===~n', [MapaID, Algoritmo]),
        format('Status: SEM SOLUCAO~n'),
        format('Tempo : ~3f ms~n~n', [TempoMs]),
        fail
    ).

% Roteamento entre os algoritmos disponíveis
executar_busca(astar, MapaID, Caminho, Passos, NosExpandidos) :-
    buscar_astar(MapaID, Caminho, Passos, NosExpandidos).

executar_busca(bfs, MapaID, Caminho, Passos, NosExpandidos) :-
    (   current_predicate(buscar_bfs/4)
    ->  buscar_bfs(MapaID, Caminho, Passos, NosExpandidos)
    ;   format('Erro: Modulo busca_bfs ainda nao carregado.~n'),
        fail
    ).

% Impressão formatada das métricas e do trajeto no terminal
exibir_resultado(MapaID, Algoritmo, Caminho, Passos, NosExpandidos, TempoMs) :-
    format('~n=== [~w | ~w] ===~n', [MapaID, Algoritmo]),
    format('Status        : SOLUCAO ENCONTRADA~n'),
    format('Passos        : ~w~n', [Passos]),
    format('Nos Expandidos: ~w~n', [NosExpandidos]),
    format('Tempo         : ~3f ms~n', [TempoMs]),
    format('Trajeto       : ~w~n~n', [Caminho]).