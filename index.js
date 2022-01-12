const { ApolloServer, PubSub } = require("apollo-server-express");
const express = require("express");
const http = require("http");

const cors = require("cors");

const {
  createRateLimitDirective,
  createRateLimitTypeDef,
} = require("graphql-rate-limit-directive");

const typeDefs = require("./graphql/typeDefs");
const resolvers = require("./graphql/resolvers");

const pubsub = new PubSub();

const port = process.env.PORT || 5000;

class RateLimitError extends Error {
  constructor(msBeforeNextReset) {
    super("Too many requests, please try again shortly.");

    // Determine when the rate limit will be reset so the client can try again
    const resetAt = new Date();
    resetAt.setTime(resetAt.getTime() + msBeforeNextReset);

    // GraphQL will automatically use this field to return extensions data in the GraphQLError
    // See https://github.com/graphql/graphql-js/pull/928
    this.extensions = {
      code: "RATE_LIMITED",
      resetAt,
    };
  }
}

// IMPORTANT: Specify how a rate limited field should behave when a limit has been exceeded
const onLimit = (resource, directiveArgs, obj, args, context, info) => {
  throw new RateLimitError(resource.msBeforeNext);
};

const server = new ApolloServer({
  cors: {
    origin: "http://localhost:6969", // <- allow request from all domains
    credentials: true,
  },
  typeDefs: [createRateLimitTypeDef(), typeDefs],
  resolvers,
  schemaDirectives: {
    rateLimit: createRateLimitDirective({
      onLimit,
    }),
  },
  context: ({ req, connection }) => ({ req, connection, pubsub }),
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
    `💩🚀 Server ready at http://localhost:${port}${server.graphqlPath}`
  )
);
/*server.listen({ port: port }).then((res) => {
  console.log(`Server running at ${res.url}`);
});*/
