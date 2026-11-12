# Dia 1 — loja local e primeiro pedido de demonstração

[English](README.md) | **Português (Brasil)** | [README do projeto](../../README.pt-BR.md)

Data: 12 de novembro de 2026 (Australia/Perth).

## Resultado

O responsável pelo projeto concluiu uma compra como visitante na loja WooCommerce local e alterou manualmente o pedido de On hold para Processing. Não houve cobrança nem contratação de entrega. Isso demonstra manualmente o ciclo do pedido; não é um teste de gateway de pagamento ou de comissões de afiliados.

## Ambiente

- WordPress (`wordpress:php8.3-apache`) e MySQL (`mysql:8.4`) executados pelo Docker Compose.
- Acesso à loja limitado a `127.0.0.1:8080` por padrão.
- Volumes nomeados `wordpress_data` e `db_data` preservam arquivos e banco de dados.
- `.env` contém a senha local do banco e está excluído do Git.
- WooCommerce instalado e ativado manualmente no painel do WordPress.
- Volumes Docker existentes mantidos; nenhuma migração Btrfs ou rotina de snapshots foi implementada.

## Configurações do painel

| Configuração | Estado no Dia 1 |
| --- | --- |
| Idioma | English (Australia) |
| País/estado | Australia — Western Australia |
| Endereço da loja | Endereço de demonstração em Perth, código postal 6000 |
| Moeda | AUD, símbolo à esquerda, duas casas decimais |
| Formato numérico | Vírgula para milhares e ponto decimal |
| Locais de venda | Somente Austrália |
| Locais de entrega | Países nos quais a loja vende |
| Localização padrão do cliente | País/região da loja |
| Impostos | Desativados nesta demonstração |
| Cupons | Ativados; ainda não testados |
| Contas | Compra como visitante habilitada; criação de conta no checkout desabilitada |
| Zona de entrega | Australia |
| Método de entrega | Taxa fixa: `Standard delivery — Demo`, A$10 por pedido, imposto None |
| Método de pagamento | Cheque/check payments offline, renomeado para `Demo payment — no charge` |
| Visibilidade | Live, permitindo visitantes sem login no localhost |

Descrição do pagamento: “This is a demonstration store. No payment will be collected and no products will be shipped.”

Instruções do pagamento: “Your demo order has been received. No payment is required.”

A visibilidade Live não expõe à internet esta configuração Docker limitada ao localhost. O aviso de demonstração está configurado no método de pagamento; um aviso separado em toda a loja ainda está pendente.

## Produto e imagens

O primeiro produto é `A5 Everyday Notebook`, um produto físico simples de A$12,90, com SKU `PAPER-001`, estado In stock e categoria `Notebooks & Planners`.

- [Imagem do caderno](../../assets/products/a5-notebook.png): gerada e enviada ao produto.
- [Imagem dos marca-textos pastel](../../assets/products/pastel-highlighters.png): gerada para um produto futuro; o cadastro desse produto ainda não foi confirmado.
- [Prompts das imagens](../../assets/products/prompts.md).

## Validação manual

O responsável pelo projeto confirmou a execução das seguintes etapas no navegador:

1. Acessou a loja em janela anônima após desativar o modo Coming soon.
2. Adicionou um caderno e concluiu a compra sem cadastro com o pagamento de demonstração.
3. Conferiu o pedido: A$12,90 do produto + A$10,00 de frete = A$22,90.
4. Abriu o pedido no painel e alterou On hold para Processing.

Este registro documenta a confirmação do responsável; não é um relatório de testes automatizados. Dados do comprador, credenciais e identificadores de pedidos foram omitidos.

## Resultado do backup

O responsável executou `bash scripts/backup.sh` e compartilhou a saída de sucesso. O backup `20261112T084625Z-QoxOU2jO` foi criado em `~/.local/share/affiliates-backups/`, fora do Git. A exportação do banco e o arquivo do WordPress passaram nas verificações de integridade e somas de verificação, e o container do WordPress reiniciou. O acesso pelo navegador após a reinicialização e a restauração completa ainda não foram verificados.

O backup inclui credenciais e possivelmente dados de clientes. Mantenha-o privado; uma cópia em outro dispositivo ainda não foi confirmada.

## Pendências

- Testar a restauração completa do backup criado em um ambiente isolado.
- Verificar o repositório Git e criar o commit do Dia 1; nenhum commit está registrado aqui como concluído.
- Adicionar um aviso de demonstração em toda a loja.
- Ampliar o catálogo para os 12 produtos e três categorias planejados.
- Testar cupons, múltiplas quantidades/itens, cancelamentos e reembolsos totais/parciais.
- Fixar os digests das imagens validadas e tornar reproduzível a configuração do painel.
- Implementar atribuição de afiliados e regras de comissão em uma etapa futura.

O repositório contém configuração do ambiente, documentação e imagens. Ele não contém o banco da loja em execução, os plugins instalados nem o volume de mídias enviadas. Uma instalação nova exige configuração manual ou restauração de um backup verificado.
