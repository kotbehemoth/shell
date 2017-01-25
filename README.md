shell
=====

Shell scripts and configuration

# Install

In order to install run prepare.sh script  
`./prepare.sh`

# Functions

## Cscope

Create new project:  
`proj <new project>`


Change, set or unset the project:  
`proj`


Create cscope database:  
`mkcs <folder1> [<folder2> ...]`  
e.g.:  
`mkcs .`


Regenerate previously created cscope database:  
`mkcs`


Edit folders included in the cscope database:  
`edproj`


Cscope tool:  
`cs f <function> <query>`

functions:
* s - symbols
* g - global definitions
* c - calls
* t - text
* e - egrep pattern
* i - includes
* d - functions called

## Files browsing

Search all files with maching pattern:

`ff <file_pattern>`  
Print and open selected file (opens automatically if only one result)

`fl <file_pattern>`  
Just print matching files


Cscope database is used, if not available then all files under current folder are checked

## Pattern searching

Grep files under current folder (case insensitive)

`gg <pattern>`  
Print and open file at the match (opens automatically if only one result)

`g <pattern>`  
Just print matches

