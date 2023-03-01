PRAGMA foreign_keys = ON;


DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users(fname, lname)
VALUES
    ('Jhon', 'Williams'),
    ('Henry', 'Castro');


INSERT INTO
    questions(title, body, user_id)
VALUES
    ('Setup terminal', 'How I set up the terminal?', (SELECT id FROM users WHERE fname = 'Henry')),
    ('Login to AAO', 'How I login into AAO?', (SELECT id FROM users WHERE fname = 'Jhon'));


INSERT INTO
    question_follows(question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Setup terminal'), (SELECT id FROM users WHERE fname = 'Jhon'));


INSERT INTO
    replies(question_id, parent_reply, user_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Setup terminal'), NULL, (SELECT id FROM users WHERE fname = 'Jhon'), 'I am having this problem.');

INSERT INTO
    replies(question_id, parent_reply, user_id, body)
VALUES
    ((SELECT id FROM questions WHERE title = 'Setup terminal'), (SELECT id FROM replies WHERE body = 'I am having this problem.'), (SELECT id FROM users WHERE fname = 'Henry'), 'It is so annoying!');


INSERT INTO
    question_likes(user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'Henry'), (SELECT id FROM questions WHERE title = 'Setup terminal'));
