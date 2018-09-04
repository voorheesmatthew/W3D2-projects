PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);
INSERT INTO
users (fname, lname)
VALUES
('Faith', 'Tan'), ('Matt', 'Voorhees');

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO
questions (title, body, user_id)
VALUES
('SQL????', 'What is?', (SELECT id FROM users WHERE users.fname = 'Faith')),
('Rails???!', 'Also, What is?', (SELECT id FROM users WHERE users.fname = 'Matt'));

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Faith" AND lname = "Tan"),
  (SELECT id FROM questions WHERE title = "SQL????")),

  ((SELECT id FROM users WHERE fname = "Matt" AND lname = "Voorhees"),
  (SELECT id FROM questions WHERE title = "SQL????")
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "SQL????"),
  NULL,
  (SELECT id FROM users WHERE fname = "Faith" AND lname = "Tan"),
  "Did you say SQL SQL SQL?"
);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "SQL????"),
  (SELECT id FROM replies WHERE body = "Did you say SQL SQL SQL?"),
  (SELECT id FROM users WHERE fname = "Matt" AND lname = "Voorhees"),
  "I think she said RAILS MEOW MEOW."
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);
INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Matt" AND lname = "Voorhees"),
  (SELECT id FROM questions WHERE title = "SQL????")
);

-- and here is the lazy way to add some seed data:
INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);
  
  
  