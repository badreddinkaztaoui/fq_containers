FROM node:alpine3.19

RUN npm install -g pnpm

WORKDIR /server

COPY package.json /server

RUN pnpm install

COPY . /server

EXPOSE 3000

CMD ["pnpm", "dev"]