SPOOL project.out
SET ECHO ON
/*
Project: Inventory Database
Author: Li, Cheng(Coodinator)
Author: Krueger, Cody
Author: Helme, Cameron
Author: Basso, Ryan
*/
DROP TABLE player CASCADE CONSTRAINTS;
DROP TABLE property CASCADE CONSTRAINTS;
DROP TABLE weapon CASCADE CONSTRAINTS;
DROP TABLE armor CASCADE CONSTRAINTS;
DROP TABLE potion CASCADE CONSTRAINTS;
DROP TABLE spell CASCADE CONSTRAINTS;
DROP TABLE inventory CASCADE CONSTRAINTS;
DROP TABLE damagetype CASCADE CONSTRAINTS;
DROP TABLE playerproperty CASCADE CONSTRAINTS;
--
-- Create the tables for invertory
-- ----------------------------------------------------------------
CREATE TABLE player(
playerName	CHAR(20),
qp		INTEGER 	NOT NULL,
maxWeight	FLOAT		NOT NULL,
class		CHAR(20)	NOT NULL,
--
-- playerIC1:
-- playerName is the primary key.
CONSTRAINT playerIC1 PRIMARY KEY (playerName),
-- playerIC2:
-- A player must be able to hold some amount of weight.
-- and qp(QuestPoint) cannot be negative, you either have 0, or more.
CONSTRAINT playerIC2 CHECK (maxWeight > 0 AND qp >= 0),
-- playerIC3:
-- Player can only be one of following classes.
CONSTRAINT playerIC3 CHECK (class in ('Barbarian', 'Bard', 'Cleric', 
				      'Druid', 'Fighter',  
				      'Paladin', 'Ranger', 'Rogue', 
				      'Sorcerer', 'Wizard'))
);
-- ----------------------------------------------------------------
CREATE TABLE inventory(
inventoryName	CHAR(15),
iPlayer		CHAR(15)	NOT NULL,
location	CHAR(15)	NOT NULL,
--
-- iIC1:
-- inventoryName is the primary key.
CONSTRAINT iIC1 PRIMARY KEY(inventoryName)
);
-- ----------------------------------------------------------------
CREATE TABLE property(
propertyName	CHAR(15),
address		CHAR(25)	NOT NULL,
numRoom		INTEGER		NOT NULL,
--
-- pIC1:
-- propertyName is the primary key.
CONSTRAINT pIC1 PRIMARY KEY (propertyName),
-- pIC2:
-- A property must has at least one room.
CONSTRAINT pIC2 CHECK (numRoom > 0)
);
-- ----------------------------------------------------------------
CREATE TABLE weapon(
wid		INTEGER,
wName		CHAR(15)	NOT NULL,
damage		CHAR(15)	NOT NULL,
wType		CHAR(15)	NOT NULL,
wWeight		FLOAT		NOT NULL,
playerName	CHAR(15) 	NOT NULL,
inventoryName	CHAR(15)	NOT NULL,
--
-- wIC1:
-- wid is the primary key.
CONSTRAINT wIC1 PRIMARY KEY (wid),
-- wIC2:
-- A weapon can have no damage, but the damage must not be negative.
CONSTRAINT wIC2 CHECK (damage >= 0),
-- wIC3:
-- A weapon must have a weight greater than 0.
CONSTRAINT wIC3 CHECK (wWeight > 0),
-- wIC4:
-- The weapon must be hold by a player.
CONSTRAINT wIC4 FOREIGN KEY (playerName) REFERENCES player(playerName),
-- wIC5:
-- The weapon must actually exist in an inventory.
CONSTRAINT wIC5 FOREIGN KEY (inventoryName) REFERENCES inventory(inventoryName)
);
-- ----------------------------------------------------------------
CREATE TABLE armor(
aid		INTEGER,
armorName	CHAR(15)	NOT NULL,
AC		INTEGER		NOT NULL,
aType		CHAR(15)	NOT NULL,
aCheck		INTEGER		NOT NULL,
aWeight		FLOAT		NOT NULL,
playerName      CHAR(15)        NOT NULL,
inventoryName   CHAR(15)        NOT NULL,
--
-- aIC1:
-- aid is the primary key.
CONSTRAINT aIC1 PRIMARY KEY (aid),
-- aIC2:
-- An armor must have a weight greater than 0.
CONSTRAINT aIC2 CHECK (aWeight > 0),
-- aIC3:
-- Armor must be hold by a player.
CONSTRAINT aIC3 FOREIGN KEY (playerName) REFERENCES player(playerName),
-- aIC4:
-- Armor must actually exist in an inventory.
CONSTRAINT aIC4 FOREIGN KEY (inventoryName) REFERENCES inventory(inventoryName),
-- aIC5:
-- AC (armor class quality) must be at least 0.
CONSTRAINT aIC5 CHECK (AC >= 0)
-- aIC6:
-- Constraint the type in the following
);
-- ----------------------------------------------------------------
CREATE TABLE spell(
sid		INTEGER,
spellName	CHAR(15)	NOT NULL,
casterLevel	INTEGER		NOT NULL,
playerName	CHAR(15)	NOT NULL,
inventoryName	CHAR(15)	NOT NULL,
--
-- spIC1:
-- sid is the primary key.
CONSTRAINT spIC1 PRIMARY KEY (sid),
-- spIC2:
-- Caster level is at least one.
CONSTRAINT spIC2 CHECK (casterLevel >= 1),
-- spIC3:
-- Spell must be hold by a player.
CONSTRAINT spIC3 FOREIGN KEY (playerName) REFERENCES player(playerName),
-- spIC4:
-- Spell must actually exist in an inventory.
CONSTRAINT spIC4 FOREIGN KEY (inventoryName) REFERENCES inventory(inventoryName)
);
-- ----------------------------------------------------------------
CREATE TABLE potion(
pid		INTEGER,
potionName	CHAR(15)	NOT NULL,
sid		INTEGER		NOT NULL,
playerName      CHAR(15)        NOT NULL,
inventoryName   CHAR(15)        NOT NULL,
-- poIC1:
-- pid is the primary key
CONSTRAINT poIC1 PRIMARY KEY (pid),
-- poIC2:
-- Potion must also be a type of spell.
CONSTRAINT poIC2 FOREIGN KEY (sid) REFERENCES spell(sid),
-- poIC3:
-- Potion must be hold by a player.
CONSTRAINT poIC3 FOREIGN KEY (playerName) REFERENCES player(playerName),
-- poIC4:
-- Potion must exist in an inventory.
CONSTRAINT poIC4 FOREIGN KEY (inventoryName) REFERENCES inventory(inventoryName)
);
-- ----------------------------------------------------------------
CREATE TABLE damagetype(
wid		INTEGER		NOT NULL,
damageType	CHAR(15)	NOT NULL,
-- dIC1:
-- wid and damageType are the primary key.
CONSTRAINT dIC1 PRIMARY KEY (wid, damageType),
-- dIC2:
-- a weapon must actually exist.
CONSTRAINT dIC2 FOREIGN KEY (wid) REFERENCES weapon(wid)
);
-- ----------------------------------------------------------------
CREATE TABLE playerproperty(
propertyName	CHAR(15)	NOT NULL,
playerName	CHAR(15)	NOT NULL,
-- ppIC1:
-- propertyName and playerName primary key.
CONSTRAINT ppIC1 PRIMARY KEY (propertyName, playerName),
-- ppIC2:
-- A property must actually exist.
CONSTRAINT ppIC2 FOREIGN KEY (propertyName) REFERENCES property(propertyName),
-- ppIC3:
-- A Player must actually exist.
CONSTRAINT ppIC3 FOREIGN KEY (playerName) REFERENCES player(playerName)
);
--
--
--
--ADD THE INSERT DATA BELOW
--
--
--
--
-- ----------------------------------------------------------
-- Populate the database
-- ----------------------------------------------------------
--
alter session set  NLS_DATE_FORMAT = 'YYYY-MM-DD';
--
--gp and qp issue - 1 row 2 constraint issue
insert into player values ('Johannes', 18000, 175.0, 'Paladin');
insert into player values ('Lerdeth', 7000, 260.0, 'Barbarian');
insert into player values ('Alacor', 150, 100.0, 'Wizard');
insert into player values ('Andriel', 750, 130.0, 'Cleric');
--
--
insert into inventory values ('chest', 'Johannes', 'Ship: SS Victory');
insert into inventory values ('saddle bags', 'Johannes', 'Horse: Fury');
insert into inventory values ('vault', 'Johannes', 'Bank of Herrod');
insert into inventory values ('backpack', 'Johannes', 'On Person');
insert into inventory values ('belt', 'Johannes', 'On Person');
insert into inventory values ('backpack', 'Lerdeth', 'On Person');
insert into inventory values ('backpack', 'Alacor', 'On Person');
insert into inventory values ('backpack', 'Andriel', 'On Person');
--
--
insert into property values ('house1', '123 Straight St, Herrod', 5);
insert into property values ('house2', 'Ft Zombiehead, Apt 3, Dead Isle', 3);
insert into property values ('ship', 'SS Victory', 4);
insert into property values ('castle_north', 'Vaterland Capitol', 25);
--
--here is where we could had 2 constraint, name contains 'sword', damage must contain slashing
--damage is said to be greater than 0, but that is not possible with string
--remember float for weight
--how to insert multivalue?
insert into weapon values (01, 'Longsword, Blessed', '1d8+1', 'Slashing', 4.0, 'Johannes', 'belt');
insert into weapon values (02, 'Dagger', '1d4', 'Slashing' or 'Piercing', 1.0, 'Johannes', 'belt');
--insert into weapon values ( , '', '', '', , '', '');
