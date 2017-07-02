#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#
"""
Coder Name: David Choi
Date: 6-29-2017
Purpose of this file: to retrieve data and analyze it from the "tournament" database, which is created by tournament.sql file.
It is designed to perform various functions such as retrieve the number of players in the Swiss-style tournament, the number of matches player, the results of those matches, the win records of each player, and the matchups for the nextround in the tournament.
"""

import psycopg2

def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    db = psycopg2.connect("dbname=tournament")
    c = db.cursor()
    return db, c

def deleteMatches():
    """Remove all the match records from the database."""
    db, c = connect()
    query = "truncate only matches;"
    c.execute(query)
    db.commit()
    db.close()

def deletePlayers():
    """Remove all the player records from the database."""
    db, c = connect()
    query = "truncate only players cascade;"
    c.execute(query)
    db.commit()
    db.close()

def countPlayers():
    """Returns the number of players currently registered."""
    db, c = connect()
    query = "select count(*) as num from players;"
    c.execute(query)
    results = c.fetchone()
    db.close()
    return results[0]

def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """
    db, c = connect()
    query = "INSERT INTO players (NAME) VALUES (%s);"
    param = (name,)
    c.execute(query, param)
    db.commit()
    db.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    db, c = connect()
    query = "SELECT * FROM winners;"
    c.execute(query)
    results = c.fetchall()
    db.close()
    return results

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    db, c = connect()
    query = "INSERT INTO matches (WINNER, LOSER) VALUES (%s, %s);"
    param = (winner, loser,)
    c.execute(query, param)
    db.commit()
    db.close()

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    db, c = connect()
    query = "SELECT * FROM nextround;"
    c.execute(query)
    results = c.fetchall()
    db.close()
    return results
