# Udacity-IntrotoRDS
Project files created as part of Udacity's Intro to Relational Databases Course
The project involved was to create a Postgresql database and tables that would track the players, matches, and results of a Swiss-style tournament.  A traditional tournament is where each player is paired with another, and only the winners advance to the next round, being paired with another winner from the previous round, and so forth, until a winner emerges.  A Swiss-style tournament is slightly different, where all players remain in the tournament in each round, however, they are paired based on their win record, with players of similar records competing against each other in each successive round until a winner has emerged.

To interact with the database and tables, a series of functions were written in Python to allow the user to input tournament data as well as retrieve an output analyzing aspects of the tournament, such as a list of players involved, the matches they played, their win records, and the pairings for the next round of the tournament.

The tournament.sql file provides the sql code for the creation of the database, tables, and views involved.
The tournament.py file provides the python code written to interact with the database file.
The tournament_test.py file was created by Udacity to test that the code in the other two files were written correctly.
