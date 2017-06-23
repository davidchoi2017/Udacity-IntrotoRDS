-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


DROP DATABASE IF EXISTS tournament;

CREATE DATABASE tournament;

\c tournament;

CREATE TABLE players (playerid SERIAL, name TEXT);

CREATE TABLE matches (matchid SERIAL, round INTEGER, winner INTEGER, loser INTEGER);

CREATE VIEW winners as
SELECT winID, winNAME, count(matches.WINNER) AS WINS, matchTOT
FROM (SELECT players.PLAYERID AS winID, players.NAME AS winNAME, COUNT(matches.matchid) AS matchTOT
FROM players LEFT JOIN matches
ON players.PLAYERID = matches.WINNER OR players.PLAYERID = matches.LOSER
GROUP BY players.PLAYERID, players.NAME) AS totalmatches LEFT JOIN matches
        ON winID = matches.WINNER
GROUP BY winID, winNAME, matchTOT
ORDER BY WINS desc;

CREATE VIEW winnerrows as
    SELECT row_number() OVER () as ROW, *
    FROM winners;

CREATE VIEW nextround as
SELECT W1.winID as Player1ID, W1.winNAME as Player1NAME, W2.winID as Player2ID, W2.winNAME as Player2NAME FROM winnerrows W1, winnerrows W2 WHERE W1.WINS >= W2.WINS AND W1.winID != W2.winID AND W2.ROW - W1.ROW = 1 AND MOD(W1.ROW,2) = 1;

