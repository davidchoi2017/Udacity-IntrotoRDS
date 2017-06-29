-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
/*
Coder Name: David Choi
Date: 6-29-2017
Purpose of this file: to create a database of players and match information for a Swiss-style tournament.  This file will create a database and tables that the python file "tournament.py"
*/

DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament;

--creates a table listing all the players in the tournament, their names and their unique id.
CREATE TABLE players (playerid SERIAL primary key, name TEXT);

--creates a table listing all matches and their results (who won and lost)
CREATE TABLE matches (matchid SERIAL primary key, winner INTEGER references players (playerid), loser INTEGER references players (playerid));

--creates a view ranking each player based on their win record
--lists the number of matches they played as well
CREATE VIEW winners as
SELECT winID, winNAME, count(matches.WINNER) AS WINS, matchTOT
FROM (SELECT players.PLAYERID AS winID, players.NAME AS winNAME, COUNT(matches.matchid) AS matchTOT
FROM players LEFT JOIN matches
ON players.PLAYERID = matches.WINNER OR players.PLAYERID = matches.LOSER
GROUP BY players.PLAYERID, players.NAME) AS totalmatches LEFT JOIN matches
        ON winID = matches.WINNER
GROUP BY winID, winNAME, matchTOT
ORDER BY WINS desc;

--modifies the winners view to add an additional column that numbers each row so that the nextround view below can return proper results
CREATE VIEW winnerrows as
    SELECT row_number() OVER () as ROW, *
    FROM winners;

--creates a list of the next round of matchups in the Swiss-style tournament
CREATE VIEW nextround as
SELECT W1.winID as Player1ID, W1.winNAME as Player1NAME, W2.winID as Player2ID, W2.winNAME as Player2NAME FROM winnerrows W1, winnerrows W2 WHERE W1.WINS >= W2.WINS AND W1.winID != W2.winID AND W2.ROW - W1.ROW = 1 AND MOD(W1.ROW,2) = 1;
