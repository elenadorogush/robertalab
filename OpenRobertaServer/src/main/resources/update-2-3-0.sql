ALTER TABLE PROGRAM ADD AUTHOR_ID INTEGER DEFAULT 0 NOT NULL BEFORE PROGRAM_TEXT;
ALTER TABLE PROGRAM ADD FOREIGN KEY(AUTHOR_ID) REFERENCES USER(ID) ON DELETE CASCADE;
UPDATE PROGRAM SET AUTHOR_ID = OWNER_ID;
ALTER TABLE PROGRAM ALTER COLUMN NUMBER_OF_BLOCKS RENAME TO VIEWED;
DROP INDEX PROGNAMEOWNERROBOTIDX;
CREATE UNIQUE INDEX PROGNAMEOWNERROBOTIDX ON PROGRAM(NAME, OWNER_ID, ROBOT_ID, AUTHOR_ID);

CREATE TABLE USER_PROGRAM_LIKE (
  ID INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 42),
  USER_ID INTEGER NOT NULL,
  PROGRAM_ID INTEGER NOT NULL,
  CREATED TIMESTAMP NOT NULL,
  MARK VARCHAR(16M),
  COMMENT VARCHAR(16M),
 
  FOREIGN KEY (USER_ID) REFERENCES USER(ID) ON DELETE CASCADE,
  FOREIGN KEY (PROGRAM_ID) REFERENCES PROGRAM(ID) ON DELETE CASCADE
);

COMMIT;