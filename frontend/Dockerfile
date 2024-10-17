FROM node:23-alpine3.19 AS system

ARG UID=1000
ARG GID=1000

ENV HOST="0.0.0.0"
ENV PORT=3000
ENV NEXT_TELEMETRY_DISABLED=1

RUN deluser node && \
    addgroup -g $GID -S node && \
    adduser -D -u $UID -G node -S node

WORKDIR /app
RUN chown node:node -R /app

EXPOSE 3000
USER node:node


FROM system AS development-deps

COPY --chown=node:node package.json package.json
COPY --chown=node:node yarn.lock yarn.lock
RUN yarn --frozen-lockfile


FROM system AS development

COPY --from=development-deps --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node . .

RUN yarn build

CMD ["yarn", "start:dev"]


FROM system AS production-deps

COPY --chown=node:node package.json package.json
COPY --chown=node:node yarn.lock yarn.lock
RUN yarn --production --frozen-lockfile


FROM system AS production

COPY --chown=node:node package.json package.json
COPY --chown=node:node yarn.lock yarn.lock

COPY --from=production-deps --chown=node:node /app/node_modules ./node_modules
COPY --from=development --chown=node:node /app/.next/standalone ./
COPY --from=development --chown=node:node /app/.next/static ./.next/static

CMD ["yarn", "start:prod"]
