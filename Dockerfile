FROM node:18.17.1 as base
RUN apt-get update && npm install -g typescript@5.2.2
COPY ./ /raw
WORKDIR /raw
RUN npm i && npm run build && cp -rf node_modules dist/ && cp -rf resources/ dist/resources/ && cp ecosystem.config.js dist/ecosystem.config.js

FROM node:18.17.1
RUN apt-get update && npm install pm2 -g && apt-get install vim -y && mkdir logs && apt-get update
COPY --from=base /raw/dist/ /code
COPY .env /code/.env
WORKDIR /code
RUN mkdir uploads
ENV CUSTOM_SERVER_PORT 3000
ENV NODE_ENV production
ENV ENVIRONMENT production
EXPOSE 3000
CMD pm2-docker start ecosystem.config.js --env production


# docker build --platform linux/amd64 -f Dockerfile -t registry.gitlab.com/skm-universe/products/finance/finance-srv:main-2c5f9fd0a3a9e4a296cf83aa31c9fff8024a425e .
# docker push registry.gitlab.com/skm-universe/products/finance/finance-srv:main-2c5f9fd0a3a9e4a296cf83aa31c9fff8024a425e