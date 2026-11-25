% regras.pl - transição de estados e regras do labirinto
:- module(regras, [estado_inicial/2, estado_objetivo/2, proximo_estado/5]).

%estado inicial e objetivo do agente
estado_inicial(MapaID, estado(X, Y, [])) :-
    user:inicio(MapaID, X, Y).

estado_objetivo(MapaID, estado(X, Y, _)) :-
    user:objetivo(MapaID, X, Y).

% movimentações do agente
direcao(norte, 0, -1).
direcao(sul, 0, 1).
direcao(leste, 1, 0).
direcao(oeste, -1, 0).

% proximo_estado(+MapaID, +EstadoAtual, -Acao, -ProximoEstado, -Custo)
% gera todas as transições válidas a partir do estado atual com custo unitário 1
proximo_estado(MapaID, estado(X, Y, Chaves), Direcao, estado(NX, NY, NovasChaves), 1) :-
    direcao(Direcao, DX, DY),
    NX is X + DX,
    NY is Y + DY,
    dentro_dos_limites(MapaID, NX, NY),
    \+ user:parede(MapaID, NX, NY),
    pode_atravessar_porta(MapaID, NX, NY, Chaves),
    atualizar_inventario(MapaID, NX, NY, Chaves, NovasChaves).

% verifica se a nova posição é válida 
dentro_dos_limites(MapaID, X, Y) :-
    user:dimensao(MapaID, Largura, Altura),
    X >= 1, X =< Largura,
    Y >= 1, Y =< Altura.

% verifica se é possível abrir a porta em frente ao agente
pode_atravessar_porta(MapaID, X, Y, Chaves) :-
    ( user:porta(MapaID, X, Y, Cor) -> member(Cor, Chaves); true ).

% coleta chaves
atualizar_inventario(MapaID, X, Y, Chaves, NovasChaves) :-
    ( user:chave(MapaID, X, Y, Cor) -> sort([Cor | Chaves], NovasChaves); NovasChaves = Chaves ).
