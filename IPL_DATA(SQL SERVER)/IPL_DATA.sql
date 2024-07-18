create database IPL_data;
use IPL_data;

/*
This script 
1) creates all the tables required for the IPL database 
2) populates the tables with the data for the match 1 between Royal Challengers Bangalore (RCB) and Chennai Super Kings (CSK)
*/

-- Create the Venue Table
CREATE TABLE venue
(venue_id         INTEGER NOT NULL PRIMARY KEY , 
 venue_name    VARCHAR(200) NOT NULL UNIQUE);
 
INSERT INTO venue VALUES(1,'MA Chidambaram Stadium, Chepauk, Chennai');

SELECT * FROM venue;

-- Create the team table
CREATE TABLE team
(
 team_id INTEGER NOT NULL PRIMARY KEY ,
 team_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO team VALUES(1,'Royal Challengers Bengaluru');
INSERT INTO team VALUES(2,'Chennai Super Kings');

SELECT * FROM team;

-- Create the player table
CREATE TABLE player
(
 player_id INTEGER NOT NULL PRIMARY KEY ,
 player_name VARCHAR(100) NOT NULL,
 team_id INTEGER NOT NULL,
 FOREIGN KEY (team_id) REFERENCES team(team_id)
);

INSERT INTO player VALUES(1,'V Kohli',1);
INSERT INTO player VALUES(2,'F du Plessis',1);
INSERT INTO player VALUES(3,'RM Patidar',1);
INSERT INTO player VALUES(4,'GJ Maxwell',1);
INSERT INTO player VALUES(5,'C Green',1);
INSERT INTO player VALUES(6,'Anuj Rawat',1);
INSERT INTO player VALUES(7,'KD Karthik',1);
INSERT INTO player VALUES(8,'KV Sharma',1);
INSERT INTO player VALUES(9,'AS Joseph',1);
INSERT INTO player VALUES(10,'Mayank Dagar',1);
INSERT INTO player VALUES(11,'Mohammed Siraj',1);
INSERT INTO player VALUES(12,'Yash Dayal',1);
INSERT INTO player VALUES(13,'RD Gaikwad',2);
INSERT INTO player VALUES(14,'R Ravindra',2);
INSERT INTO player VALUES(15,'AM Rahane',2);
INSERT INTO player VALUES(16,'DJ Mitchell',2);
INSERT INTO player VALUES(17,'S Dube',2);
INSERT INTO player VALUES(18,'RA Jadeja',2);
INSERT INTO player VALUES(19,'Sameer Rizvi',2);
INSERT INTO player VALUES(20,'MS Dhoni',2);
INSERT INTO player VALUES(21,'DL Chahar',2);
INSERT INTO player VALUES(22,'M Theekshana',2);
INSERT INTO player VALUES(23,'TU Deshpande',2);
INSERT INTO player VALUES(24,'Mustafizur Rahman',2);

SELECT * FROM player;

-- Create the match table
CREATE TABLE match
(    match_id    INTEGER NOT NULL PRIMARY KEY,
     match_date    VARCHAR(10)  NOT NULL ,
     venue_id      INTEGER NOT NULL ,
     FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

INSERT INTO "match" VALUES(1,'2024-03-22',1);

-- Create the innings table
CREATE TABLE innings
(    match_id    INTEGER NOT NULL,
     innings_no   INTEGER NOT NULL,
     batting_team_id    INTEGER  NOT NULL ,
     bowling_team_id   INTEGER NOT NULL ,
     PRIMARY KEY (match_id, innings_no),
     FOREIGN KEY (batting_team_id) REFERENCES team(team_id),
     FOREIGN KEY (bowling_team_id) REFERENCES team(team_id)
);

INSERT INTO innings VALUES(1,1,1,2);
INSERT INTO innings VALUES(1,2,2,1);

SELECT * FROM innings;

-- Create the score_by_ball table
CREATE TABLE score_by_ball
(   match_id    INTEGER ,
    innings_no   INTEGER ,
    ball_no    FLOAT ,
    striker_id   INTEGER  ,
    non_striker_id   INTEGER  ,
    bowler_id    INTEGER ,
    runs_off_bat    INTEGER ,
    extras    INTEGER ,
    wides   INTEGER ,
    noballs   INTEGER ,
    byes    INTEGER ,
    legbyes   INTEGER ,
    penalty   INTEGER ,
    wicket_type   VARCHAR(200)  ,
    dismissed_player_id    INTEGER,
    PRIMARY KEY (match_id, innings_no, ball_no),
    FOREIGN KEY (match_id, innings_no) REFERENCES innings(match_id, innings_no),
    FOREIGN KEY (striker_id) REFERENCES player(player_id),
    FOREIGN KEY (non_striker_id) REFERENCES player(player_id),
    FOREIGN KEY (bowler_id) REFERENCES player(player_id),
    FOREIGN KEY (dismissed_player_id) REFERENCES player(player_id)
);

INSERT INTO score_by_ball VALUES(1,1,0.1,1,2,21,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.2,1,2,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.3,2,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.4,2,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.5,2,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.6,2,1,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,0.7,2,1,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.1,2,1,23,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.2,2,1,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.3,2,1,23,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.4,2,1,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.5,2,1,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,1.6,2,1,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.1,2,1,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.2,2,1,21,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.3,2,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.4,2,1,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.5,2,1,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.6,2,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,2.7,2,1,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.1,1,2,22,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.2,1,2,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.3,2,1,22,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.4,2,1,22,0,1,NULL,NULL,1,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.5,1,2,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,3.6,2,1,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,4.1,2,1,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,4.2,2,1,24,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,4.3,2,1,24,0,0,NULL,NULL,NULL,NULL,NULL,'caught',2);
INSERT INTO score_by_ball VALUES(1,1,4.4,3,1,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,4.5,3,1,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,4.6,3,1,24,0,0,NULL,NULL,NULL,NULL,NULL,'caught',3);
INSERT INTO score_by_ball VALUES(1,1,5.1,1,4,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,5.2,1,4,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,5.3,4,1,21,0,0,NULL,NULL,NULL,NULL,NULL,'caught',4);
INSERT INTO score_by_ball VALUES(1,1,5.4,5,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,5.5,5,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,5.6,5,1,21,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.1,1,5,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.2,5,1,18,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.3,5,1,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.4,5,1,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.5,1,5,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,6.6,5,1,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.1,5,1,22,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.2,5,1,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.3,1,5,22,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.4,1,5,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.5,5,1,22,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,7.6,5,1,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.1,5,1,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.2,1,5,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.3,5,1,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.4,5,1,18,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.5,5,1,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,8.6,1,5,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.1,1,5,22,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.2,1,5,22,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.3,1,5,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.4,5,1,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.5,1,5,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,9.6,5,1,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.1,5,1,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.2,5,1,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.3,5,1,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.4,1,5,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.5,1,5,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,10.6,1,5,18,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,11.1,5,1,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,11.2,1,5,24,0,0,NULL,NULL,NULL,NULL,NULL,'caught',1);
INSERT INTO score_by_ball VALUES(1,1,11.3,6,5,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,11.4,5,6,24,0,0,NULL,NULL,NULL,NULL,NULL,'bowled',5);
INSERT INTO score_by_ball VALUES(1,1,11.5,7,6,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,11.6,7,6,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.1,7,6,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.2,7,6,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.3,6,7,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.4,7,6,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.5,7,6,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,12.6,6,7,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.1,6,7,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.2,7,6,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.3,6,7,18,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.4,6,7,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.5,7,6,18,0,1,NULL,NULL,NULL,1,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,13.6,6,7,18,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.1,6,7,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.2,6,7,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.3,7,6,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.4,6,7,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.5,7,6,21,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,14.6,6,7,21,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.1,7,6,22,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.2,7,6,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.3,6,7,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.4,7,6,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.5,6,7,22,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,15.6,7,6,22,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.1,6,7,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.2,6,7,24,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.3,6,7,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.4,6,7,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.5,7,6,24,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.6,7,6,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,16.7,6,7,24,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.1,7,6,23,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.2,7,6,23,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.3,7,6,23,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.4,7,6,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.5,6,7,23,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.6,6,7,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.7,6,7,23,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,17.8,6,7,23,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.1,7,6,24,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.2,7,6,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.3,6,7,24,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.4,6,7,24,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.5,7,6,24,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.6,7,6,24,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,18.7,7,6,24,0,1,NULL,NULL,NULL,1,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.1,7,6,23,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.2,7,6,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.3,7,6,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.4,7,6,23,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.5,7,6,23,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.6,6,7,23,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.7,6,7,23,0,2,2,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.8,7,6,23,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,1,19.9,7,6,23,0,0,NULL,NULL,NULL,NULL,NULL,'run out',6);
INSERT INTO score_by_ball VALUES(1,2,0.1,13,14,11,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,0.2,13,14,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,0.3,13,14,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,0.4,13,14,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,0.5,13,14,11,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,0.6,13,14,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.1,14,13,12,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.2,14,13,12,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.3,13,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.4,13,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.5,13,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,1.6,13,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.1,14,13,11,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.2,14,13,11,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.3,14,13,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.4,13,14,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.5,14,13,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.6,13,14,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,2.7,14,13,11,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.1,13,14,12,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.2,14,13,12,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.3,14,13,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.4,14,13,12,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.5,13,14,12,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,3.6,13,14,12,0,0,NULL,NULL,NULL,NULL,NULL,'caught',13);
INSERT INTO score_by_ball VALUES(1,2,4.1,14,15,9,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.2,14,15,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.3,15,14,9,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.4,15,14,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.5,14,15,9,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.6,14,15,9,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,4.7,14,15,9,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.1,15,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.2,15,14,12,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.3,15,14,12,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.4,15,14,12,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.5,15,14,12,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,5.6,15,14,12,3,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.1,15,14,8,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.2,15,14,8,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.3,15,14,8,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.4,15,14,8,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.5,14,15,8,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,6.6,14,15,8,0,0,NULL,NULL,NULL,NULL,NULL,'caught',14);
INSERT INTO score_by_ball VALUES(1,2,7.1,15,16,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,7.2,16,15,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,7.3,16,15,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,7.4,16,15,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,7.5,16,15,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,7.6,15,16,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.1,16,15,8,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.2,16,15,8,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.3,16,15,8,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.4,16,15,8,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.5,15,16,8,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,8.6,16,15,8,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.1,16,15,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.2,15,16,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.3,16,15,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.4,16,15,10,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.5,16,15,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,9.6,15,16,10,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.1,15,16,5,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.2,15,16,5,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.3,15,16,5,0,0,NULL,NULL,NULL,NULL,NULL,'caught',15);
INSERT INTO score_by_ball VALUES(1,2,10.4,17,16,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.5,16,17,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.6,17,16,5,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,10.7,17,16,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.1,17,16,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.2,16,17,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.3,17,16,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.4,16,17,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.5,17,16,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,11.6,16,17,9,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.1,17,16,5,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.2,17,16,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.3,16,17,5,0,0,NULL,NULL,NULL,NULL,NULL,'caught',16);
INSERT INTO score_by_ball VALUES(1,2,12.4,18,17,5,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.5,18,17,5,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.6,18,17,5,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,12.7,18,17,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.1,18,17,4,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.2,18,17,4,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.3,18,17,4,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.4,17,18,4,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.5,17,18,4,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,13.6,17,18,4,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.1,18,17,11,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.2,18,17,11,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.3,18,17,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.4,17,18,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.5,18,17,11,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,14.6,17,18,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.1,18,17,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.2,17,18,5,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.3,17,18,5,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.4,17,18,5,3,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.5,18,17,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.6,17,18,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,15.7,18,17,5,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.1,18,17,9,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.2,18,17,9,2,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.3,18,17,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.4,17,18,9,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.5,17,18,9,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.6,17,18,9,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.7,17,18,9,0,4,NULL,NULL,4,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,16.8,17,18,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.1,17,18,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.2,17,18,11,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.3,17,18,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.4,17,18,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.5,17,18,11,4,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,17.6,17,18,11,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,18.1,18,17,9,1,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,18.2,17,18,9,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,18.3,17,18,9,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,18.4,17,18,9,6,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO score_by_ball VALUES(1,2,18.5,17,18,9,0,4,NULL,NULL,NULL,4,NULL,NULL,NULL);

SELECT * FROM score_by_ball;


-- Create the result table
CREATE TABLE result
(    match_id    INTEGER NOT NULL PRIMARY KEY,
     winning_team_id INTEGER NOT NULL,         
     player_of_the_match_id   INTEGER NOT NULL ,
     FOREIGN KEY (match_id) REFERENCES match(match_id),
     FOREIGN KEY (winning_team_id) REFERENCES team(team_id),
     FOREIGN KEY (player_of_the_match_id) REFERENCES player(player_id)
);

INSERT INTO result VALUES(1,2,24);

------------------------------------------------------------------------------------------------------------

/* TASK :
Please write a SELECT statement to produce a result set with the match level summary which should include
match_id
match_date
venue_name
winning_team_name */

select 
m.match_id,
m.match_date,
v.venue_name,
t.team_name as winning_team_name
from match m
LEFT JOIN
venue v on m.venue_id = v.venue_id
LEFT JOIN
result r on r.match_id = m.match_id
LEFT JOIN
team t on t.team_id = r.winning_team_id

---------------------------------------------------------------------------------------------------------------

/* TASK - 
Innings level information Required
-------------------------------------
1. Name of the teams played
2. Total runs scored
3. Total wickets lost
4. Total overs played
*/

select 
i.innings_no,
bat_t.team_name as 'batting_team',
--bowl_t.team_name as 'bowling_team',
sum(runs_off_bat) + sum(extras)  as 'total_runs_scored',
count(wicket_type) as 'wickets',
(count(*) - count(wides) - count(noballs)) / 6  +
cast((count(*) - count(wides) - count(noballs)) % 6 as float)/10 as total_overs_played
from 
innings i
INNER JOIN
team bat_t on i.batting_team_id = bat_t.team_id
INNER JOIN
team bowl_t on i.bowling_team_id = bowl_t.team_id
INNER JOIN
score_by_ball sbb on i.innings_no = sbb.innings_no
group by i.innings_no,bat_t.team_name

------------------------------------------------------------------------------------------------------------

/* TASK --- Batting Summary (Batsman Level)
Please write a SELECT statement to produce a result set with the player level batting scorecard as shown below in the expected result
match_id
innings_no
batting_team_name - Name of the team which is batting this innings
batsman_name - Name of the player to whom the scores belong to
total_runs  - Total runs scored by this player in this match/ innings
total_balls - Total balls faced by this player in this match/ innings
no_of_fours - Number of 4s hit by this player in this match/ innings
no_of_sixes - Number of 6s hit by this player in this match/ innings
strike_rate - Strike rate at which the batsman scored the runs. It's calculated as runs per balls, represented as a percentage with 2 decimal places.*/

select 
sbb.match_id,
sbb.innings_no,
t.team_name as 'batting_team_name',
p.player_name as 'batsman name',
sum(runs_off_bat) as 'total_runs',
count(*) as 'total_balls',
sum(case when runs_off_bat = 4 then 1 else 0 end) as '4s',
sum(case when runs_off_bat = 6 then 1 else 0 end) as '6s',
round((cast(sum(runs_off_bat) as float) / cast(count(*) as float)) * 100,2) as 'strike_rate'
from score_by_ball sbb
INNER JOIN
player p on p.player_id = sbb.striker_id
INNER JOIN 
innings i on i.match_id = sbb.match_id
INNER JOIN
team t on i.batting_team_id = t.team_id
where sbb.wides is null and sbb.noballs is null
group by 
sbb.match_id,
sbb.innings_no,
t.team_name,
p.player_name

----------------------------------------------------------------------------------------------------------
/*Please write a SELECT statement to produce a result set with the team level batting scorecard containing extras as shown below in the expected result
match_id
innings_no
batting_team_name - Name of the team which is batting this innings
total_extras - Total extra runs from this innings
total_noballs  - Total no balls bowled in this innings
total_wides - Total wide balls bowled in this innings
total_byes - Total runs categorised as byes  in this innings
total_legbyes - Total runs categorised as leg byes  in this innings
total_penalty - Total runs categorised as penalties  in this innings*/

select 
sbb.match_id,
sbb.innings_no,
t.team_name as 'batting_team_name',
sum(sbb.extras) as 'extras',
COALESCE(sum(sbb.noballs),0) as 'noballs',
sum(sbb.wides) as 'wides',
sum(sbb.byes) as 'byes',
sum(sbb.legbyes) as 'legbyes',
COALESCE(sum(sbb.penalty),0) as 'penalty'
from score_by_ball sbb
INNER JOIN
player p on p.player_id = sbb.striker_id
INNER JOIN 
innings i on (i.match_id = sbb.match_id and i.innings_no = sbb.innings_no)
INNER JOIN
team t on i.batting_team_id = t.team_id
group by 
sbb.match_id,
sbb.innings_no,
t.team_name

----------------------------------------------------------------------------------------------------------

/*Please write a SELECT statement to produce a result set with the bowling scorecard as shown below in the expected result
match_id
innings_no
bowling_team_name - Name of the team which is bowling this innings
bowler_name - Name of the player who has bowled this over
total_overs  - Total overs bowled by this player in this match/ innings. An over in cricket is 6 balls. No balls and wides don't count towards the balls bowled. So, please exclude them. Also, please format the output as overs.balls (e.g., 3.4). If there are zero balls, just output the number of overs (e.g. 4).
total_runs - Total runs conceded by this player in this match/ innings
total_wickets - Total wickets taken by this player in this match/ innings
economy - Runs conceded per over by this player. The result to be rounded to 2 decimal places if there are decimal places in the output.
dots - Number of dot balls (i.e., no runs scored) bowled by this player in this match/ innings*/

SELECT i.match_id,
				i.innings_no,
				t.team_name,
				p.player_name AS bowler_name,
				CASE WHEN ((COUNT(*) - COUNT(wides) - COUNT(noballs)) % 6) = 0 -- Check to see if there are any remaining balls
						 THEN (COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6 -- Just output the overs as there are no remaining balls
						 ELSE  CAST(((COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6) AS INTEGER) +
						 CAST(((COUNT(*) - COUNT(wides) - COUNT(noballs)) % 6)/10 AS INTEGER) 
				END AS total_overs,
				SUM(s.runs_off_bat +  COALESCE(s.wides, 0) + COALESCE(s.noballs, 0)) AS total_runs,
				COUNT(wicket_type) AS total_wickets       ,
				ROUND(
							SUM(s.runs_off_bat +  COALESCE(s.wides, 0) + COALESCE(s.noballs, 0)) 
									/   (CAST((COUNT(*) - COUNT(wides) - COUNT(noballs)) AS REAL) / 6) 
							, 2)  AS economy,
				SUM(IIF(s.runs_off_bat = 0 AND s.wides IS NULL AND s.noballs IS NULL, 1, 0)) AS dots
	  FROM innings i JOIN team t ON (i.batting_team_id = t.team_id)
							JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
							JOIN player p ON (s.bowler_id = p.player_id)
	 GROUP BY i.match_id,
				i.innings_no,
				t.team_name,
				p.player_name
	ORDER BY  i.match_id,
				i.innings_no,
				MIN(s.ball_no);