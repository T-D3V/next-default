FROM node:lts as dev
RUN apt-get update && apt-get install gnupg2 -y
RUN apt-get install vim git -y
WORKDIR /usr/src/app

FROM node:lts-alpine as builder
ENV NODE_ENV production
RUN apk --no-cache add python make g++
RUN npm -g install yarn
COPY package*.json ./
RUN yarn install --immutable --immutable-cache --check-cache

FROM node:lts-alpine as production
ENV NODE_ENV production
WORKDIR /usr/src/app
COPY --chown=node:node --from=builder node_modules/ node_modules/
COPY --chown=node:node ./ ./
USER node
CMD [ "yarn", "start" ]