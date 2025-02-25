# Two Tables Design Recipe Template

## 1. Extract nouns from the user stories or specification

```
STRAIGHT UP

As a Maker
So that I can let people know what I am doing
I want to post a message (peep) to chitter

As a maker
So that I can see what others are saying
I want to see all peeps in reverse chronological order

As a Maker
So that I can better appreciate the context of a peep
I want to see the time at which it was made

As a Maker
So that I can post messages on Chitter as me
I want to sign up for Chitter
```

```
Nouns:

peeps, message_content, time_created, user_id
users
```

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record | Properties                             |
| ------ | -------------------------------------- |
| peeps  | message_content, time_created, user_id |
| users  | name, email                            |

1. Name of the first table (always plural): `peeps`

   Column names: `message_content`, `time_created`, `user_id`

2. Name of the second table (always plural): `users`

   Column names: `name, email`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
# EXAMPLE:

Table: peeps
id: SERIAL
message_content: text
time_created: timestamp
user_id: int

Table: users
id: SERIAL
name: text
email: text
```

## 4. Decide on The Tables Relationship

Most of the time, you'll be using a **one-to-many** relationship, and will need a **foreign key** on one of the two tables.

To decide on which one, answer these two questions:

1. Can one [PEEP] have many [USERS]? (No)
2. Can one [USER] have many [PEEPS]? (Yes)

You'll then be able to say that:

1. **[USER] has many [PEEPS]**
2. And on the other side, **[PEEPS] belongs to [USERS]**
3. In that case, the foreign key is in the table [PEEPS]

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: users_table.sql

-- Replace the table name, column names and types.

-- Create the table without the foreign key first.
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email text
);

-- Then the table with the foreign key next.
CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  message_content text,
  time_created timestamp,
-- The foreign key name is always {other_table_singular}_id
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 chitter < users_table.sql
```
