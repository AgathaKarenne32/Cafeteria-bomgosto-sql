# ☕ Cafeteria BomGosto - Sistema de Comandas (SQL)

Este repositório contém um projeto de banco de dados SQL para gerenciar as vendas de café da Cafeteria BomGosto. O projeto abrange desde a modelagem do banco de dados e criação das tabelas até a elaboração de consultas para extrair informações de negócio relevantes.

Todo o ambiente de desenvolvimento foi configurado para ser executado de forma isolada e portável usando Docker e GitHub Codespaces.

## 📜 Escopo do Projeto

O sistema foi projetado para responder às seguintes questões de negócio:

  * Visualização do cardápio completo, ordenado por nome.
  * Detalhamento de todas as comandas, incluindo os itens consumidos e o valor total por item.
  * Cálculo do valor total de cada comanda.
  * Identificação de comandas com múltiplos tipos de café, para análise de consumo.
  * Relatório de faturamento diário para acompanhamento financeiro.

## ⚙️ Tecnologias Utilizadas

  * **Linguagem:** `SQL (MySQL 8.0)`
  * **Ambiente de Contêiner:** `Docker` / `Docker Compose`
  * **Ambiente de Nuvem:** `GitHub Codespaces`
  * **Controle de Versão:** `Git` & `GitHub`
  * **Editor de Código:** `Visual Studio Code`
  * **Ferramenta de BD:** `Extensão SQLTools`

## 🚀 Como Executar o Projeto

Existem duas maneiras fáceis de configurar e executar este projeto.

### Opção 1: Usando GitHub Codespaces (Recomendado)

Este repositório está configurado com um **Dev Container**, o que torna a execução na nuvem extremamente simples e rápida.

1.  Clique no botão verde **`< > Code`** no topo desta página.
2.  Vá para a aba **"Codespaces"**.
3.  Clique em **"Create codespace on main"**.

O GitHub irá preparar automaticamente um ambiente completo com VS Code, terminal, Docker, e o banco de dados MySQL já rodando. As extensões necessárias do VS Code também serão instaladas.

  * **Para se conectar ao banco no SQLTools (dentro do Codespace):**
      * **Server Address:** `db`
      * **Username:** `root`
      * **Password:** `sua_senha_forte` (a que está no arquivo `.devcontainer/docker-compose.yml`)

### Opção 2: Ambiente Local com Docker

Se preferir rodar na sua própria máquina, você precisará ter os seguintes pré-requisitos:

  * [Git](https://git-scm.com/)
  * [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  * [Visual Studio Code](https://code.visualstudio.com/) com a extensão [SQLTools](https://www.google.com/search?q=https://marketplace.visualstudio.com/items%3FitemName%3DMTeixeira.sqltools) instalada.

**Passos:**

1.  Clone o repositório:
    ```bash
    git clone https://github.com/AgathaKarenne32/Cafeteria-bomgosto-sql.git
    cd Cafeteria-bomgosto-sql
    ```
2.  Inicie o contêiner do banco de dados com Docker Compose:
    ```bash
    docker-compose up -d
    ```
3.  Abra a pasta no VS Code e conecte-se ao banco de dados usando o SQLTools.
      * **Para se conectar ao banco no SQLTools (localmente):**
          * **Server Address:** `localhost`
          * **Username:** `root`
          * **Password:** `sua_senha_forte` (a que está no arquivo `docker-compose.yml`)

## 🗃️ Estrutura do Banco de Dados

O banco de dados é composto por três tabelas principais:

  * **`Cardapio`**: Armazena as informações de cada café oferecido.
      * `id_cardapio` (PK), `nome` (UNIQUE), `descricao`, `preco_unitario`
  * **`Comanda`**: Registra cada pedido feito por um cliente.
      * `id_comanda` (PK), `data`, `numero_mesa`, `nome_cliente`
  * **`ItensComanda`**: Tabela de junção que detalha quais cafés e em que quantidade foram pedidos em cada comanda.
      * `id_comanda` (FK), `id_cardapio` (FK), `quantidade`

## 📝 Scripts SQL do Projeto

O arquivo `script_cafeteria.sql` contém todos os scripts. Primeiro, os de criação (DDL) e inserção de dados (DML), seguidos pelas consultas que resolvem as questões de negócio.

#### 1\) Listagem do cardápio ordenada por nome

```sql
SELECT nome, descricao, preco_unitario FROM Cardapio ORDER BY nome ASC;
```

#### 2\) Detalhamento completo das comandas e seus itens

```sql
SELECT c.id_comanda, c.data, c.nome_cliente, card.nome AS nome_cafe, ic.quantidade, card.preco_unitario, (ic.quantidade * card.preco_unitario) AS preco_total_item FROM Comanda c JOIN ItensComanda ic ON c.id_comanda = ic.id_comanda JOIN Cardapio card ON ic.id_cardapio = card.id_cardapio ORDER BY c.data, c.id_comanda, nome_cafe;
```

#### 3\) Valor total por comanda

```sql
SELECT c.id_comanda, c.data, c.nome_cliente, SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda FROM Comanda c JOIN ItensComanda ic ON c.id_comanda = ic.id_comanda JOIN Cardapio card ON ic.id_cardapio = card.id_cardapio GROUP BY c.id_comanda ORDER BY c.data;
```

#### 4\) Comandas com mais de um tipo de café

```sql
SELECT c.id_comanda, c.data, c.nome_cliente, SUM(ic.quantidade * card.preco_unitario) AS valor_total_comanda FROM Comanda c JOIN ItensComanda ic ON c.id_comanda = ic.id_comanda JOIN Cardapio card ON ic.id_cardapio = card.id_cardapio GROUP BY c.id_comanda HAVING COUNT(ic.id_cardapio) > 1 ORDER BY c.data;
```

#### 5\) Faturamento total por data

```sql
SELECT c.data, SUM(ic.quantidade * card.preco_unitario) AS faturamento_total_dia FROM Comanda c JOIN ItensComanda ic ON c.id_comanda = ic.id_comanda JOIN Cardapio card ON ic.id_cardapio = card.id_cardapio GROUP BY c.data ORDER BY c.data;
```

## 👩‍💻 Autor

  * **Agatha Karenne**
  * **GitHub:** [AgathaKarenne32](https://www.google.com/search?q=https://github.com/AgathaKarenne32)