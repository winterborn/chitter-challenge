Users Model and Repository Classes Design Recipe
Copy this recipe template to design and implement Model and Repository classes for a database table.

1. Design and create the Table
   If the table is already created in the database, you can skip this step.

Table created

2. Create Test SQL seeds
   Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds\_{table_name}.sql)

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE users RESTART IDENTITY CASCADE;
TRUNCATE TABLE peeps RESTART IDENTITY;

INSERT INTO users (name, email) VALUES ('Phil', 'phil@gmail.com');
INSERT INTO users (name, email) VALUES ('Kat', 'kat@gmail.com');

INSERT INTO peeps (message_content, time_created, user_id) VALUES ('Eating breakfast!', '2022-09-01 10:00:00', 1);
INSERT INTO peeps (message_content, time_created, user_id) VALUES ('Going on holiday!', '2022-09-10 06:00:00', 2);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your*database_name < seeds*{table_name}.sql
```

3. Define the class names
   Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by Repository for the Repository class name.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end
```

4. Implement the Model class
   Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: users

# Model class
# (in lib/user.rb)
class User
  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :email
end
```

You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.

5. Define the Repository Class interface
   Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE

# Table name: users
# Repository class
# (in lib/user_repository.rb)

class UserRepository
  # Selecting all users
  # No arguments
  def all
    # Executes the SQL query: # SELECT id, name, email FROM users;
    # Returns an array of User objects.
  end
end
```

6. Write Test Examples
   Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all users

repo = UserRepository.new
users = repo.all
users.length # => 2 due to seeds_users having 2 user entries
users.first.id # => ('1')
users.first.name # => ('Phil')
users.first.email # => ('phil@gmail.com')

# 2
# Get a single user

repo = UserRepository.new
user = repo.find(1)
user.id # => 1
user.name # => ('Phil')
user.email # => ('phil@gmail.com')

repo = UserRepository.new
user = repo.find(2)
user.id # => 2
user.name # => ('Kat')
user.email # => ('kat@gmail.com')
```

Encode this example as a test.

7. Reload the SQL seeds before each test run
   Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_users_table
seed_sql = File.read('spec/seeds_users.sql')
connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
connection.exec(seed_sql)
end

describe UserRepository do
before(:each) do
reset_users_table
end

# (your tests will go here).
```

8. Test-drive and implement the Repository class behaviour
   After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.
