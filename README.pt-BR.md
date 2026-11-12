# Papelaria online — demonstração

[English](README.md) | **Português (Brasil)**

Loja local em WordPress e WooCommerce para alimentar uma futura plataforma de afiliados. Público australiano, idioma inglês australiano e moeda AUD. Todas as compras serão simuladas.

## Progresso atual

O Dia 1 entregou uma loja local funcionando: WordPress e WooCommerce, preços em AUD, compra sem cadastro, frete fixo de A$10 e pagamento manual de demonstração. A primeira compra do caderno e a alteração manual para Processing foram confirmadas pelo responsável pelo projeto.

Veja o [registro do Dia 1](docs/day-01/README.pt-BR.md) para configurações, validação e pendências.

## Ambiente local

O Docker Compose prepara WordPress e MySQL com imagens oficiais. Não é necessário criar um Dockerfile. O WooCommerce e as configurações da loja foram definidos manualmente no painel; uma cópia nova do repositório não recria automaticamente esse estado do banco.

Pré-requisitos: Docker Engine ou Docker Desktop em execução, com Docker Compose v2 ou superior.

Na pasta do projeto:

```bash
cp -n .env.example .env
```

Edite `DB_PASSWORD` no arquivo `.env` antes da primeira inicialização. Essa senha é do banco, não do administrador do WordPress. Não envie `.env` ao Git.

```bash
docker compose config --quiet
docker compose up -d
docker compose ps
```

Aguarde o banco ficar saudável e abra http://localhost:8080. No assistente do WordPress, escolha English (Australia), informe um nome provisório para a loja e crie seu administrador. O painel fica em http://localhost:8080/wp-admin/.

A loja fica acessível somente neste computador. Se a porta estiver ocupada, altere `WORDPRESS_PORT` antes da instalação. Alterar a porta depois exige também atualizar as URLs do WordPress.

### Uso diário

```bash
# Iniciar
docker compose up -d

# Consultar logs
docker compose logs --tail=100 wordpress db

# Parar preservando os dados
docker compose down
```

Os volumes preservam banco, imagens, temas e plugins entre reinicializações. Não use `docker compose down -v` para parar normalmente: essa opção apaga os dados da loja. Os volumes não substituem backups e não são versionados pelo Git.

As imagens usam tags móveis (`wordpress:php8.3-apache` e `mysql:8.4`). Após validar a primeira execução, registrar os digests permitirá fixar as versões exatas. Alterar a senha em `.env` depois de inicializar o banco não altera a senha armazenada nele.

## Backup

Com os dois serviços em execução, execute no computador que roda o Docker:

```bash
bash scripts/backup.sh
```

Os backups ficam fora do repositório, em `~/.local/share/affiliates-backups/`, com permissões privadas. O script pausa o WordPress, exporta o MySQL, arquiva os arquivos do WordPress e reinicia o WordPress. Inclui `.env` e `compose.yaml`: os backups contêm credenciais e podem conter dados de clientes. Não envie ao Git nem compartilhe publicamente.

A integridade dos arquivos e as somas de verificação são conferidas automaticamente. Um backup concluído não comprova a restauração: o teste completo de restauração continua pendente. Guarde uma cópia adicional em outro dispositivo. Em caso de falha, o script mantém uma pasta `.incomplete-*` para inspeção e tenta reiniciar o WordPress.

## Escopo acordado

- Cerca de 12 produtos simples de papelaria, sem variações.
- Categorias: cadernos e planners; escrita e marcação; organização.
- Foto, descrição, preço e disponibilidade por produto.
- Produto, carrinho, checkout e confirmação de pedido.
- Compra como visitante, endereços australianos e moeda AUD.
- Frete fixo fictício e pagamento simulado, sem cobrança real.
- Aviso de demonstração visível na loja.
- Administração de produtos e pedidos.
- Cenários de pagamento pendente/aprovado, descontos, cancelamento e reembolso total/parcial.
- Futura integração de afiliados com identificação de pedido e itens e prevenção de comissões duplicadas.

Sem recomendações, busca avançada, categorias complexas ou integrações reais de entrega/pagamento. Regras configuráveis de comissão serão definidas na etapa da plataforma de afiliados.

## Próximas entregas

Um commit por dia, com uma entrega verificável.

- Backup do Dia 1: criado fora do Git em 12 de novembro de 2026; integridade e somas de verificação aprovadas e WordPress reiniciado, conforme saída confirmada pelo responsável pelo projeto. O teste completo de restauração e o commit do dia ainda estão pendentes.
- Proposta para o Dia 2: ampliar o catálogo e testar descontos, cancelamentos e reembolsos.
- Depois: implementar rastreamento de afiliados e comissões configuráveis.

O checkout atual usa um método de pagamento offline identificado como demonstração. Nenhum provedor de pagamento real está conectado. As alterações do painel ficam nos volumes Docker, não no Git.

## Referência

[Imagem oficial do WordPress](https://hub.docker.com/_/wordpress)
