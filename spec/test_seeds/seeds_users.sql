TRUNCATE TABLE users RESTART IDENTITY CASCADE;
TRUNCATE TABLE peeps RESTART IDENTITY;

INSERT INTO users (name, email) VALUES ('Phil', 'phil@gmail.com');
INSERT INTO users (name, email) VALUES ('Kat', 'kat@gmail.com');

INSERT INTO peeps (message_content, time_created, user_id) VALUES ('Eating breakfast!', '2022-09-01 10:00:00', 1);
INSERT INTO peeps (message_content, time_created, user_id) VALUES ('Going on holiday!', '2022-09-10 06:00:00', 2);