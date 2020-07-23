--! Previous: -
--! Hash: sha1:9bfa55b3d4453c66c724fe660d0da7400424ff0a

-- test migrations

-- Setup
drop schema if exists app_public cascade;
create schema app_public;

grant usage on schema app_public to :DATABASE_VISITOR;
grant usage on schema app_public to :SYSTEM_ROLE;

alter default privileges in schema app_public grant usage, select on sequences to :DATABASE_VISITOR;
alter default privileges in schema app_public grant usage, select on sequences to :SYSTEM_ROLE;
----------------------------------------------------------------------------------------------------

create table app_public.author(
   id   serial primary key,
   name character varying NOT NULL
);

grant select on table app_public.author to :DATABASE_VISITOR;
grant delete on table app_public.author to :DATABASE_VISITOR;

grant insert (name) on table app_public.author to :DATABASE_VISITOR;
grant update (name) on table app_public.author to :DATABASE_VISITOR;

INSERT INTO app_public.author(name) VALUES('Herman Melville');
INSERT INTO app_public.author(name) VALUES('Dr T. Colin Campbell');
INSERT INTO app_public.author(name) VALUES('Dr Michael Greger');

----------------------------------------------------------------------------------------------------

create table app_public.books
(
    id   serial primary key,
    name character varying NOT NULL,
    isbn character varying NOT NULL,
    author_id int references app_public.author NOT NULL
);

grant select on table app_public.books to :DATABASE_VISITOR;
grant delete on table app_public.books to :DATABASE_VISITOR;

grant insert (name, isbn) on table app_public.books to :DATABASE_VISITOR;
grant update (name, isbn) on table app_public.books to :DATABASE_VISITOR;

CREATE INDEX ON app_public.books (name);
CREATE INDEX ON app_public.books (isbn);
CREATE INDEX ON app_public.books (author_id);


INSERT INTO app_public.books (name, isbn, author_id) VALUES ('Moby Dick or The Whale', '12345', 1);
INSERT INTO app_public.books (name, isbn, author_id) VALUES ('The China Study', '51231', 2);
INSERT INTO app_public.books (name, isbn, author_id) VALUES ('How Not to Die', '3221123', 3);

----------------------------------------------------------------------------------------------------

-- A Table without an ID field, but a primary key

create table app_public.favorite_books(
    isbn character varying primary key
);

grant select on table app_public.favorite_books to :DATABASE_VISITOR;
grant delete on table app_public.favorite_books to :DATABASE_VISITOR;

grant insert (isbn) on table app_public.favorite_books to :DATABASE_VISITOR;
grant update (isbn) on table app_public.favorite_books to :DATABASE_VISITOR;

INSERT INTO app_public.favorite_books (isbn) VALUES ('51231');
INSERT INTO app_public.favorite_books (isbn) VALUES ('3221123');

----------------------------------------------------------------------------------------------------

-- A View

CREATE VIEW app_public.all_favorite_books as (
    SELECT id, name from app_public.books where isbn IN (select isbn from app_public.favorite_books)
   );

GRANT SELECT on app_public.all_favorite_books TO :DATABASE_VISITOR;

-- A Function as Query

CREATE TYPE app_public.my_custom_book AS ( id int, name VARCHAR );

CREATE FUNCTION app_public.my_custom_books () returns setof app_public.my_custom_book AS
$$
    SELECT id, name from app_public.books where author_id IN (2)
$$ language sql STABLE;

GRANT ALL ON FUNCTION app_public.my_custom_books () TO :DATABASE_VISITOR;
