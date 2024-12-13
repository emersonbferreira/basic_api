# Exercício de Backend 

Nesse exercício, vamos criar uma aplicação Phoenix e implementar algumas funcionalidades nela. A aplicação Phoenix é uma API

## Expectativas

- Deve ser código pronto para produção
  - O código nos mostrará como você entrega coisas para produção e será um reflexo do seu trabalho.
  - Apenas para ser bem claro: Não esperamos que você realmente o implante em algum lugar ou faça um release. Esta é uma declaração sobre a qualidade da solução.

## O que você vai construir

Um aplicativo Phoenix com 2 endpoints para gerenciar câmeras.

Não esperamos que você implemente autenticação e autorização, mas sua solução final deve assumir que será implantada em produção e que os dados serão consumidos por uma Single Page Application que roda nos navegadores dos clientes.

## Requisitos

- Devemos armazenar usuários e câmeras em um banco de dados PostgreSQL.
- Cada usuário tem um nome e pode ter múltiplas câmeras.
- Cada câmeras deve ter uma marca.
- Todos os campos acima definidos devem ser obrigatórios.
- Cada usuário deve ter pelo menos 1 câmera ativa em um dado momento.
- Todos os endpoints devem retornar JSON.
- Um arquivo readme com instruções sobre como executar o aplicativo.

### Semeando o banco de dados

- mix ecto.setup deve criar tabelas no banco de dados e preenchê-lo com 1 mil usuários; para cada usuário, devem ser criadas 50 câmeras com nomes/marcas aleatórias.
- O status de cada câmera também deve ser aleatório, permitindo usuários com apenas 1 câmera ativa e usuários com mútiplas câmeras ativas.
- Deve-se usar 4 ou mais marcas diferentes, sendo ao menos estas: Intelbras, Hikvision, Giga e Vivotek.
- O nome dos usuários pode ser aleatório.
- Suponha que os engenheiros precisem semear seus bancos de dados regularmente, então o desempenho do script de seed é importante.

### Tarefas

1. Implementar um endpoint para fornecer uma lista de usuários e suas câmeras
   - Cada usuário deve retornar seu nome e suas câmeras ativas.
   - Alguns usuários podem ter sido desligados (a funcionalidade de desligamento deve ser considerada fora do escopo deste exercício), então só nesse caso é possível que todas as câmeras pertencentes a um usuário estejam inativas. Nestes casos, o endpoint deve retornar a data em que o usuário foi desligado.
   - Este endpoint deve suportar filtragem por parte do nome da câmera e ordenação pelo nome da camera.
   - Endpoint: GET /cameras

2. Implementar um endpoint que envia um e-mail para cada usuário com uma câmera da marca Hikvision;
   - ⚠️ O app não precisa enviar email de fato, então você não precisa necessariamente de acesso à internet para trabalhar no seu desafio.
   - Você pode usar o modo "dev/mailbox" que já vem no phoenix.
   - Endpoint: POST /notify-users

---

## Iniciando o projeto

   - Basta clonar esse repositório e executar o comando `docker compose up --build`
      - O comando `docker compose up --build` vai construir o projeto e subir os containers necessários para o funcionamento do projeto.
      - O build irá rodar a `seed` que irá popular o banco de dados automaticamente.
      - A aplicação será construída usando o `Dockerfile` e `docker-compose.yml` presente no diretório do projeto.
      - Os containers necessários para o funcionamento do projeto são o container do banco de dados PostgreSQL e o container do servidor Phoenix.
   - Após subir os containers, você pode acessar a aplicação pela url `http://localhost:4000`
   - É usada autenticação JWT para autenticar os usuários e acessar rotas privadas, você pode criar um usuário via POST para rota `http://localhost:4000/users` com o body:
   ```
      { "user":
         {
            "name": "teste",
            "password": "teste",
            "email": "teste@teste"
         }
      }
   ```
   - Para autenticar o usuário, você pode usar o endpoint `http://localhost:4000/users/login` com o body:
   ```
      {
         "email": "seu_email",
         "password": "sua_senha"
      }
   ```
   - Você receberá como resposta um token, que deve ser enviado no header `authentication` da request nos endpoins `/cameras` e `notify_users`.
   - A rota de `/cameras` espera que a query graphql seja passada na url da requisição, exemplo:
   ```
      http://localhost:4000/cameras?query={users{id,name,email,cameras(filterBrand:"Hikvision",orderByName:"desc"){id,name,brand}}}
   ```
 
 ### Endpoints

   - GET /cameras
      - Retorna uma lista de usuários e suas câmeras ativas.
      - Endpoint: GET /cameras
   - POST /notify-users
      - Envia um e-mail para cada usuário com uma câmera da marca Hikvision.
      - Endpoint: POST /notify-users
   - POST /users
      - Cria um novo usuário.
      - Endpoint: POST /users
   - POST /users/login
      - Autentica o usuário e retorna um token JWT.
      - Endpoint: POST /users/login

### Testes
   - Para rodar os arquivos de teste
      1. entre no container da aplicação executando `docker compose exec app sh`
      2. no terminal do container execute `MIX_ENV=test mix test`

## Detalhes da Implementação
   - A escolha por usar docker foi feita para facilitar o desenvolvimento e a implantação do projeto, pois permite que o ambiente de desenvolvimento seja replicado facilmente em outros computadores.
   - Para implementar o seed que popula o banco, optei por criar um módulo que concentra os métodos onde é populado o banco, além disso, utilizei do `insert_all()` do Ecto, pois ignora validações desnecessárias, veja mais [aqui](https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert_all/3).
   - Na autenticação, optei por usar JWT, pois é um padrão de segurança bem conhecido e rápido de implementar.
   - Para a api GraphQL, concentrei toda lógica no arquivo `lib/basic_api_web/schema.ex` pois o contexto do desafio se limita a apenas uma rota, entretando poderia ser implementado de forma mais modular.
   - Utilizei a biblioteca `Mock` para auxiliar no desenvolvimento dos teste unitários.
