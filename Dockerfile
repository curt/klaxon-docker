FROM elixir:1.14.3-alpine AS build
ENV MIX_ENV=prod

RUN apk add git gcc g++ musl-dev make cmake postgresql-client
RUN git clone https://github.com/curt/klaxon.git /opt/klaxon

WORKDIR /opt/klaxon

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix compile && \
    mix assets.deploy

FROM elixir:1.14.3-alpine AS dist
ENV MIX_ENV=prod
EXPOSE 4000

RUN apk add git postgresql-client

RUN addgroup -g 1000 klaxon
RUN adduser -u 1000 -G klaxon -D -h /opt/klaxon klaxon

COPY --from=build --chown=klaxon:klaxon /opt/klaxon /opt/klaxon
COPY --chown=klaxon:klaxon ./docker-entrypoint.sh /opt/klaxon/docker-entrypoint.sh

USER klaxon

WORKDIR /opt/klaxon

RUN mix local.hex --force && \
    mix local.rebar --force

ENTRYPOINT ./docker-entrypoint.sh
