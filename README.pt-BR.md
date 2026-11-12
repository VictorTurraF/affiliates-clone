# Papelaria online — demonstração

[English](README.md) | **Português (Brasil)**

Loja local em WordPress e WooCommerce para alimentar uma futura plataforma de afiliados. Público australiano, idioma inglês australiano e moeda AUD. Todas as compras serão simuladas.

## Dia 1: ambiente local

Esta etapa prepara WordPress e MySQL com imagens oficiais. WooCommerce, produtos e pagamentos simulados serão configurados nas próximas etapas. Não é necessário criar um Dockerfile.

Pré-requisitos: Docker Engine ou Docker Desktop em execução, com Docker Compose v2 ou superior.

Na pasta do projeto:

```bash
cp .env.example .env
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

Um commit por dia, com uma entrega verificável. Após validar o ambiente: instalar/configurar WooCommerce, cadastrar o catálogo de demonstração e validar o fluxo de compra. Não conectar um meio de pagamento real no assistente do WooCommerce.

## Referência

[Imagem oficial do WordPress](https://hub.docker.com/_/wordpress)
