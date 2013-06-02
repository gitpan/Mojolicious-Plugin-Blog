CREATE TABLE posts (id INTEGER primary key, title TEXT, body text, created DATE);

-- Create created time trigger
CREATE TRIGGER insert_posts_created AFTER INSERT ON posts
BEGIN
	UPDATE posts SET created = DATETIME("NOW") where rowid = new.rowid;
END;

-- test values to enter
insert into posts (title, body) values ('my test title 1','my test body 1');
insert into posts (title, body) values ('my test title 2','my test body 2');
insert into posts (title, body) values ('my test title 3','my test body 3');
insert into posts (title, body) values ('my test title 4','my test body 4');

