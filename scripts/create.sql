-- "lego lager" create script

create database if not exists legolager;
use legolager;

-- create all tables without any data
-- if a table with the same name already existed it will be dropped before


drop table if exists teil;
create table teil(
	id integer primary key auto_increment,
	bezeichnung varchar(100) default '' 
);

drop table if exists lieferant;
create table lieferant(
	id integer primary key auto_increment,
	name varchar(100) not NULL, -- name of the supplying company
	anschrift varchar(1000) not NULL -- adress of the supplying company
);

drop table if exists lego_set;
create table lego_set(
	id integer primary key auto_increment,
	lieferant_id integer, -- supplier of the lego set for (re-)orders
	bezeichnung varchar(100) default '', -- besser not NULL?
	anzahl_vorrat integer default 0, -- count of currently stored lego sets
	anzahl_bestellt integer default 0, -- count of currently ordered but not yet delivered lego sets, can be calculated via position_kundenbestellung so potentially not needed
	meldebestand integer default 0, -- amount of lego sets that should be available before reordering new sets (anzahl_vorrat - anzahl_bestellt)
	anzahl_nachbestellung integer default 0 -- minimal amount of lego sets that should be reordered, though the ordered amount might differ depending on the stored amount, reorder level and ordered amount
	-- foreign key (lieferant_id) references lieferant (id)
);

drop table if exists lego_set_besteht_aus_teil;
create table lego_set_besteht_aus_teil(
	id integer primary key auto_increment,
	legoset_id integer,
	teil_id integer,
	anzahl integer, -- amount of LEGO pieces with teil_id needed for this set 
	farbe char(8) -- color as ARGB value using hexadecimal digits
	-- foreign key (legoset_id) references lego_set (id),
	-- foreign key (teil_id) references teil (id)
);

drop table if exists kundenbestellung;
create table kundenbestellung(
	id integer primary key auto_increment,
	datum_eingang date not NULL, -- date when the order was received
	datum_versandt date default NULL, -- date when the order was shipped to the customer
	vname varchar(100) not NULL,
	name varchar(100) not NULL 
);

drop table if exists position_kundenbestellung;
create table position_kundenbestellung(
	id integer primary key auto_increment,
	kundenbestellung_id integer,
	legoset_id integer
	-- foreign key (kundenbestellungen_id) references kundenbestellungen (id),
	-- foreign key (legoset_id) references lego_set (id)
);

drop table if exists position_lieferantenbestellung;
create table position_lieferantenbestellung(
	id integer primary key auto_increment,
	legoset_id integer not NULL,
	lieferantbestellung_id integer not NULL,
	anzahl integer
	-- foreign key (legoset_id) references lego_set (id),
	-- foreign key (lieferantbestellung_id) references lieferanten_bestellung (id)
);


drop table if exists lieferanten_bestellung;
create table lieferanten_bestellung(
	id integer primary key auto_increment,
	lieferant_fk integer,
	lego_set_fk integer,
	anzahl integer,
	datum_versandt date not NULL,
	datum_erhalten date
	-- foreign key (lieferant_fk) references lieferant (id),
	-- foreign key (lego_set_fk) references lego_set (id)
);
