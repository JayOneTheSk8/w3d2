PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);


CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255) NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jay', 'Cox'), ('Darren', 'Lin'), ('Oliver', 'Ball');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Favorite Pizza?', 'What is your favorite pizza?', (SELECT id FROM users WHERE fname = 'Jay')),
  ('Favorite Drink?', 'What is your favorite drink?', (SELECT id FROM users WHERE fname = 'Darren'));

INSERT INTO
  replies(question_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE '%Pizza%'), (SELECT id FROM users WHERE fname = 'Oliver'), 'Pepperoni');

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE '%Pizza%'),
  (SELECT id FROM replies WHERE body = 'Pepperoni'),
  (SELECT id FROM users WHERE fname = 'Jay'),
  'Cool');




    -- CREATE TABLE replies (
    --   id INTEGER PRIMARY KEY,
    --   question_id INTEGER NOT NULL,
    --   parent_id INTEGER,
    --   user_id INTEGER NOT NULL,
    --   body VARCHAR(255) NOT NULL,
    --
    --   FOREIGN KEY (question_id) REFERENCES questions(id),
    --   FOREIGN KEY (parent_id) REFERENCES replies(id),
    --   FOREIGN KEY (user_id) REFERENCES users(id)
