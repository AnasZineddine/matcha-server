const usersResolvers = require("./users");

module.exports = {
  Message: {
    createdAt: (parent) => parent.createdAt.toISOString(),
  },

  Mutation: {
    ...usersResolvers.Mutation,
  },
  Query: {
    ...usersResolvers.Query,
  },
  Subscription: {
    ...usersResolvers.Subscription,
  },
};
