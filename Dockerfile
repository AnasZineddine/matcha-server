FROM node:12

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ENV PORT=5050

ENV jwtSecret=thisisjwtsecretdontdothat
# email=maegan88@ethereal.email
ENV email=matchaserver22@gmail.com
ENV password=gMyBqqjduSYbSjNvJQ
ENV DATABASE_URL=postgresql://postgres:postgres@postgres:5432/matcha?schema=public

EXPOSE 5050

CMD ["npm", "start"]