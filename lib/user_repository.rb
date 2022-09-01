require_relative "user"
require_relative "user_repository"

class UserRepository
  def all
    users = []

    sql = "SELECT id, name, email FROM users;"
    result_set = DatabaseConnection.exec_params(sql, [])
    # Result set is an array of hashes.

    # Loop through result_set to create a model object for each record hash.
    result_set.each do |record|
      # Create a new model object with the record data.
      user = User.new
      user.id = record["id"].to_i
      user.name = record["name"]
      user.email = record["email"]

      users << user
    end

    return users
  end

  def find(id)
    sql = "SELECT id, name, email FROM users WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])

    user = User.new
    user.id = result_set[0]["id"].to_i
    user.name = result_set[0]["name"]
    user.email = result_set[0]["email"]

    return user
  end
end
