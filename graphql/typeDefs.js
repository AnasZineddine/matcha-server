const { gql } = require("apollo-server");

module.exports = gql`
  type File {
    success: Boolean
    message: String
    url: String
  }

  type User {
    id: ID
    firstName: String
    lastName: String
    username: String
    lastSeen: String
    email: String
    token: String
    distance: Int
    gender: String
    biography: String
    score: Int
    sexualPreference: String
    age: Int
    birthday: String
    interests: [String]
    connected: Boolean
    liked: Boolean
    lat: Float
    lon: Float
    profilePicture: String
    regularPictures: [String]
  }

  input RegisterInput {
    firstName: String!
    lastName: String!
    username: String!
    email: String!
    password: String!
  }

  input ResetInput {
    password: String!
    resetToken: String!
  }

  enum Gender {
    Male
    Female
  }

  enum SexualPreference {
    Heterosexual
    Bisexual
    Homosexual
  }

  type Interest {
    interest: String!
  }

  input InterestInput {
    interest: String!
  }

  input OrderByInput {
    age: Sort
    distance: Sort
    score: Sort
    interests: Sort
  }

  input FilterByInput {
    age: Filter
    distance: Filter
    score: Filter
    interests: [String]
  }

  input Filter {
    min: Int
    max: Int
  }
  enum Sort {
    asc
    desc
  }

  type notification {
    id: ID!
    from: String
    to: String
    message: String
  }

  type lastseen {
    id: ID!
    last_seen: String
  }

  enum Type {
    profile
    regular
  }

  type Message {
    id: ID!
    from: String!
    to: String!
    content: String!
    createdAt: String!
  }

  type Query @rateLimit(limit: 100, duration: 15) {
    uploads: [File]
    browseUsers(orderBy: OrderByInput, filterBy: FilterByInput): [User]
    checkProfile(profileId: ID): User
    getUser: User
    checkIfComplete: Boolean
    getMessages(from: String!): [Message]!
    getMatchedUsers: [User]!
    getNotifications: [notification]!
    getWhoLooked: [User]!
    getWhoLiked: [User]!
  }

  type Mutation @rateLimit(limit: 100, duration: 15) {
    register(registerInput: RegisterInput): User!
      @rateLimit(limit: 5, duration: 3600)
    login(username: String!, password: String!): User!
    confirmEmail(token: String!): Boolean!
    recoverPassword(email: String!): User!
    resetPassword(resetInput: ResetInput): User!
    modifyFirstName(firstName: String!): Boolean!
    modifyLastName(lastName: String!): Boolean!
    modifyEmail(email: String!): Boolean!
    modifyPosition(lat: Float!, lon: Float!): Boolean!
    modifyBirthday(birthday: String!): Boolean!
    addGender(gender: Gender!): Boolean!
    addSexualPreference(sexualPreference: SexualPreference!): Boolean!
    addBiography(biography: String!): Boolean!
    uploadFile(file: Upload, type: Type!): File
    deletePicture(url: String!, type: Type!): Boolean!
    addAge(age: Int!): Boolean!
    addInterrests(interests: [InterestInput]): Boolean!
    addInterrest(interest: String!): Boolean!
    removeInterrest(interest: String!): Boolean!
    forceGeolocation: User!
    likeUser(userToLikeId: String!): Boolean!
    unLikeUser(userToUnlikeId: String!): Boolean!
    blockUser(userToBlockId: String!): Boolean!
    logOut: Boolean!
    reportUser(userId: String!): Boolean!
    refreshToken: User!
    resendConfirmationEmail(userEmail: String!): Boolean!
    sendMessage(to: String!, content: String!): Message!
    readNotifications: Boolean
    updateLastSeen: Boolean!
  }

  type Subscription {
    newNotification: notification
    newMessage: Message
    newLastSeen: lastseen
  }
`;
