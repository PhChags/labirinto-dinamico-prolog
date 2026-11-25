# Resolução de Labirintos Dinâmicos com Chaves e Portas em Prolog

Trabalho prático da disciplina de Inteligência Artificial do curso de Ciência da Computação da Universidade Federal Fluminense.

## Descrição do Problema
Um agente deve navegar por um labirinto em grade partindo de uma posição inicial até um objetivo. O ambiente contém portas trancadas por cores que exigem a coleta prévia das respectivas chaves espalhadas pelo mapa.

## Estrutura do Projeto
- `main.pl`: Predicados principais para execução das buscas e exibição de métricas.
- `mapas_autorais.pl`: Cenários de teste criados pela equipe.
- `mapa_externo.pl`: Cenário com múltiplas chaves e portas extraído do ambiente `MiniGrid-ObstructedMaze-Full-v0`.
- `extrair_minigrid.py`: Script Python utilizado para extrair e converter o mapa do MiniGrid para fatos Prolog.
- `regras.pl`: Regras de transição de estados, validação de movimentos e inventário.
- `busca_astar.pl`: Implementação do algoritmo A* com heurística de Manhattan.
- `busca_bfs.pl`: Implementação da Busca em Largura (BFS).

## Como Executar
1. Abra o SWI-Prolog na pasta do projeto.
2. Carregue o arquivo principal: `?- [main].`
3. Execute uma consulta de exemplo: `?- resolver(mapa1, astar, Caminho, Passos).`

## Referências e Datasets
- Mapa externo extraído do ambiente **MiniGrid-ObstructedMaze-Full-v0** (`seed=12`), da suíte oficial **MiniGrid** (*Farama Foundation*): [minigrid.farama.org](https://minigrid.farama.org/).