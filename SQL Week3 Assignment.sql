
-- SQL WEEK 3 Assignment
-- Rob Hodde  11/14/2015

/* An organization grants key-card access to rooms based on groups that key-card holders belong to.  
Your job is to design the database that supports the key-card system.
*/


-- DROP DATABASE UserSecurity;
CREATE DATABASE UserSecurity;

-- Users can belong to only one group, therefore, design in 1:1 relationship between user and group
CREATE TABLE `UserSecurity`.`tbl_User` (
  `UserID`  INT NOT NULL PRIMARY KEY,
  `Name`    VARCHAR(100) NOT NULL,
  `GroupID` INT NULL REFERENCES tbl_Group(GroupID)
 );
 
CREATE TABLE `UserSecurity`.`tbl_Group` (
  `GroupID` INT NOT NULL PRIMARY KEY,
  `Name`    VARCHAR(100) NOT NULL
 );

CREATE TABLE `UserSecurity`.`tbl_Room` (
  `RoomID`  INT NOT NULL PRIMARY KEY,
  `Name`    VARCHAR(100) NOT NULL
 );

-- Establish a junction table to support many-to-many relationship between Groups and Rooms
CREATE TABLE `UserSecurity`.`tbl_GroupRoom` (
  GroupID INT NOT NULL REFERENCES `UserSecurity`.`tbl_Group`(GroupID),
  RoomID  INT NOT NULL REFERENCES `UserSecurity`.`tbl_Room`(RoomID),
  CONSTRAINT pk_GroupID_RoomID PRIMARY KEY(GroupID, RoomID)
 );


/* There are six users, and four groups. 
Modesto and Ayine are in group “I.T.” 
Christopher and Cheong woo are in group “Sales”. 
Saulat is in group “Administration.” 
Heidy is a new employee, who has not yet been assigned to any group.
Group “Operations” currently doesn’t have any users assigned.  */

INSERT INTO UserSecurity.tbl_Group (GroupID, Name)
VALUES
(0, 'I.T.'),
(1, 'Sales'),
(2, 'Administration'),
(3, 'Operations');

INSERT INTO UserSecurity.tbl_User (UserID, Name, GroupID)
VALUES
(0, 'Modesto', 0),
(1, 'Ayine', 0),
(2, 'Christopher', 1),
(3, 'Cheong woo', 1),
(4, 'Saulet', 2),
(5, 'Heidy', NULL);


-- There are four rooms: “101”, “102”, “Auditorium A”, and “Auditorium B”. 
INSERT INTO UserSecurity.tbl_Room (RoomID, Name)
VALUES
(0, '101'), 
(1, '102'), 
(2, 'Auditorium A'),
(3, 'Auditorium B');


/* I.T. should be able to access Rooms 101 and 102. 
   Sales should be able to access Rooms 102 and Auditorium A.  */
INSERT INTO `UserSecurity`.`tbl_GroupRoom` (GroupID, RoomID)
VALUES
(0, 0),
(0, 1),
(1, 1),
(1, 2);


--  Provide the following information:
--  • All groups, and the users in each group. A group should appear even if there are no users assigned to the group. 
  
  SELECT g.Name AS `Group Name`, CASE WHEN u.Name IS NULL THEN '' ELSE u.Name END AS `User Name`
  FROM UserSecurity.tbl_Group g 
  LEFT JOIN UserSecurity.tbl_User u ON g.GroupID = u.GroupID
  ORDER BY g.Name, u.Name;
  
  
--  • All rooms, and the groups assigned to each room. The rooms should appear even if no groups have been assigned to them.

  SELECT r.Name AS 'Room Name', CASE WHEN g.Name IS NULL THEN '' ELSE g.Name END AS 'Group Name'
  FROM UserSecurity.tbl_Room r 
  LEFT JOIN UserSecurity.tbl_GroupRoom gr ON gr.RoomID = r.RoomID
  LEFT JOIN UserSecurity.tbl_group g      ON gr.GroupID = g.GroupID;


-- alternatively using GROUP_CONCAT so that all legal groups are listed in a CSV list for each room:

  SELECT r.Name AS 'Room Name', GROUP_CONCAT(DISTINCT CASE WHEN g.Name IS NULL THEN '' ELSE g.Name END) AS 'Group Name'
  FROM UserSecurity.tbl_Room r 
  LEFT JOIN UserSecurity.tbl_GroupRoom gr ON gr.RoomID = r.RoomID
  LEFT JOIN UserSecurity.tbl_group g      ON gr.GroupID = g.GroupID
  GROUP BY r.Name;


/* • A list of users, the groups that they belong to, and the rooms to which they are assigned. This should be sorted
   alphabetically by user, then by group, then by room. */

  SELECT u.Name AS 'User Name', CASE WHEN g.Name IS NULL THEN '' ELSE g.Name END AS 'Group Name',
         CASE WHEN r.Name IS NULL THEN '' ELSE r.Name END AS 'Room Name'
  FROM UserSecurity.tbl_User u  
  LEFT JOIN UserSecurity.tbl_Group g      ON u.GroupID = g.GroupID
  LEFT JOIN UserSecurity.tbl_GroupRoom gr ON gr.GroupID = g.GroupID
  LEFT JOIN UserSecurity.tbl_Room r       ON r.RoomID = gr.RoomID
  ORDER BY u.Name, g.Name, r.Name;
 
-- NOTE: the sort on group name is redundant in this schema because there is a 1:1 relationship between User Name and Group Name


