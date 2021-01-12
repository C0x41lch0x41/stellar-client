FROM ubuntu:16.04 as build

MAINTAINER SDF Ops Team <ops@stellar.org>

ADD . /app/src
WORKDIR /app/src

RUN apt-get update && apt-get install -y curl git make g++ bzip2 apt-transport-https && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_6.x xenial main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y nodejs

ENV NODE_ENV=prd CI=true

# RUN rm -rf app/bower_components && mkdir -p .npm && npm install && \
#     ./node_modules/.bin/bower --allow-root install && ./node_modules/.bin/gulp dist
RUN npm install && npm build

FROM nginx:1.17

COPY --from=build /app/src/dist/ /usr/share/nginx/html/
