DROP TABLE IF EXISTS content;
DROP TABLE IF EXISTS names;
DROP TABLE IF EXISTS durations;


CREATE TABLE durations(
   title      VARCHAR(51) NOT NULL PRIMARY KEY
  ,date_added VARCHAR(50)  NOT NULL
  ,duration   VARCHAR(9) NOT NULL
);

CREATE TABLE names(
   show_id VARCHAR(3) NOT NULL PRIMARY KEY
  ,`type`    VARCHAR(7) NOT NULL
  ,title   VARCHAR(51) NOT NULL
);
CREATE TABLE content(
   show_id    VARCHAR(3) NOT NULL PRIMARY KEY
  ,title      VARCHAR(51) NOT NULL
  ,date_added VARCHAR(50)  NOT NULL
  ,rating     VARCHAR(5) NOT NULL
  ,duration   VARCHAR(9) NOT NULL
  ,foreign key (show_id) references names(show_id)
);