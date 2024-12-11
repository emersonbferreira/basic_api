FROM elixir:1.17-alpine

RUN apk update && apk add \
    build-base \
    openssl-dev \
    nodejs \
    npm \
    git \
    postgresql-client

WORKDIR /app

COPY mix.exs mix.lock ./

COPY . .

RUN apk update && apk add libstdc++ postgresql-client

ENV DATABASE_URL=ecto://postgres:postgres@postgres:5432/basic_api_dev

EXPOSE 4000

CMD ["mix", "phx.server"]