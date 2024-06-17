FROM node:18-alpine3.19 AS system

ARG UID=1000
ARG GID=1000

ENV HOST="0.0.0.0"
ENV PORT=3000

RUN apk update && apk add openssl

RUN deluser node && \
    addgroup -g $GID -S node && \
    adduser -D -u $UID -G node -S node

WORKDIR /app
RUN chown node:node -R /app

EXPOSE 3000
USER node:node


FROM system AS development

ENV NODE_ENV="development"

COPY --chown=node:node package.json package.json
COPY --chown=node:node yarn.lock yarn.lock
RUN yarn --frozen-lockfile

COPY --chown=node:node . .
RUN if [ -d prisma ]; then yarn prisma generate; fi
RUN yarn build

CMD ["yarn", "start:dev"]


FROM system as production

ENV NODE_ENV="production"

COPY --chown=node:node package.json package.json
COPY --chown=node:node yarn.lock yarn.lock
RUN yarn --production --frozen-lockfile

COPY --from=development --chown=node:node /app/dist /app/dist

CMD ["yarn", "start:prod"]
