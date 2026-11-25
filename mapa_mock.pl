% mapa_mock.pl - mapa temporário validação local de regras.pl e busca_astar.pl

dimensao(mapa_mock, 4, 4).
inicio(mapa_mock, 1, 1).
objetivo(mapa_mock, 4, 3).

parede(mapa_mock, 3, 1).
parede(mapa_mock, 3, 2).
parede(mapa_mock, 3, 4).

chave(mapa_mock, 1, 3, roxa).
porta(mapa_mock, 3, 3, roxa).

%   visualmente esse mapa é assim:
%   Y\X | 1 | 2 | 3 | 4 |
%   ----+---+---+---+---+
%    1  | I | . | # | . |
%    2  | . | . | # | . |
%    3  | C | . | P | O |
%    4  | . | . | # | . |