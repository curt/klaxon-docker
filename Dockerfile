FROM elixir:1.14.3-alpine AS build
ENV MIX_ENV=prod

RUN apk add git gcc g++ musl-dev make cmake postgresql-client
ARG GIT_CACHE=true
RUN git clone https://github.com/curt/klaxon.git /opt/klaxon

WORKDIR /opt/klaxon

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix assets.deploy
RUN mix phx.digest
RUN mix compile
RUN mix phx.gen.release
RUN mix release

FROM alpine AS dist
ENV MIX_ENV=prod
EXPOSE 4000

RUN apk --no-cache add postgresql-client libstdc++ openssl ncurses-libs

RUN addgroup -g 1000 klaxon
RUN adduser -u 1000 -G klaxon -D -h /opt/klaxon klaxon

COPY --from=build --chown=klaxon:klaxon /opt/klaxon/_build/prod/rel/klaxon /opt/klaxon
COPY --chown=klaxon:klaxon ./docker-entrypoint.sh /opt/klaxon/docker-entrypoint.sh

USER klaxon

WORKDIR /opt/klaxon

ENTRYPOINT ./docker-entrypoint.sh
