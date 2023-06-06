FROM node:18-alpine as BASE
RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json ./
RUN apk add --no-cache git \
    && yarn install --frozen-lockfile \
    && yarn cache clean

FROM node:18-alpine as BUILD
RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY --from=BASE /app/node_modules ./node_modules
COPY . .

RUN apk add --no-cache curl \ 
  && curl -sf https://gobinaries.com/tj/node-prune | sh -s -- -b /usr/local/bin \
  && apk del curl

RUN apk add --no-cache git curl \
    && yarn build \
    && rm -rf node_modules \
    && yarn install --production --frozen-lockfile --ignore-scripts --prefer-offline \
    && node-prune

FROM node:18-alpine as RELEASE
RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY --from=BUILD /app/.next/standalone ./
COPY --from=BUILD /app/public ./public
COPY --from=BUILD /app/next.config.js ./
COPY --from=BUILD /app/.next/static ./.next/static
COPY --from=BUILD /app/.next/server ./.next/server

EXPOSE 3000

CMD ["node", "server.js"]