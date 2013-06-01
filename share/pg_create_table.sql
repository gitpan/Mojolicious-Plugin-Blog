create sequence posts_serial_seq;

create table posts (
       title varchar(255),
       body text,
       created date,
       id integer primary key default nextval('posts_serial_seq')
);

insert into posts values ('my test title 1','my test body 1', now());
insert into posts values ('my test title 2','my test body 2', now());
insert into posts values ('my test title 3','my test body 3', now());
insert into posts values ('my test title 4','my test body 4', now());
