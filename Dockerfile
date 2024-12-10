FROM elixir:1.17-alpine AS build

# Instalar dependências do sistema
RUN apk update && apk add --no-cache \
    build-base \
    nodejs \
    npm \
    git \
    postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix deps.get

COPY . .

RUN mix compile
RUN MIX_ENV=prod mix release

FROM alpine:3.17

RUN apk update && apk add --no-cache libstdc++ postgresql-client

WORKDIR /app
COPY --from=build /app/_build/prod/rel/basic_api ./

ENV DATABASE_URL=ecto://postgres:postgres@postgres:5432/basic_api_dev

EXPOSE 4000

CMD ["bin/basic_api", "start"]