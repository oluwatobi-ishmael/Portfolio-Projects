/*1. Which two teams have the highest total sum of number of goals scored in all their face-offs with each
other (regardless of who is at home or away)? --*/

SELECT t1.team_long_name, t2.team_long_name, m.home_team_api_id, m.away_team_api_id, SUM(home_team_goal + away_team_goal) AS total_goals 
FROM match m 
JOIN team t1 
ON m.home_team_api_id = t1.team_api_id Join team t2 
ON m.away_team_api_id = t2.team_api_id 
GROUP BY 1, 2, home_team_api_id, away_team_api_id Order BY 5 DESC

or

SELECT t1.team_long_name as team1, t2.team_long_name as team2, match_goals.home_team_api_id, match_goals.away_team_api_id, match_goals.total_goals 
  FROM (SELECT home_team_api_id, away_team_api_id, SUM(home_team_goal + away_team_goal) AS total_goals 
        FROM match 
        GROUP BY 1, 2) match_goals 
  JOIN team t1 
  ON match_goals.home_team_api_id = t1.team_api_id 
  JOIN team t2 
  ON match_goals.away_team_api_id = t2.team_api_id 
  ORDER BY 5 DESC

/*2. Which young player (under or equal 21 years old as of start of 2011/2012 season) has the highest
average overall rating in the 2011/2012 season? Assuming 2011/2012 season started on August 13th,
2011 and ended on May 13th, 2012.*/

SELECT player_data.player_name, player_data.birthday, player_data.overall_rating, match.season
  FROM match 
  JOIN (SELECT player.id, player.player_name, player.birthday, player_attributes.overall_rating FROM player 
        JOIN player_attributes 
        ON player.id = player_attributes.id 
        WHERE player.birthday >= '1990-08-14') AS player_data 
  ON match.id = player_data.id 
  WHERE match.season = '2011/2012' 
  ORDER BY player_data.overall_rating DESC LIMIT 10

/*3. Write a query to return the final English Premier League table for 2010/2011 season. Return the
teams names, total points (win=3 points, draw=1 point, lose=0 point), total goal scored, total goal
against, and total goal difference. Sort the resulting table by total points and then by goal difference
(both in descending order). */

SELECT home.team_api_id, home.team_long_name, (home.match_played_h + away.match_played_a) "Match_played", 
 (home.total_goal_scored_h + away.total_goal_scored_a) "Total_Goal_Scored", 
 (home.Total_goal_against_h + away.Total_goal_against_a) "Total_Goal_against", 
 ((home.total_goal_scored_h + away.total_goal_scored_a) - 
 (home.Total_goal_against_h + away.Total_goal_against_a)) "Goal_Difference",
 (home.points_h + away.points_a) "Total_Point"
FROM (SELECT Table_h.team_api_id, Table_h.team_long_name, COUNT(match_api_id) match_played_h, 
 SUM(Table_h.home_team_goal) Total_goal_scored_h, SUM(Table_h.away_team_goal) Total_goal_against_h, 
 SUM(point_h) Points_h
 FROM (SELECT th.team_api_id, th.team_long_name, m.match_api_id, m.home_team_goal, 
   m.away_team_goal,  
   CASE
    WHEN m.home_team_goal > m.away_team_goal THEN 3
    WHEN m.home_team_goal = m.away_team_goal THEN 1
    ELSE 0
   END Point_h
  FROM match m
  JOIN team th
  ON m.home_team_api_id = th.team_api_id
  WHERE country_id = 1729 AND season = '2010/2011') Table_h
  GROUP BY 1,2) Home
JOIN 
 (SELECT Table_a.team_api_id, Table_a.team_long_name, COUNT(Table_a.match_api_id) match_played_a, 
 SUM(Table_a.away_team_goal) Total_goal_scored_a, SUM(Table_a.home_team_goal) Total_goal_against_a, 
 SUM(point_a) Points_a
 FROM (SELECT ta.team_api_id, ta.team_long_name, m.match_api_id, m.home_team_goal, 
   m.away_team_goal,  
   CASE
    WHEN m.away_team_goal > m.home_team_goal THEN 3
    WHEN m.away_team_goal = m.home_team_goal THEN 1
    ELSE 0
   END Point_A
  FROM match m
  JOIN team ta
  ON m.away_team_api_id = ta.team_api_id
  WHERE country_id = 1729 AND season = '2010/2011') Table_A
  GROUP BY 1, 2) Away
ON home.team_api_id = Away.team_api_id
GROUP BY 1,2, 3, 4, 5, 6, 7
ORDER BY 7 DESC

/* 4. Role 6 and 4 are considered as center back and central midfielder respectively by some people.
Conversely, others consider role 6 and 4 as central midfielder and center back respectively. Using only
the home players, compare the y coordinate with the highest number of matches for these two roles
and tell us which of these two roles is considered as central back in the dataset. */

SELECT COUNT(Role_4_ultimate.match_api_id) no_of_matches, 
	COUNT(Role_4_ultimate.home_player_4) role_4, SUM(role_4_cb) center_back_role4, 
	SUM(role_4_cm) central_midfield_role4, COUNT(Role_6_ultimate.home_player_6) role_6, 
	SUM(role_6_cb) center_back_role6, SUM(role_6_cm) entral_midfield_role6
FROM(SELECT cen_back_4.match_api_id, cen_back_4.home_player_4, role_4_cb, role_4_cm
	FROM (SELECT match_api_id, home_player_4,
	CASE
	WHEN home_player_y4 = 3 THEN 1
	ELSE 0
	END role_4_cb
FROM match
WHERE home_player_4 IS NOT NULL) cen_back_4
JOIN (SELECT match_api_id, home_player_4,
	CASE
	WHEN home_player_y4 = 7 THEN 1
	ELSE 0
	END role_4_cm
FROM match
WHERE home_player_4 IS NOT NULL) cen_mid_4
ON cen_back_4.match_api_id = cen_mid_4.match_api_id) role_4_ultimate
JOIN (SELECT cen_back_6.match_api_id, cen_back_6.home_player_6, role_6_cb, role_6_cm
FROM (SELECT match_api_id, home_player_6,
	CASE
	WHEN home_player_y6 = 3 THEN 1
	ELSE 0
	END role_6_cb
FROM match
WHERE home_player_6 IS NOT NULL) cen_back_6
JOIN (SELECT match_api_id, home_player_6,
	CASE
	WHEN home_player_y6 = 7 THEN 1
	ELSE 0
	END role_6_cm
FROM match
WHERE home_player_6 IS NOT NULL) cen_mid_6
ON cen_back_6.match_api_id = cen_mid_6.match_api_id) role_6_ultimate
ON role_4_ultimate.match_api_id = role_6_ultimate.match_api_id

/* 5. Which team(s) has the maximum chance creation shooting in the database?*/

SELECT team.team_long_name, team_attributes.chancecreationshooting 
  FROM team 
  JOIN team_attributes ON team.team_api_id = team_attributes.team_api_id 
  GROUP BY team.team_long_name, team_attributes.chancecreationshooting 
  ORDER BY team_attributes.chancecreationshooting DESC

/*6. Who are the top 10 players with the highest average sprint_speed in the database?*/

SELECT player.player_name, player_attributes.sprint_speed, AVG(player_attributes.sprint_speed) AS
avg_sprint 
  FROM player 
  JOIN player_attributes 
  ON player.player_api_id = player_attributes.player_api_id 
  WHERE player_attributes.sprint_speed IS NOT NULL 
  GROUP BY player.player_name, player_attributes.sprint_speed 
  ORDER BY player_attributes.sprint_speed DESC

or

SELECT player.player_api_id, player.player_name, player_attributes.sprint_speed,
AVG(player_attributes.sprint_speed) AS sprint_average 
  FROM player 
  JOIN player_attributes 
  ON player.player_api_id = player_attributes.player_api_id 
  WHERE sprint_speed IS NOT NULL 
  GROUP BY player.player_api_id, player.player_name, player_attributes.sprint_speed 
  ORDER BY sprint_average DESC LIMIT 10

/*7. Which goalkeeper (role 1) has the most number of appearance in the database?*/

SELECT player.player_name, SUM(home_player_1) AS home_apprearance, SUM(away_player_1) AS
away_appearance, SUM(match.home_player_1 + match.away_player_1) AS total_appearance 
  FROM player 
  JOIN match 
  ON player.id = match.id 
  WHERE home_player_1 IS NOT NULL AND away_player_1 IS NOT NULL 
  GROUP BY player.player_name 
  ORDER BY total_appearance

/*8. Which league has the highest goals per match in the database?*/

SELECT league.country_id, league.name, match.match_api_id, match.home_team_goal,
match.away_team_goal, match.home_team_goal + match.away_team_goal AS Total_goal 
  FROM league
  JOIN match 
  ON league.country_id = match.country_id 
  GROUP BY league.country_id, league.name, match.match_api_id, match.home_team_goal, match.away_team_goal 
  ORDER BY Total_goal DESC LIMIT 10

/*9. Which team has the lowest Bet365 home win odds in the database?*/

SELECT team.team_long_name, match.b365h 
  FROM team 
  JOIN match 
  ON team.id = match.id 
  ORDER BY match.b365h ASC

OR

SELECT team.team_long_name, min(b365h) 
  FROM team 
  JOIN match 
  ON team.id = match.id 
  GROUP BY 1 
  ORDER BY 2 ASC LIMIT 10

/*10. There is a constant debate of who the greatest of all time (GOAT) is. Compare Lionel Messi and
Cristiano Ronaldo’s average, median, maximum, and minimum overall rating.*/

SELECT player.player_name, AVG(overall_rating), PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY
overall_rating) AS Median, MIN(overall_rating) AS Min, MAX(overall_rating) AS Max 
  FROM player 
  JOIN player_attributes 
  ON player.Player_api_id = player_attributes.Player_api_id 
  WHERE player_name = 'Lionel Messi' or player_name = 'Cristiano Ronaldo'
  GROUP BY 1

/*11. Find the correlation coefficient and slope of a linear regression line fitted on finishing and
overall_rating (using finishing as the independent variable and overall_rating as the dependent variable)
for all players that had one time played role number 9.*/

SELECT player.player_name, match.home_player_9, match.away_player_9, corr(player_attributes.finishing, player_attributes.overall_rating) AS corr_coeff, 
regr_slope(player_attributes.finishing, player_attributes.overall_rating) 
  FROM player 
  JOIN player_attributes 
  ON player.player_api_id = player_attributes.player_api_id 
  JOIN match ON match.id = player_attributes.player_api_id 
  GROUP BY player.player_name, match.home_player_9, match.away_player_9 
  ORDER BY corr_coeff

OR

SELECT corr(player_attributes.finishing, player_attributes.overall_rating), match.home_player_9, match.away_player_9 
  FROM player_attributes 
  JOIN match 
  ON player_attributes.id = match.id 
  GROUP BY match.home_player_9, match.away_player_9 
  ORDER BY corr(player_attributes.finishing, player_attributes.overall_rating) ASC

/*12. Report any other insights you obtained from the data (exclusive of what could be gotten from any of the tasks above).*/

-The “ID”primary is a unique key on all tables but it isn’t the best primary key to join all tables.
- Merging the country table and league table would have been recommended instead of splitting them into different tables.
- Merging the player attributes table and player table would have our data neater and easier to analyse.
- Olympique Marselle has the highest chance creation shooting.
- Lastly, based on the overall rating Lionel Messi is the greatest of all time.
