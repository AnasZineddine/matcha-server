const { ApolloServer, PubSub } = require("apollo-server");

const typeDefs = require("./graphql/typeDefs");
const resolvers = require("./graphql/resolvers");

const pubsub = new PubSub();

const port = process.env.PORT || 5000;

const server = new ApolloServer({
  cors: {
    origin: "*", // <- allow request from all domains
    credentials: true,
  },
  typeDefs,
  resolvers,
  context: ({ req }) => ({ req, pubsub }),
  introspection: true,
  playground: true,
});

server.listen({ port: port }).then((res) => {
  console.log(`Server running at ${res.url}`);
});
