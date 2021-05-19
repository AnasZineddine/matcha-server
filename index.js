const { ApolloServer, PubSub } = require("apollo-server-express");
const express = require("express");

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
  context: ({ req }) => ({ req, pubsub }),
  introspection: true,
  playground: true,
});

const app = express();
server.applyMiddleware({ app });

app.listen({ port: port }, () =>
  console.log(
    `🚀 Server ready at http://localhost:${port}${server.graphqlPath}`
  )
);
/*server.listen({ port: port }).then((res) => {
  console.log(`Server running at ${res.url}`);
});*/
