# Build Stage
FROM node:19-alpine as build-stage

WORKDIR /ui
COPY package.json .
RUN npm install
COPY . .

RUN npm run build

# Deploy to nginx Stage
FROM nginx:1.17.0-alpine

COPY --from=build-stage /ui/build /usr/share/nginx/html
EXPOSE $REACT_DOCKER_PORT

COPY nginx-default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD nginx -g 'daemon off;'
