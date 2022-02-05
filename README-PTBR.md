# mta-envmods-loader
Resource para carregar env-mods no seu servidor MTA

Criado para facilitar a implementação de mods feitos para GTA:SA Singleplayer ou SA-MP (substituem diretamente DFF/TXD do jogo)

Abaixo: Documentação // Leia-me ou morra

## Atenção

De momento só está implementado "replacement mods" AKA mods de substituição de modelos e texturas

No futuro vou permitir **adicionar** objetos ao jogo que poderão ser spawnados via coordenadas pré-definidas

Use [esta ferramenta](https://github.com/Fernando-A-Rocha/mta-ide-search) para encontrar ID/DFF/TXD dos modelos do jogo facilmente (necessário para declarar os env-mods)

## Como usar

- Declarar os replacement mods em [rmods.lua](/envmods-loader/rmods.lua)
- Os mods têm que ser definidos dentro de um projeto que você dá um nome, etc (siga as intruções no ficheiro)
- Existem 2 tipos de replacement mods:
	- Substituição de DFF (+ COL opcional)
	- Substituição de TXD
- Cada mod tem que ter lista de IDs para aplicar a substituição
- Os mods TXD têm que ser declarados antes de todos os mods DFF por motivos de script
- Observe o exemplo presente no ficheiro