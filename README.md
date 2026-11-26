# Resolução de Labirintos Dinâmicos com Chaves e Portas em Prolog

Trabalho prático da disciplina de Inteligência Artificial do curso de Ciência da Computação da Universidade Federal Fluminense.

**Integrantes:** Pedro Henrique Chagas Pereira e Daniel Proença Molina
<!-- **Relatório:** [link do PDF no repositório, quando pronto] -->

## Descrição do Problema
Um agente deve navegar por um labirinto em grade, partindo de uma posição inicial até um objetivo. O ambiente contém portas trancadas por cores, que exigem a coleta prévia das chaves correspondentes, espalhadas pelo mapa. Como a acessibilidade de certas regiões depende do histórico de coleta, o problema é de busca em um espaço de estados que inclui o inventário do agente.

## Representação em Prolog
Todos os mapas seguem a mesma assinatura de fatos:

```prolog
dimensao(MapaID, Largura, Altura).
inicio(MapaID, X, Y).
objetivo(MapaID, X, Y).
parede(MapaID, X, Y).
chave(MapaID, X, Y, Cor).
porta(MapaID, X, Y, Cor).
```

- **Coordenadas:** começam em 1 (de 1 a `Largura` e de 1 a `Altura`). X cresce para leste e Y cresce para o sul (norte = Y-1).
- **Estado:** `estado(X, Y, ChavesColetadas)`, em que `ChavesColetadas` é uma lista ordenada e sem repetição de cores (ex.: `[amarela, roxa]`), o que evita estados duplicados.
- **Movimentação:** 4 direções (norte, sul, leste, oeste), com custo 1 por passo. Não é possível entrar em paredes nem sair da grade.
- **Chaves e portas:** a chave é coletada automaticamente ao pisar na célula e não é consumida ao abrir portas. Uma porta só pode ser atravessada se sua cor estiver em `ChavesColetadas`.

## Algoritmos de Busca
- **BFS (busca em largura):** não informada; expande os estados por nível e encontra o caminho com menos passos.
- **A\*:** informada; usa f = g + h, em que g é o número de passos até o estado e h é a heurística: o menor valor, entre as chaves ainda não coletadas, de (distância de Manhattan do agente até a chave + distância de Manhattan da chave até o objetivo). Se não há chaves pendentes, h é a distância de Manhattan até o objetivo.

As duas implementações usam as mesmas regras de transição (`regras.pl`), o que permite comparar passos, nós expandidos e tempo. Ambas mantêm uma lista de estados já expandidos para evitar ciclos.

## Estrutura do Projeto
- `main.pl`: predicado principal `resolver/6`, que roteia a busca, mede o tempo e exibe as métricas.
- `mapas_autorais.pl`: cenários criados pela equipe (`mapa1_facil`, `mapa2_intermediario`, `mapa3_impossivel`).
- `mapa_externo.pl`: cenário com múltiplas chaves e portas extraído do `MiniGrid-ObstructedMaze-Full-v0` (`seed=12`).
- `extrair_minigrid.py`: script que extrai o mapa do MiniGrid e o converte para fatos Prolog (só é necessário para gerar o `mapa_externo.pl`).
- `regras.pl`: transição de estados, validação de movimentos, portas e inventário.
- `busca_astar.pl`: algoritmo A* (`buscar_astar/4`).
- `busca_bfs.pl`: busca em largura (`buscar_bfs/4`).

Os predicados de busca seguem a assinatura `(+MapaID, -Caminho, -Passos, -NosExpandidos)`.

## Requisitos
- **SWI-Prolog** 9 ou superior (testado na versão `11.0.1`)
- **Apenas para `extrair_minigrid.py`:** Python `3.11+` (testado na `3.11.4`), `minigrid` `3.2.0` e `gymnasium` `1.4.0`

## Como Executar
1. Abra o SWI-Prolog na pasta do projeto.
2. Carregue o arquivo principal:
   ```prolog
   ?- [main].
   ```
3. Execute uma consulta com `resolver(+MapaID, +Algoritmo, -Caminho, -Passos, -NosExpandidos, -TempoMs)`. Os algoritmos aceitos são `astar` e `bfs`. Mapas disponíveis: `mapa1_facil`, `mapa2_intermediario`, `mapa3_impossivel` e [nome do mapa externo] <!-- colocar o nome dado ao mapa externo depois -->.
   ```prolog
   ?- resolver(mapa1_facil, astar, Caminho, Passos, NosExpandidos, TempoMs).
   ?- resolver(mapa1_facil, bfs, Caminho, Passos, NosExpandidos, TempoMs).
   ```

## Exemplo de Saída
O `resolver` imprime o status, os passos, os nós expandidos, o tempo em ms e o trajeto, que é a lista de estados `estado(X, Y, Chaves)` do início ao objetivo:

```text
[colar aqui a saída real do terminal] 
```

Para o mapa sem solução (`mapa3_impossivel`), o `resolver` imprime `Status: SEM SOLUCAO` com o tempo gasto e depois falha, então o terminal mostra a mensagem seguida de `false.`:

```text
[colar aqui a saída real do terminal]
```

## Referências
- CHEVALIER-BOISVERT, Maxime *et al*. **Minigrid & Miniworld**: modular & customizable reinforcement learning environments for goal-oriented tasks. arXiv, 2023. https://arxiv.org/abs/2306.13831
- Documentação do MiniGrid (Farama Foundation): https://minigrid.farama.org/
- Mapa externo: ambiente `MiniGrid-ObstructedMaze-Full-v0` (`seed=12`).
- SWI-Prolog: https://www.swi-prolog.org/
