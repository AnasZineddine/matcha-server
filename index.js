const { ApolloServer, PubSub } = require("apollo-server-express");
const express = require("express");
const http = require("http");

const typeDefs = require("./graphql/typeDefs");
const resolvers = require("./graphql/resolvers");

const pubsub = new PubSub();

const port = process.env.PORT || 5000;

const server = new ApolloServer({
  cors: {
    origin: "http://localhost:3000", // <- allow request from all domains
    credentials: true,
  },
  typeDefs,
  resolvers,
  uploads: {
    maxFileSize: 10000000, // 10 MB
    maxFiles: 20,
  },
  context: ({ req }) => ({ req, pubsub }),
  introspection: true,
  playground: true,
});

const app = express();
server.applyMiddleware({ app });

const httpServer = http.createServer(app);
server.installSubscriptionHandlers(httpServer);

app.use(express.static("graphql/resolvers/public"));

httpServer.listen({ port: port }, () =>
  console.log(
    `🚀 Server ready at http://localhost:${port}${server.graphqlPath}`
  )
);
/*server.listen({ port: port }).then((res) => {
  console.log(`Server running at ${res.url}`);
});*/
