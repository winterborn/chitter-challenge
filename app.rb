# file: app.rb

require_relative "lib/database_connection"

# We need to give the database name to the method `connect`.
DatabaseConnection.connect("chitter_test")

# Perform a SQL query on the database and get the result set.
sql = "SELECT id, title FROM albums;"
result = DatabaseConnection.exec_params(sql, [])

# Print out each record from the result set .
result.each { |record| p record }
