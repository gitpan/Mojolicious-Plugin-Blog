#!/bin/sh

# Assumes ENV['USER'] is granted permission to postgresql.
createdb myblog
psql myblog < pg_create_table.sql
