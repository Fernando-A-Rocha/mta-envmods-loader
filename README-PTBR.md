# mta-envmods-loader
Resource para carregar env-mods no seu servidor MTA

Criado para facilitar a implementação de mods feitos para GTA:SA Singleplayer ou SA-MP (substituem diretamente DFF/TXD do jogo)

Abaixo: Documentação // Leia-me ou morra

## Atenção

De momento só está implementado "replacement mods" (mods de substituição) de modelos (DFF+COL) e texturas (TXD)

No futuro vou permitir **adicionar** objetos ao jogo que poderão ser spawnados via coordenadas pré-definidas

Use [esta ferramenta](https://github.com/Fernando-A-Rocha/mta-ide-search) para encontrar ID/DFF/TXD dos modelos do jogo facilmente (necessário para declarar os env-mods)

Se não souber criar ficheiro COL para um modelo com o 3DS Max, pode usar [esta ferramenta](https://github.com/Fernando-A-Rocha/mta-samp-maploader/blob/main/TUTORIAL_COL.md) para gerenciar um COL a partir dum DFF

**Este recurso não está finalizado.** Com o funcionamento atual qualquer player pode ainda roubar os ficheiros após serem baixados. O ideal será no futuro carregar ficheiros encriptados (decriptados no momento)

## Como usar

- Declarar os replacement mods em [rmods.lua](/envmods-loader/rmods.lua)
- Os mods têm que ser definidos dentro de um projeto que você dá um nome, etc (siga as intruções no ficheiro)
- Existem 2 tipos de replacement mods:
	- Substituição de DFF (+ COL opcional)
	- Substituição de TXD
- Cada mod tem que ter lista de IDs para aplicar a substituição
- Os mods TXD têm que ser declarados antes de todos os mods DFF por motivos de script
- Observe [o exemplo](/example.png) presente no ficheiro

## Como funciona

- Ao lançar o resource o cliente vai verificar se todos os mods são válidos (se não estiverem enviará uma mensagem de erro para o debugscript 3)
- Após as verificações iniciais, todos os mods são baixados e de seguida carregados (verá mensagem(s) de erro se algo falhar)
- Este processo é rápido, você verá o tempo que demorou no chat (pode desativar isto)