const Repository = require("./repository")

const userRepository = new Repository()

userRepository.insert({ id: 1, name: "First Name" })
module.exports = {
    userRepository
}
