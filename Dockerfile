###################################################
FROM node:16-alpine as builder

# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add \
    build-base gcc autoconf \
    automake zlib-dev libpng-dev \
    nasm bash vips-dev ca-certificates \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install ca-certificates \
    && update-ca-certificates 2>/dev/null || true

ENV PATH /app/node_modules/.bin:$PATH

ENTRYPOINT []

COPY ./package.json /app/

WORKDIR /app/

RUN yarn install --production=true --non-interactive --frozen-lockfile

RUN rm -rf /root/.netrc

CMD ["/bin/bash"]

###################################################
FROM builder AS local

ENV NODE_ENV=development
ENV PORT=1337

WORKDIR /app/

RUN yarn install --non-interactive --frozen-lockfile

CMD ["./run-devserver"]
