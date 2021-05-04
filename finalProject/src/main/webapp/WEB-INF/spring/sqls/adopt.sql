DROP SEQUENCE ANO;


DROP TABLE ADOPT;



CREATE SEQUENCE ANO NOCACHE;

CREATE TABLE ADOPT(

    ANO NUMBER PRIMARY KEY,
    MNO NUMBER NOT NULL,
    AAREA VARCHAR2(1000) NOT NULL,
    ATYPE VARCHAR2(1000) NOT NULL,
    ATITLE VARCHAR2(1000) NOT NULL,
    ADATE DATE NOT NULL,
    ACOUNT NUMBER NULL,
    ANMNAME VARCHAR2(1000) NOT NULL,
    ANMAGE NUMBER NOT NULL,
    ANMBREED VARCHAR2(1000) NOT NULL,
    ANMGENDER VARCHAR2(10) NOT NULL,
    ANMVCNYN VARCHAR2(2) NOT NULL,
    ANMNTRYN VARCHAR2(2) NOT NULL,
    APHONE VARCHAR2(1000) NULL,
    AMEMO VARCHAR2(1000) NULL,
    
 
 FOREIGN KEY(MNO) REFERENCES MEMBER(MNO),    
 CONSTRAINT ANMGENDERCHK CHECK(ANMGENDER IN('수컷','암컷')),
 CONSTRAINT ANMVCNYNCHK CHECK(ANMVCNYN IN('Y','N')),
 CONSTRAINT ANMNTRYNCHK CHECK(ANMNTRYN IN('Y','N'))
 

);

SELECT * FROM ADOPT;

commit;