      *******************************************************************
      *                                                                 *
      *            ZST005 : Preprocessing Payment Interfaces            *
      *     (Mapping between old acct/member and the new acct nos.)     *
      *                                                                 *
      *******************************************************************
      *                                                                 *
      * File formats:                                                   *
      *--------------                                                   * 
      * "ANG" = ANGKASA (Implemented 15/07)                             *
      * "BEN" = BENDAHARI (Implemented 15/07)                           *
      * "OTH" = OTHER FORMATS (Implemented 24/07)                       * 
      *                                                                 *
      *******************************************************************
      * Code copy's  -->   RSTPNT.cbl                                   *
      *******************************************************************
      * Code reviewer : xxx           * Review date : nn/nn/nnnn        *
      *******************************************************************
      *
       IDENTIFICATION DIVISION.
      *========================*
       PROGRAM-ID.                        ZST005.
       AUTHOR.                            JHC.
       DATE-WRITTEN.                      15/07/2009                 

       ENVIRONMENT DIVISION.
      *=====================*
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.                   UNIX.
       OBJECT-COMPUTER.                   UNIX.
       SPECIAL-NAMES.                     DECIMAL-POINT IS COMMA.

       DATA DIVISION.
      *==============*

       WORKING-STORAGE SECTION.
      *========================

      * ================
      * Copy's of tables
      * ================

           @COPFIC, AGD06-01.
           @COPFIC, CDD01-01.
           @COPFIC, CDD33-01.
           @COPFIC, FCD02-01.
           @COPFIC, TAD01-01.
           @COPFIC, ZSL04-01.
           @COPFIC, ZSD02-01.
           @COPFIC, ZSD04-01.
           @COPFIC, ZSD05-01.
ZM0018     @MLTCOPY.


      * ====================
      * Copy's of interfaces
      * ====================

           COPY TAR1C.
           COPY CWFRMTC.
           COPY FCR1C.
           COPY FCRDC.
           COPY FCRPC.
           COPY RSTPNTC.


      * ========
      * Copy's V
      * ========

           COPY     CCXXV.
           COPY     XXXXV.
       
      *===========*
       01  WORKER.
      *===========*
           03  DATSYS                     PIC X(08).
           03  HEUSYS                     PIC X(08).
           03  ZONLIB                     PIC X(40).

           03  NUMCPT                     PIC X(30).
ZZ0088     03  NUMCPT-NEW                 PIC X(30).
           03  NUMCPT-THA                 PIC X(12).
           03  NUMCPT-CDD                 PIC X(12).
           03  NUMCPT-TST                 PIC X(12).
           03  NUMSEQ                     PIC X(06).
           03  MONMVT-ANG                 PIC 9(07).        
           03  MONMVT-BEN                 PIC 9(14).
           03  MONMVT                     PIC S9(14)V9(02) COMP-3.
           03  MONRBT-TOT                 PIC S9(14)V9(02) COMP-3.
           03  MONRPY                     PIC S9(14)V9(02) COMP-3.
           03  REFOPN                     PIC X(16).
           03  RPYMTH-EXT                 PIC X(08).
           03  RPYMTH-INT                 PIC X(08).
           03  CODERR                     PIC X(02).
           03  SWIERR                     PIC X(01).
ZZ008G     03  SWIYES                     PIC X(01).
ZZ005T     03  SWIFIN-RBT                 PIC X(01).
           03  SWISTP-ZZ2                 PIC X(01).
           03  I1                         PIC 9(02).
           03  I2                         PIC 9(02).
           03  TABMVT OCCURS 99
            05 NUMCPT-TAB                 PIC X(12).
            05 MONTB1-TAB                 PIC S9(14)V9(02) COMP-3.
ZZ00A0     03  DEDTOT                     PIC 9(07).        
ZZ00A0     03  DEDIND                     PIC 9(07).        
ZZ00AB     03  DEDTOT-1                   PIC S9(14)V9(02) COMP-3.
ZZ00AL     03  SWIZER                     PIC X(01).           
ZZ00AL     03  SWIAMT                     PIC X(01).           
ZZ00AL     03  TABTEM OCCURS 20
ZZ00AL      05 REFLOT-TEM                 PIC X(10).
ZZ00AL      05 NUMTEC-TEM                 PIC X(06).
ZZ00AL     03  I3                         PIC 9(02).
ZZ00AL     03  SWIMAX                     PIC 9(02).
ZZ00AL     03  SWITOT                     PIC X(01).           
ZM0018     03  Z1                         PIC 9(01).           
ZM0018     03  MLTSOC-BCK                 PIC X.           
ZM0018     03  ACCNUM.           
ZM0018         05  ACCNUM-FIR             PIC 9(03).           
ZM0018         05  ACCNUM-LST             PIC 9(27).


       01  CWITF.
           COPY CW-ITF. 
           
      *  Interface J2/J3     

           
       LINKAGE SECTION.
      *================*
       01  CWOPT.
           03  ARGC-CW                    PIC 9(4) COMP.
           COPY CWTECHC.                                
           
      *  Interface J1/J2     

           COPY ZST005C.
       
       PROCEDURE DIVISION USING CWOPT.
      *===============================*

                             
      * ========================
      * Init of batch processing
      * ======================== 
       
       INIT-J2.
      *--------*
      
ZM0018     @OPEN,"IO",AGD06-01.
ZM0018     IF NOMFIC OF ZST005 = "ANG"
ZM0018        @OPEN,"IN",ZSL04-01
ZM0018     END-IF.
ZM0018     @OPEN,"IO",TAD01-01.
ZM0018
ZM0018     @OPEN,"IO",ZSD04-01.
ZM0018     @OPEN,"IO",ZSD05-01.
ZM0018     MOVE 1 TO MLTSOC OF CW-ITF.

ZM0018*           @OPEN,"IO",AGD06-01.
           @OPEN,"IO",CDD01-01.
           @OPEN,"IO",CDD33-01.
           @OPEN,"IO",FCD02-01.
           @OPEN,"IO",ZSD02-01.
ZM0018*           @OPEN,"IO",ZSD04-01.
ZM0018*           @OPEN,"IO",ZSD05-01.
ZM0018*           IF NOMFIC OF ZST005 = "ANG"
ZM0018*              @OPEN,"IN",ZSL04-01
ZM0018*           END-IF.
ZM0018*           @OPEN,"IO",TAD01-01.
AKHAKH*    @OPEN,"IO",CWD07-01. 
AKHAKH*    @OPEN,"IO",CWD37-01. 

ZM0018     MOVE 2 TO MLTSOC OF CW-ITF.

ZM0018     @OPEN,"IO",CDD01-01.
ZM0018     @OPEN,"IO",CDD33-01.
ZM0018     @OPEN,"IO",FCD02-01.
ZM0018     @OPEN,"IO",ZSD02-01.
ZM0018*    @OPEN,"IO",ZSD04-01.
ZM0018*    @OPEN,"IO",ZSD05-01.
AKHAKH     @OPEN,"IO",CWD07-01. 
AKHAKH     @OPEN,"IO",CWD37-01. 
ZM0018     MOVE 1 TO MLTSOC OF CW-ITF.

           MOVE 0 TO RETURN-CODE.

           MOVE DATBUS     OF CWTECH      TO CWBUJR      OF CW-ITF.
           MOVE "ZS"                      TO CWJRNL      OF CW-ITF.
           MOVE "ZST005"                  TO CURRENT-PGM OF CW-ITF.
           MOVE SPACES                    TO CWUSER      OF CW-ITF.
           MOVE DATSYS     OF WORKER      TO CWDASY      OF CW-ITF.
           MOVE HEUSYS     OF WORKER      TO CWHESY      OF CW-ITF.
           MOVE "ZST005"                  TO NOMPJ2      OF CWLIG.

      * ================================================================
      *  Check if the batch hasn't already been executed this day and up
      *  -date of start date & time into table 019.
      * ================================================================     
           
           @CWRD,"01","N".

           @FCR1,"B3",REFOPN OF WORKER,XX.
           IF CODRET OF FCR1 NOT = "00"
               MOVE SPACES             TO ZONLIB OF WORKER
               STRING "FCR1R / "
                      CODRSC OF FCR1
                      DELIMITED BY SIZE INTO ZONLIB OF WORKER
               END-STRING
              @CWERR,ZST005,"ZST00501",ZONLIB OF WORKER,,"I","1",\
                  "0","Y","01"
           END-IF.
           
      * ==================
      *  Get restart point
      * ==================
           
           PERFORM GET-RESTART-POINT.
           
      * ================
      * Batch processing
      * ================ 

       PRG-INIT.
      *---------*

        MOVE SPACES               TO  SWIERR OF WORKER.
        MOVE SPACES               TO  CODERR OF WORKER.
ZZ00AL  MOVE SPACES               TO  SWIZER OF WORKER.
ZZ00AL  MOVE SPACES               TO  SWIAMT OF WORKER.
ZZ00AL  MOVE "0"                  TO  I3     OF WORKER.
ZZ00AL  MOVE SPACES               TO  SWITOT OF WORKER.


+jhc  *display "JHC ZST005 NOMFIC ="NOMFIC OF ZST005.
        EVALUATE NOMFIC OF ZST005 
      *Angkasa File 
         WHEN "ANG"
              @READNX,ZSL04-01,XX
      *Bendahari File
         WHEN "BEN"
              PERFORM START-ZSD04 THRU START-ZSD04-FN
      *Others
         WHEN "OTH"
              PERFORM START-ZSD05 THRU START-ZSD05-FN
        END-EVALUATE.
        

      *--> Loop
        PERFORM LOOP-REC THRU LOOP-REC-FN
                      UNTIL NOT ACCESS-OK.

           
      * =======================
      * End of batch processing
      * ======================= 
       
       PRG-END.
      *--------*
       
      * ==========================================
      *  Update of end date & time into table 019.
      * ==========================================     
           
           @CWRD,"02","N".
      
      * --> The batch ended properly, no need to save restart point
      
           PERFORM NO-RESTART-POINT.

      * --> File closing
           

ZM0018     @CLOSE,AGD06-01.
ZM0018     IF NOMFIC OF ZST005 = "ANG"
ZM0018        @CLOSE,ZSL04-01
ZM0018     END-IF.
ZM0018     @CLOSE,TAD01-01.
ZM0018     @CLOSE,ZSD04-01.
ZM0018     @CLOSE,ZSD05-01.
ZM0018
ZM0018     MOVE 1 TO MLTSOC OF CW-ITF.
ZM0018*           @CLOSE,AGD06-01.
           @CLOSE,CDD01-01.
           @CLOSE,CDD33-01.
           @CLOSE,FCD02-01.
           @CLOSE,ZSD02-01.
ZM0018*           @CLOSE,ZSD04-01.
ZM0018*           @CLOSE,ZSD05-01.
ZM0018*           IF NOMFIC OF ZST005 = "ANG"
ZM0018*              @CLOSE,ZSL04-01
ZM0018*           END-IF.
ZM0018*           @CLOSE,TAD01-01.
AKHAKH*    @CLOSE,CWD07-01. 
AKHAKH*    @CLOSE,CWD37-01. 
           
ZM0018     MOVE 2 TO MLTSOC OF CW-ITF.
ZM0018     @CLOSE,CDD01-01.
ZM0018     @CLOSE,CDD33-01.
ZM0018     @CLOSE,FCD02-01.
ZM0018     @CLOSE,ZSD02-01.
ZM0018*    @CLOSE,ZSD04-01.
ZM0018*    @CLOSE,ZSD05-01.
AKHAKH*    @CLOSE,CWD07-01. 
AKHAKH*    @CLOSE,CWD37-01. 
      * --> Transaction end
      
           CALL "CWCOMMIT" USING CWACCESS CW-ITF. 
      
           STOP RUN.

       
      **************************************************************
      *                                                            *
      *                 P  E  R  F  O  R  M  S                     *
      *                                                            *
      **************************************************************

      * =======================
      * Treatment of the record
      * =======================


        START-ZSD04.
      *-------------*
         INITIALIZE ZSD04-01.

         MOVE SPACES                  TO NUMCPT OF ZSD04-01.

         @START,"1","GE",ZSD04-01,XX.
         IF ACCESS-OK
            @READNX,ZSD04-01,XX
         ELSE
            MOVE SPACES               TO ZONLIB OF WORKER
            MOVE "ZSD04"              TO ZONLIB OF WORKER
            @CWERR,ZST005,"XXXX0240",ZONLIB OF WORKER,,"I","2",\
               "0","N","01"
            GO PRG-END
         END-IF.

        START-ZSD04-FN.
      *----------------*
            EXIT.


        START-ZSD05.
      *-------------*
         INITIALIZE ZSD05-01.

         MOVE SPACES                  TO NUMCPT OF ZSD05-01.

         @START,"1","GE",ZSD05-01,XX.
         IF ACCESS-OK
            @READNX,ZSD05-01,XX
         ELSE
            MOVE SPACES               TO ZONLIB OF WORKER
            MOVE "ZSD05"              TO ZONLIB OF WORKER
            @CWERR,ZST005,"XXXX0240",ZONLIB OF WORKER,,"I","2",\
               "0","N","01"
            GO PRG-END
         END-IF.

        START-ZSD05-FN.
      *----------------*
            EXIT.


        LOOP-REC.
      *----------*
      
      * For each record: 
      * 1.save the acct nos. in NUMCPT OF WORKER
      * 2.save the amount in a worker variable MONMVT OF WORKER

        MOVE "N" TO SWIERR OF WORKER.

        EVALUATE NOMFIC OF ZST005
      *Angkasa File
         WHEN "ANG"

ZZ00A0      IF TYPROW OF ZSL04-01 = "0"
ZZ00AL
ZZ00AL* Check if program reach another "0" and the amount stil not = 0
ZZ00AL         IF SWIZER OF WORKER = "N"
ZZ00AL            IF DEDTOT OF WORKER > 0
ZZ00AL               MOVE "Y"                    TO SWIAMT OF WORKER
ZZ00AL               MOVE "07"                   TO CODERR OF WORKER
ZZ00AL               MOVE "Y"                    TO SWIERR OF WORKER
ZZ00AL               MOVE I3 OF WORKER           TO SWIMAX OF WORKER
ZZ00AL               PERFORM REWRITE-AGD06 THRU REWRITE-AGD06-FN
ZZ00AL            ELSE
ZZ00AL               MOVE "N"                    TO SWIAMT OF WORKER
ZZ00AL            END-IF
ZZ00AL         END-IF
ZZ00AL
ZZ00AL         MOVE "Y"                    TO SWIZER OF WORKER
ZZ00AL         MOVE "N"                    TO SWITOT OF WORKER
ZZ00AL         MOVE "0"                    TO I3     OF WORKER
ZZ00A0         MOVE DEDTOT OF ZSL04-01     TO DEDTOT OF WORKER
ZZ00A0      END-IF

            IF TYPROW OF ZSL04-01 NOT = "0"
ZZ00AL         MOVE "N"                    TO SWIZER OF WORKER
ZZ00AL         ADD 1 TO I3 OF WORKER 
ZZ00AL         GIVING I3 OF WORKER

      * Check that repayment month is format YYYYMM
      *
              PERFORM CHECK-RPYMTH THRU CHECK-RPYMTH-FN

              IF SWIERR OF WORKER = "Y"
                PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
                @READNX,ZSL04-01,XX
                GO LOOP-REC-FN 
              END-IF
              MOVE NUMMEM OF ZSL04-01       TO NUMCPT OF WORKER
              MOVE DEDIND OF ZSL04-01       TO MONMVT-ANG OF WORKER
ZZ00A0        MOVE DEDIND OF ZSL04-01       TO DEDIND OF WORKER

ZZ00A0*To check if Total amount received is less than amount to be paid.
ZZ00AA*ZZ00A0        IF DEDTOT OF WORKER NOT = MONMVT-ANG OF WORKER
ZZ00AA        IF DEDTOT OF WORKER < MONMVT-ANG OF WORKER
ZZ00A0           MOVE DEDTOT OF WORKER      TO MONMVT-ANG OF WORKER
ZZ00A0        END-IF
ZZ00A0
ZZ00A0

ZZ0088        MOVE SPACES                   TO NUMCPT-NEW OF WORKER
ZZ0088        STRING  NUMIDT OF ZSL04-01
ZZ0088                TYPDED OF ZSL04-01
ZZ0088                NUMMEM OF ZSL04-01
ZZ0088           DELIMITED BY SPACES INTO NUMCPT-NEW OF WORKER
ZZ0088        END-STRING
              COMPUTE MONMVT OF WORKER = MONMVT-ANG OF WORKER / 100
              END-COMPUTE

ZZ0088*       PERFORM MAPPING THRU MAPPING-FN 
ZZ0088        PERFORM READ-ZZ4 THRU READ-ZZ4-FN
              IF SWIERR OF WORKER ="Y"
                 PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
              ELSE
                 PERFORM LUMP-SUM    THRU LUMP-SUM-FN
              END-IF 
            END-IF


              @READNX,ZSL04-01,XX

      *Bendahari File
         WHEN "BEN"


            IF TYPREC OF ZSD04-01 NOT = "T"

      * Check that repayment month is format YYYYMM
      *
              PERFORM CHECK-RPYMTH THRU CHECK-RPYMTH-FN

              IF SWIERR OF WORKER = "Y"
                PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
                @READNX,ZSD04-01,XX
                GO LOOP-REC-FN 
              END-IF

              MOVE NUMCPT OF ZSD04-01    TO NUMCPT OF WORKER
ZZ0088        MOVE SPACES                   TO NUMCPT-NEW OF WORKER
ZZ0088        STRING  NUMIDT     OF ZSD04-01
ZZ0088                TYPDED-LOA OF ZSD04-01
ZZ008G                NUMCPT     OF ZSD04-01
ZZ0088           DELIMITED BY "  "  INTO NUMCPT-NEW OF WORKER
ZZ0088        END-STRING
nbe   *       display "nbe numcpt zsd04 = " NUMCPT OF ZSD04-01
nbe   *       display "nbe numcpt work  = " NUMCPT OF WORKER
              @MONTAN,"I","4", MONMVT OF WORKER,\
              RPYAMT OF ZSD04-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"            TO MONMVT OF WORKER   
              END-IF

ZZ0088*       PERFORM MAPPING THRU MAPPING-FN 
ZZ0088        PERFORM READ-ZZ4 THRU READ-ZZ4-FN
nbe   *       display "after received : " SWIERR OF WORKER

              IF SWIERR OF WORKER ="Y"
                 PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
nbe   *       display "after received 2 : " SWIERR OF WORKER
              ELSE
nbe   *       display "after received : lump sum " 
                 PERFORM LUMP-SUM    THRU LUMP-SUM-FN
nbe   *       display "after received : lump sum after"
              END-IF
            END-IF
  
              @READNX,ZSD04-01,XX

      *Other files formats
         WHEN "OTH"
  
      * Check that repayment month is format YYYYMM
      *
              PERFORM CHECK-RPYMTH THRU CHECK-RPYMTH-FN

              IF SWIERR OF WORKER = "Y"
                PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
                @READNX,ZSD05-01,XX
                GO LOOP-REC-FN 
              END-IF

      * Check that the department code is a mnemonic in table zz164
      *
              @TAR1,"164",DEPCOD OF ZSD05-01,"01","1"," ",XX
              IF CODRET OF TAR1 NOT = "00"
                MOVE "Y"                 TO SWIERR OF WORKER
                MOVE "05"                TO CODERR OF WORKER
                PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
                @READNX,ZSD05-01,XX
                GO LOOP-REC-FN 
              END-IF 

              MOVE NUMCPT OF ZSD05-01    TO NUMCPT OF WORKER
ZZ0088        MOVE SPACES                   TO NUMCPT-NEW OF WORKER
ZZ0088        STRING  IDTCLI OF ZSD05-01
ZZ0088                NUMCPT OF ZSD05-01
ZZ0088           DELIMITED BY SPACES INTO NUMCPT-NEW OF WORKER
ZZ0088        END-STRING

              @MONTAN,"I","4", MONMVT OF WORKER,\
              MONMVT OF ZSD05-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"            TO MONMVT OF WORKER
              END-IF

+jhc  *       display "JHC MONMVT ="MONMVT OF WORKER

ZZ0088*       PERFORM MAPPING THRU MAPPING-FN 
ZZ0088        PERFORM READ-ZZ4 THRU READ-ZZ4-FN

              IF SWIERR OF WORKER ="Y"
                 PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
              ELSE
                 PERFORM LUMP-SUM    THRU LUMP-SUM-FN
              END-IF

              @READNX,ZSD05-01,XX
        END-EVALUATE.


        LOOP-REC-FN.
      *-------------*
           EXIT.
       
ZZ0088* MAPPING.
ZZ0088*---------*
ZZ0088*    
ZZ0088*    @TAR1,"ZZ1",NUMCPT OF WORKER,"01","1",,XX.
ZZ0088*    IF CODRET OF TAR1 NOT = "00"
ZZ0088*      MOVE SPACES                       TO CDD01-01
ZZ0088*      MOVE NUMCPT OF WORKER             TO NUMCPT OF CDD01-01
ZZ0088*      PERFORM READ-CDD01 THRU READ-CDD01-FN
ZZ0088*    ELSE
ZZ0088*      MOVE "N"                        TO SWIERR OF WORKER
ZZ0088*      MOVE ZONTBL OF TAR1             TO NUMCPT-THA OF WORKER
ZZ0088*      MOVE SPACES                     TO CDD01-01
ZZ0088*      MOVE NUMCPT-THA OF WORKER       TO NUMCPT OF CDD01-01
ZZ0088*      PERFORM READ-CDD01 THRU READ-CDD01-FN
ZZ0088*    END-IF.
ZZ0088*
ZZ0088*
ZZ0088* MAPPING-FN.
ZZ0088*------------*
ZZ0088*    EXIT.


        READ-CDD01.
      *------------*

ZM0018     MOVE NUMCPT OF WORKER TO ACCNUM OF WORKER.
ZM0018       IF ACCNUM-FIR OF WORKER = "999"
ZM0018          MOVE 1             TO MLTSOC     OF CW-ITF
ZM0018          ELSE
ZM0018          IF ACCNUM-FIR OF WORKER = "399"
ZM0018             MOVE 2           TO MLTSOC     OF CW-ITF
ZM0018          END-IF
ZM0018       END-IF.
ZM0018
           @READZ,"1",CDD01-01,XX.
AKHAKH     display "-----------AKH company = " MLTSOC OF CW-ITF
           IF NOT ACCESS-OK
             MOVE "Y"                        TO SWIERR OF WORKER 
             MOVE "01"                       TO CODERR OF WORKER
           ELSE
             MOVE "N"                        TO SWIERR OF WORKER
             MOVE NUMCPT OF CDD01-01         TO NUMCPT-THA OF WORKER
AKHAKH     display "-----------AKH numcpt  = " NUMCPT OF CDD01-01
           END-IF.

        READ-CDD01-FN.
      *---------------*
           EXIT.


ZZ0088  READ-ZZ4.
ZZ0088*------------*
ZZ0088
nbenbe*    display "nbe read zz4 : " NUMCPT-NEW OF WORKER
ZZ0088     @TAR1,"ZZ4",NUMCPT-NEW OF WORKER,"01","1",,XX.
ZZ0088     IF CODRET OF TAR1 NOT = "00"
ZZ008G        MOVE SPACES                        TO TAD01-01
ZZ008G        MOVE "ZZ4"                         TO NUMTBL OF TAD01-01
ZZ008G       EVALUATE NOMFIC OF ZST005
ZZ008G        WHEN "ANG"
ZZ008G           STRING  NUMIDT OF ZSL04-01
ZZ008G                   TYPDED OF ZSL04-01
ZZ008G                   NUMMEM OF ZSL04-01
ZZ008G           DELIMITED BY SPACES INTO ARGTBL OF TAD01-01  
ZZ008G           END-STRING
ZZ008G        WHEN "BEN"
ZZ008G           STRING  NUMIDT     OF ZSD04-01
ZZ008G                   TYPDED-LOA OF ZSD04-01
ZZ008G           DELIMITED BY SPACES INTO ARGTBL OF TAD01-01  
ZZ008G           END-STRING
ZZ008G        WHEN "OTH"
ZZ008G           STRING  IDTCLI OF ZSD05-01
ZZ008G                   NUMCPT OF ZSD05-01
ZZ008G           DELIMITED BY SPACES INTO ARGTBL OF TAD01-01   
ZZ008G        END-STRING
ZZ008G       END-EVALUATE
ZZ008G        MOVE "N"                           TO SWIYES OF WORKER
nbe   *       display "START on ZZ4 : " ARGTBL OF TAD01-01
ZZ008G        @STARTZ,"1","==",TAD01-01,XX
ZZ008G
ZZ008G        PERFORM UNTIL NOT ACCESS-OK
ZZ008G        OR SWIYES OF WORKER = "Y"
ZZ008G             @READNX,TAD01-01,XX
ZZ008G             IF LIBEL1 OF TAD01-01 = NUMCPT OF WORKER
ZZ008G                MOVE ZONTBL OF TAD01-01 TO NUMCPT-THA OF WORKER
ZZ008G                MOVE "Y"                TO SWIYES OF WORKER 
nbenbe*            display "nico found in start : " ARGTBL OF TAD01-01
ZZ008G             END-IF
ZZ008G        END-PERFORM
ZZ008G
ZZ008G        IF SWIYES OF WORKER = "Y"
ZZ008G           GO READ-ZZ4-FN
ZZ008G        ELSE 
nbenbe     display "nbe fail zz4 read z1 : " NUMCPT OF WORKER
ZZ0088           @TAR1,"ZZ1",NUMCPT OF WORKER,"01","1",,XX
ZZ0088           IF CODRET OF TAR1 NOT = "00"
nbenbe     display "nbe fail zz4 read CD : " NUMCPT OF WORKER
ZZ0088              MOVE SPACES                       TO CDD01-01
ZZ0088              MOVE NUMCPT OF WORKER             TO NUMCPT OF CDD01-01
ZZ0088              PERFORM READ-CDD01 THRU READ-CDD01-FN
ZZ0088           ELSE
nbenbe     display "AKH OK READ ZZ1      : " NUMCPT OF WORKER
ZZ0088              MOVE "N"                        TO SWIERR OF WORKER
ZZ0088              MOVE ZONTBL OF TAR1             TO NUMCPT-THA OF WORKER
ZZ0088              MOVE SPACES                     TO CDD01-01
ZZ0088              MOVE NUMCPT-THA OF WORKER       TO NUMCPT OF CDD01-01
AKHAKH              MOVE NUMCPT-THA OF WORKER       TO NUMCPT OF WORKER
AKHAKH     display "AKH OK READ ZZ1,NUMCPT-THA=" NUMCPT-THA OF WORKER
AKHAKH     display "AKH OK READ ZZ1,CDD01     =" NUMCPT OF CDD01-01
ZZ0088              PERFORM READ-CDD01 THRU READ-CDD01-FN
ZZ0088           END-IF 
ZZ008G        END-IF

ZZ0088     ELSE
ZZ0088       MOVE "N"                        TO SWIERR OF WORKER
ZZ0088       MOVE ZONTBL OF TAR1             TO NUMCPT-THA OF WORKER
AKHAKH*      DISPLAY "@@@@ NUMCPT-THA= " NUMCPT-THA Of WORKER
ZM0018       MOVE MLTSOC OF CW-ITF TO MLTSOC-BCK OF WORKER
AKHAKH*       display "-----------AKH MLTSOC  = " MLTSOC OF CW-ITF
ZM0018       MOVE NUMCPT-THA OF WORKER TO ACCNUM OF WORKER
AKHAKH*      display "-----------nbe ACCNUM WORKER = " ACCNUM OF WORKER
AKHAKH*      display "-----nbe ACCNUM-FIR WORKER = " ACCNUM-FIR OF WORKER
ZM0018       IF ACCNUM-FIR OF WORKER = "999"
ZM0018          MOVE 1             TO MLTSOC     OF CW-ITF
ZM0018          ELSE
ZM0018          IF ACCNUM-FIR OF WORKER = "399"
ZM0018             MOVE 2           TO MLTSOC     OF CW-ITF
ZM0018          END-IF
ZM0018       END-IF
AKHAKH*      display "------FINAL----MLTSOC  = " MLTSOC OF CW-ITF
ZZ0088     END-IF.
ZZ0088
ZZ0088  READ-ZZ4-FN.
ZZ0088*---------------*
ZZ0088     EXIT.



        WRITE-AGD06.
      *-------------*
AKHAKH     DISPLAY "WRITE-AGD06mSWIERR= " SWIERR OF WORKER.
AKHAKH     DISPLAY "WRITE-AGE06,NUMCPT-THA= " NUMCPT-THA OF WORKER.
      *obtain NUMSEQ
         INITIALIZE AGD06-01      

         MOVE REFOPN OF WORKER (1:10) TO REFLOT     OF AGD06-01.

         MOVE ALL ZERO TO NUMSEQ OF WORKER.

         @MAX,"1","==",AGD06-01,XX.

         IF ACCESS-OK
             MOVE NUMTEC OF AGD06-01 TO NUMSEQ OF WORKER
         END-IF.

         @FCRD,"03",,NUMSEQ OF WORKER,"6",,XX.

           IF CODRET OF FCRD NOT = "00"
               @CWERR,ZST005,"ZST00502","REFOPN OF WORKER",\
                                ,"I","1","5","Y","13"
           END-IF.

           IF SWIDEP OF FCRD = "Y"
               @CWERR,ZST005,"ZST00502","SWIDEP OF FCRD",\
                            ,"I","1","5","Y","14"
           END-IF

           MOVE BASE35 OF FCRD      TO NUMSEQ OF WORKER.


      *--> Data that is to be written into AGD06

         IF SWIERR OF WORKER = "Y"

           MOVE CODERR OF WORKER     TO MOTRFU     OF AGD06-01
           MOVE "2001"               TO STAEVT     OF AGD06-01
           IF CODERR OF WORKER NOT = "01" 
             IF NOMFIC OF ZST005 = "ANG"
               MOVE  NUMCPT-THA OF WORKER  TO NUMMEM OF ZSL04-01
             END-IF
             IF NOMFIC OF ZST005 = "BEN"
               MOVE  NUMCPT-THA OF WORKER  TO NUMCPT OF ZSD04-01
             END-IF
             IF NOMFIC OF ZST005 = "OTH"
               MOVE  NUMCPT-THA OF WORKER  TO NUMCPT OF ZSD05-01
             END-IF
           END-IF
ZZ005T       IF NOMFIC OF ZST005 = "ANG"
ZZ005T         @MONTAN,"O","4", MONMVT OF WORKER,\
ZZ005T         AMOTHA OF ZSL04-01,,XX
ZZ005T       END-IF
         ELSE

           MOVE "00"                 TO MOTRFU     OF AGD06-01
           MOVE "2000"               TO STAEVT     OF AGD06-01


           EVALUATE NOMFIC OF ZST005
           WHEN "ANG"

             MOVE  NUMCPT-THA OF WORKER  TO NUMMEM OF ZSL04-01

             @MONTAN,"O","4", MONMVT OF WORKER,\
              AMOTHA OF ZSL04-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"            TO AMOTHA OF ZSL04-01
              END-IF


           WHEN "BEN"   
              MOVE  NUMCPT-THA OF WORKER  TO NUMCPT OF ZSD04-01
+jhc          MOVE  RPYAMT OF ZSD04-01    TO AMOTHA OF ZSD04-01 

              @MONTAN,"O","4", MONMVT OF WORKER,\
              AMOTHA OF ZSD04-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"            TO AMOTHA OF ZSD04-01
              END-IF

           WHEN "OTH"   
              MOVE  NUMCPT-THA OF WORKER  TO NUMCPT OF ZSD05-01

              @MONTAN,"O","4", MONMVT OF WORKER,\
              MONMVT OF ZSD05-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"            TO MONMVT OF ZSD05-01
              END-IF

           END-EVALUATE

         END-IF.

         MOVE REFOPN OF WORKER (1:10) TO REFLOT    OF AGD06-01.
         MOVE NUMSEQ OF WORKER        TO NUMTEC    OF AGD06-01.

         EVALUATE NOMFIC OF ZST005
         WHEN "ANG"
          MOVE  ZSL04-01              TO DONEVT    OF AGD06-01
         WHEN "BEN"   
          MOVE  ZSD04-01              TO DONEVT    OF AGD06-01
         WHEN "OTH"   
          MOVE  ZSD05-01              TO DONEVT    OF AGD06-01
         END-EVALUATE.

         MOVE TYPEVT OF ZST005        TO TYPEVT    OF AGD06-01.

ZZ00AL   MOVE REFLOT OF AGD06-01      TO REFLOT-TEM OF WORKER(I3).
ZZ00AL   MOVE NUMTEC OF AGD06-01      TO NUMTEC-TEM OF WORKER(I3).
         
         @WRITE,AGD06-01,XX.
          IF NOT ACCESS-OK
             @CWERR,ZST005,"ZST00503","AGD06-01",\
                           ,"I","1","5","Y","15"
          END-IF.
      
        WRITE-AGD06-FN.
      *----------------*
           EXIT.


ZZ00AL  REWRITE-AGD06.
ZZ00AL*---------------*
ZZ00AL
ZZ00AL     PERFORM VARYING I3 FROM 1 BY 1
ZZ00AL        UNTIL I3 > SWIMAX OF WORKER
ZZ00AL     INITIALIZE AGD06-01 
ZZ00AL     MOVE REFLOT-TEM OF WORKER(I3) TO REFLOT OF AGD06-01 
ZZ00AL     MOVE NUMTEC-TEM OF WORKER(I3) TO NUMTEC OF AGD06-01 
ZZ00AL     @READZ,"1",AGD06-01,XX 
ZZ00AL        IF ACCESS-OK
ZZ00AL           IF MOTRFU OF AGD06-01 = "00" 
ZZ00AL           MOVE "07"               TO MOTRFU OF AGD06-01
ZZ00AL           MOVE "2001"             TO STAEVT OF AGD06-01
ZZ00AL           @REWRITE,AGD06-01,XX 
ZZ00AL              IF NOT ACCESS-OK
ZZ00AL              @CWERR,ZST005,"ZST00503","AGD06-01",\
ZZ00AL                     ,"I","1","5","Y","15"
ZZ00AL              END-IF
ZZ00AL           END-IF
ZZ00AL        END-IF
ZZ00AL     END-PERFORM. 
ZZ00AL
ZZ00AL  REWRITE-AGD06-FN.
      *----------------*
           EXIT.


        LUMP-SUM.
      *----------*

        MOVE NUMCPT-THA OF WORKER TO NUMCPT-CDD OF WORKER.

ZZ005T* Read the initial (before migratio)n amount for monthly repayment
ZZ005T  PERFORM CHECK-INIT-MONRBT THRU CHECK-INIT-MONRBT-FN.

ZZ005T  IF MONMVT OF WORKER = MONRBT-TOT OF WORKER

ZZ00AB  EVALUATE NOMFIC OF ZST005
ZZ00AB  WHEN "ANG"
ZZ00AB* To reduce the amount paid from total amount received.
ZZ00AB  COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100 
ZZ00AB
ZZ00AB  SUBTRACT MONMVT OF WORKER
ZZ00AB   FROM DEDTOT-1 OF WORKER
ZZ00AB  GIVING DEDTOT-1 OF WORKER 
ZZ00AB
ZZ00AB  IF (DEDTOT-1 OF WORKER < 0 OR DEDTOT-1 OF WORKER = 0)
ZZ00AL        MOVE "Y"               TO SWITOT OF WORKER
ZZ00AB     COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100
ZZ00AB     MOVE DEDTOT-1 OF WORKER TO MONMVT OF WORKER
ZZ00AL     MOVE "0"                TO DEDTOT OF WORKER
ZZ00AB  END-IF 
ZZ00AB
ZZ00AL  IF DEDTOT-1 Of WORKER > 0
ZZ00AL     IF SWITOT OF WORKER NOT = "Y"
ZZ00AB        COMPUTE DEDTOT OF WORKER = DEDTOT-1 OF WORKER * 100
ZZ00AL     END-IF
ZZ00AL  END-IF
ZZ00AB  END-EVALUATE

ZZ005T   MOVE "N"             TO SWIERR OF WORKER
ZZ005T   PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
ZZ005T   GO LUMP-SUM-FN
ZZ005T  END-IF.

        PERFORM START-CDD33 THRU START-CDD33-FN. 

ZZ00AL*ZZ00AB  EVALUATE NOMFIC OF ZST005
ZZ00AL*ZZ00AB  WHEN "ANG"
ZZ00AL*ZZ00AB* To reduce the amount paid from total amount received.
ZZ00AL*ZZ00AB  COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100  
ZZ00AL*ZZ00AB
ZZ00AL*ZZ00AB  SUBTRACT MONMVT OF WORKER
ZZ00AL*ZZ00AB   FROM DEDTOT-1 OF WORKER
ZZ00AL*ZZ00AB  GIVING DEDTOT-1 OF WORKER  
ZZ00AL*ZZ00AB
ZZ00AL*ZZ00AB  IF (DEDTOT-1 OF WORKER < 0 OR DEDTOT-1 OF WORKER = 0)
ZZ00AL*ZZ00AL     IF DEDTOT-1 OF WORKER < 0
ZZ00AL*ZZ00AL        MOVE "Y"               TO SWITOT OF WORKER
ZZ00AL*ZZ00AL     END-IF
ZZ00AL*ZZ00AB     COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100
ZZ00AL*ZZ00AB     MOVE DEDTOT-1 OF WORKER TO MONMVT OF WORKER
ZZ00AL*ZZ00AL     MOVE "0"                TO DEDTOT OF WORKER
ZZ00AL*ZZ00AB  END-IF  
ZZ00AL*ZZ00AB
ZZ00AL*ZZ00AB  END-EVALUATE.

        IF MONMVT OF WORKER = MONRBT-TOT OF WORKER

ZZ00AB  EVALUATE NOMFIC OF ZST005
ZZ00AB  WHEN "ANG"

ZZ00AL* To reduce the amount paid from total amount received.
ZZ00AL  COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100  
ZZ00AL
ZZ00AL  SUBTRACT MONMVT OF WORKER
ZZ00AL   FROM DEDTOT-1 OF WORKER
ZZ00AL  GIVING DEDTOT-1 OF WORKER  
ZZ00AL
ZZ00AL  IF (DEDTOT-1 OF WORKER < 0 OR DEDTOT-1 OF WORKER = 0)
+AKH01*ZZ00AL     IF DEDTOT-1 OF WORKER < 0
ZZ00AL        MOVE "Y"               TO SWITOT OF WORKER
+AKH01*ZZ00AL     END-IF
ZZ00AL     COMPUTE DEDTOT-1 OF WORKER = DEDTOT OF WORKER / 100
ZZ00AL     MOVE DEDTOT-1 OF WORKER TO MONMVT OF WORKER
ZZ00AL     MOVE "0"                TO DEDTOT OF WORKER
ZZ00AL  END-IF  

ZZ00AL    IF DEDTOT-1 OF WORKER > 0
ZZ00AL     IF SWITOT OF WORKER NOT = "Y"
ZZ00AB        COMPUTE DEDTOT OF WORKER = DEDTOT-1 OF WORKER * 100
ZZ00AL     END-IF
ZZ00AL    END-IF
ZZ00AB  END-EVALUATE


          MOVE "N"            TO SWIERR OF WORKER
          PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
        ELSE
          PERFORM START-ZZ2 THRU START-ZZ2-FN
          IF SWIERR OF WORKER = "Y"
            PERFORM WRITE-AGD06 THRU WRITE-AGD06-FN
          END-IF
        END-IF.

        LUMP-SUM-FN.
      *-------------*
           EXIT.

ZZ005T CHECK-INIT-MONRBT.
ZZ005T*------------------*
ZZ005T
ZZ005T* Get the monthly repayment before migration  
ZZ005T*
ZZ005T  MOVE SPACES                  TO ZSD02-01.
ZZ005T  MOVE NUMCPT-CDD OF WORKER    TO NUMCPT OF ZSD02-01.
ZZ005T
AKHAKH  MOVE NUMCPT-CDD Of WORKER TO ACCNUM Of WORKER.
AKHAKH  IF ACCNUM-FIR OF WORKER = "999"
AKHAKH     MOVE 1             TO MLTSOC     OF CW-ITF
AKHAKH  ELSE
AKHAKH     IF ACCNUM-FIR OF WORKER = "399"
AKHAKH        MOVE 2           TO MLTSOC     OF CW-ITF
AKHAKH     END-IF
AKHAKH  END-IF.
AKHAKH  DISPLAY "AKH-NUMCPT ZSD02= " NUMCPT OF ZSD02-01.
AKHAKH  DISPLAY "AKH-COMPANY CODE= " MLTSOC OF CW-ITF.
ZZ005T  @READ,"1",ZSD02-01,XX.
ZZ005T  IF NOT ACCESS-OK
ZZ005T     MOVE SPACES               TO ZONLIB OF WORKER
ZZ005T     STRING  "ZSD02 / "
ZZ005T             NUMCPT OF ZSD02-01
AKHAKH             MLTSOC OF CW-ITF
ZZ005T           DELIMITED BY SIZE INTO ZONLIB OF WORKER
ZZ005T     END-STRING
ZZ005T     @CWERR,ZST005,"XXXX0003",ZONLIB OF WORKER,,"I","1",\
ZZ005T        "0","Y","10"
ZZ005T  END-IF.
ZZ005T
ZZ005T  MOVE MONRBT-ORI OF ZSD02-01 TO MONRBT-TOT OF WORKER
ZZ005T  PERFORM CALL-FCRP THRU CALL-FCRP-FN.
ZZ005T
ZZ005T CHECK-INIT-MONRBT-FN.
ZZ005T*---------------------*
ZZ005T     EXIT.

        START-CDD33.
      *-------------*

ZZ005T  MOVE "N"                   TO SWIFIN-RBT OF WORKER.

ZM0018  MOVE NUMCPT-CDD Of WORKER TO ACCNUM Of WORKER.
ZM0018  IF ACCNUM-FIR OF WORKER = "999"
ZM0018     MOVE 1             TO MLTSOC     OF CW-ITF
ZM0018  ELSE
ZM0018     IF ACCNUM-FIR OF WORKER = "399"
ZM0018        MOVE 2           TO MLTSOC     OF CW-ITF
ZM0018     END-IF
ZM0018  END-IF.

        INITIALIZE CDD33-01.

        MOVE NUMCPT-CDD OF WORKER  TO NUMCPT OF CDD33-01.

        @START,"3","==",CDD33-01,XX.
        IF ACCESS-OK
          @READNX,CDD33-01,XX
          PERFORM UNTIL NOT ACCESS-OK 
ZZ005T*   OR SWICAP OF CDD33-01 = "Y"
ZZ005T    OR SWIFIN-RBT OF WORKER = "Y"

           IF SWICAP OF CDD33-01 = "Y"
             ADD MONRBT-INT OF CDD33-01 TO MONRBT-CAP OF CDD33-01
              GIVING MONRBT-TOT OF WORKER
            END-ADD
ZZ005T      MOVE "Y"                    TO SWIFIN-RBT OF WORKER
           END-IF
           @READNX,CDD33-01,XX
         END-PERFORM
        ELSE
           MOVE SPACES               TO ZONLIB OF WORKER
           MOVE "CDD33"              TO ZONLIB OF WORKER
           @CWERR,ZST005,"XXXX0240",ZONLIB OF WORKER,,"I","1",\
              "0","Y","01"
           GO PRG-END
        END-IF.
      * Get the insurance part to be refunded every month
      *  
ZZ005T* Read has already been done on ZSD02
ZZ005T* MOVE SPACES                  TO ZSD02-01.
ZZ005T* MOVE NUMCPT-CDD OF WORKER    TO NUMCPT OF ZSD02-01.
ZZ005T*
ZZ005T* @READ,"1",ZSD02-01,XX.
ZZ005T* IF NOT ACCESS-OK
ZZ005T*    MOVE SPACES               TO ZONLIB OF WORKER
ZZ005T*    STRING  "ZSD02 / "  
ZZ005T*            NUMCPT OF ZSD02-01
ZZ005T*          DELIMITED BY SIZE INTO ZONLIB OF WORKER
ZZ005T*    END-STRING
ZZ005T*    @CWERR,ZST005,"XXXX0003",ZONLIB OF WORKER,,"I","1",\
ZZ005T*       "0","Y","10"
ZZ005T* END-IF.

      * We add the portion of insurance to be repaid every month to 
      * loan monthly repayment
      *
        COMPUTE MONRBT-TOT OF WORKER = MONRBT-TOT OF WORKER +
                            ( MONCHR OF ZSD02-01(2) / 12)
        END-COMPUTE.

TMPUAT  PERFORM CALL-FCRP THRU CALL-FCRP-FN.

        START-CDD33-FN.
      *----------------*
           EXIT.


        START-ZZ2.
      *-----------*

         MOVE "N"                   TO SWISTP-ZZ2 OF WORKER.

         PERFORM VARYING I1 FROM 1 BY 1         
         UNTIL I1 = 99 
          MOVE SPACES               TO NUMCPT-TAB OF WORKER(I1)
          MOVE SPACES               TO MONTB1-TAB OF WORKER(I1)
         END-PERFORM.

         MOVE ZEROES                TO MONRPY     OF WORKER.

         MOVE 0 TO I1 OF WORKER.

         MOVE SPACES                TO TAD01-01.
         MOVE NUMCPT-THA OF WORKER  TO ARGTBL     OF TAD01-01.
         MOVE "ZZ2"                 TO NUMTBL     OF TAD01-01.

         @START,"1","GE",TAD01-01,XX.
         IF ACCESS-OK
           @READNX,TAD01-01,XX
         ELSE
           MOVE "Y"                               TO SWIERR OF WORKER
           MOVE "02"                              TO CODERR OF WORKER
           GO START-ZZ2-FN
         END-IF.

      *-->Loop
          
         PERFORM LOOP-ZZ2 THRU LOOP-ZZ2-FN
                       UNTIL NOT ACCESS-OK
                       OR SWISTP-ZZ2 OF WORKER = "Y"
                       OR SWIERR     OF WORKER = "Y".



ZZ00A0*  IF MONRPY  OF WORKER NOT = MONMVT OF WORKER
ZZ00A0   IF MONRPY  OF WORKER > MONMVT OF WORKER
         AND SWIERR OF WORKER NOT = "Y"
           MOVE "Y"                  TO SWIERR OF WORKER
           MOVE "04"                 TO CODERR OF WORKER
ZZ005T     IF SWISTP-ZZ2 OF WORKER = "Y"
ZZ005T       MOVE "02"               TO CODERR OF WORKER
ZZ005T     END-IF
         END-IF.

ZZ00B0   EVALUATE NOMFIC OF ZST005
ZZ00B0   WHEN "OTH"
ZZ00B0   IF MONRPY OF WORKER NOT = MONMVT OF WORKER
ZZ00B0     MOVE "Y"                  TO SWIERR OF WORKER
ZZ00B0     MOVE "07"                 TO CODERR OF WORKER
ZZ00B0   END-IF
ZZ00B0
ZZ00B0   WHEN "BEN"
ZZ00B0   IF MONRPY OF WORKER NOT = MONMVT OF WORKER
ZZ00B0     MOVE "Y"                  TO SWIERR OF WORKER
ZZ00B0     MOVE "07"                 TO CODERR OF WORKER
ZZ00B0   ELSE
ZZ00B0* to remove the wrong dedtot for Bendahari...
ZZ00B0     COMPUTE DEDTOT OF WORKER = MONMVT OF WORKER * 100
ZZ00B0   END-IF
ZZ00B0   END-EVALUATE.

ZZ005T   IF SWISTP-ZZ2 OF WORKER = "Y"
ZZ005T     AND MONRPY OF WORKER = ZEROES
ZZ005T     MOVE "Y"                  TO SWIERR OF WORKER
ZZ005T     MOVE "02"                 TO CODERR OF WORKER
ZZ005T   END-IF.

ZZ00A0   MULTIPLY MONRPY OF WORKER BY 100
ZZ00A0        GIVING MONRPY OF WORKER.
ZZ00A0
ZZ00A0        SUBTRACT MONRPY        OF WORKER
ZZ00A0                 FROM DEDTOT   OF WORKER
ZZ00A0                 GIVING DEDTOT OF WORKER.

      * Write as many AGD06 as the I1 number of elements 
         IF SWIERR OF WORKER NOT = "Y" 
          PERFORM VARYING I2 FROM 1 BY 1 
          UNTIL I2 > I1
            PERFORM WRITE-AGD06-TAB THRU WRITE-AGD06-TAB-FN
          END-PERFORM
         END-IF.

        START-ZZ2-FN.
      *--------------*
           EXIT.


        LOOP-ZZ2.
      *----------*
         MOVE ARGTBL OF TAD01-01 (14:12)  TO NUMCPT-CDD OF WORKER.
         MOVE ARGTBL OF TAD01-01 (1:12)   TO NUMCPT-TST OF WORKER.
         IF NUMCPT-TST OF WORKER NOT = NUMCPT-THA OF WORKER
           MOVE "Y"                       TO SWISTP-ZZ2 OF WORKER
           GO LOOP-ZZ2-FN
         END-IF.
TMPUAT*  PERFORM START-CDD33 THRU START-CDD33-FN.
TMPUAT*  IF MONRBT-TOT OF WORKER NOT = MONTB1 OF TAD01-01
TMPUAT*    MOVE "Y"                       TO SWIERR     OF WORKER
TMPUAT*    MOVE "03"                      TO CODERR     OF WORKER  
TMPUAT*    GO LOOP-ZZ2-FN
TMPUAT*  END-IF.

         ADD 1 TO I1 OF WORKER.
         MOVE NUMCPT-CDD OF WORKER TO NUMCPT-TAB OF WORKER (I1)
         MOVE MONTB1 OF TAD01-01   TO MONTB1-TAB OF WORKER (I1)
         ADD MONTB1 OF TAD01-01    TO MONRPY     OF WORKER.
  
         @READNX,TAD01-01,XX.

        LOOP-ZZ2-FN.
      *-------------*
           EXIT.


       WRITE-AGD06-TAB.
      *----------------*

      *obtain NUMSEQ
         INITIALIZE AGD06-01
         MOVE REFOPN OF WORKER (1:10) TO REFLOT     OF AGD06-01.

         MOVE ALL ZERO TO NUMSEQ OF WORKER.

         @MAX,"1","==",AGD06-01,XX.

         IF ACCESS-OK
             MOVE NUMTEC OF AGD06-01 TO NUMSEQ OF WORKER
         END-IF.

         @FCRD,"03",,NUMSEQ OF WORKER,"6",,XX.

           IF CODRET OF FCRD NOT = "00"
               @CWERR,ZST005,"ZST00502","REFOPN OF WORKER",\
                                ,"I","1","5","Y","13"
           END-IF.

           IF SWIDEP OF FCRD = "Y"
               @CWERR,ZST005,"ZST00502","SWIDEP OF FCRD",\
                            ,"I","1","5","Y","14"
           END-IF

           MOVE BASE35 OF FCRD      TO NUMSEQ OF WORKER.


      *--> Data that is to be written into AGD06

           MOVE "00"                          TO MOTRFU OF AGD06-01.
           MOVE "2000"                        TO STAEVT OF AGD06-01.

           EVALUATE NOMFIC OF ZST005
           WHEN "ANG"
             MOVE  NUMCPT-TAB OF WORKER (I2)  TO NUMMEM OF ZSL04-01

             @MONTAN,"O","4",MONTB1-TAB OF WORKER(I2),\
              AMOTHA OF ZSL04-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"                 TO AMOTHA OF ZSL04-01
              END-IF

           WHEN "BEN"
             MOVE  NUMCPT-TAB OF WORKER (I2)  TO NUMCPT OF ZSD04-01

             @MONTAN,"O","4",MONTB1-TAB OF WORKER(I2),\
              AMOTHA OF ZSD04-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"                 TO AMOTHA OF ZSD04-01
              END-IF

           WHEN "OTH"
             MOVE  NUMCPT-TAB OF WORKER (I2)  TO NUMCPT OF ZSD05-01

             @MONTAN,"O","4",MONTB1-TAB OF WORKER(I2),\
              MONMVT OF ZSD05-01,,XX
              IF CODRET OF CWFRMT NOT = "00"
                 MOVE  "0.00"                 TO MONMVT OF ZSD05-01
              END-IF

           END-EVALUATE.


         MOVE REFOPN OF WORKER (1:10) TO REFLOT    OF AGD06-01.
         MOVE NUMSEQ OF WORKER        TO NUMTEC    OF AGD06-01.

         EVALUATE NOMFIC OF ZST005
         WHEN "ANG"
          MOVE  ZSL04-01              TO DONEVT    OF AGD06-01
         WHEN "BEN"
          MOVE  ZSD04-01              TO DONEVT    OF AGD06-01
         WHEN "OTH"
          MOVE  ZSD05-01              TO DONEVT    OF AGD06-01
         END-EVALUATE.

         MOVE TYPEVT OF ZST005        TO TYPEVT    OF AGD06-01.

ZZ00AL   MOVE REFLOT OF AGD06-01      TO REFLOT-TEM OF WORKER(I3).
ZZ00AL   MOVE NUMTEC OF AGD06-01      TO NUMTEC-TEM OF WORKER(I3).

         @WRITE,AGD06-01,XX.
          IF NOT ACCESS-OK
             @CWERR,ZST005,"ZST00503","AGD06-01",\
                           ,"I","1","5","Y","15"
          END-IF.


        WRITE-AGD06-TAB-FN.
      *--------------------*
           EXIT.

       CHECK-RPYMTH.
      *----------------*
  
         EVALUATE NOMFIC OF ZST005
      *Angkasa File
         WHEN "ANG"
            STRING DEDMTH OF ZSL04-01
                   "01"
                   INTO RPYMTH-INT OF WORKER
            END-STRING
      *Bendahari File
         WHEN "BEN"
            STRING RPYMTH OF ZSD04-01
                   "01"
                   INTO RPYMTH-INT OF WORKER
            END-STRING
      *Others
         WHEN "OTH"
            STRING RPYMTH OF ZSD05-01
                   "01"
                   INTO RPYMTH-INT OF WORKER
            END-STRING
        END-EVALUATE.

        @DATE,"O","0",RPYMTH-INT OF WORKER, RPYMTH-EXT OF WORKER,XX
        IF CODRET OF CWFRMT NOT = "00"
           MOVE "Y"                 TO SWIERR OF WORKER
           MOVE "06"                TO CODERR OF WORKER
        END-IF.

       CHECK-RPYMTH-FN.
      *------------------* 
           EXIT.


       CALL-FCRP.
      *----------*
           MOVE SPACES              TO FCRP.
           MOVE "04"                TO MDEAPE OF FCRP.
           MOVE DEVLCL OF XXXXV     TO ISODE1 OF FCRP.
           MOVE MONRBT-TOT OF WORKER TO MONTA1 OF FCRP.
           MOVE "Y"                 TO SWITRQ OF FCRP.

           CALL "FCRPR"  USING    FCRP
                                     CW-ITF
           IF CODRET OF FCRP NOT = "00"
              @CWERR,ZST005,"XXXX0195",,,\
                            "I","1","5","Y","11"
           END-IF.

           MOVE ZEROES TO MONRBT-TOT OF WORKER.
           MOVE MONTA2 OF FCRP      TO MONRBT-TOT OF WORKER.

       CALL-FCRP-FN.
      *-------------*
           EXIT.


      * =========================================
      * Methodological copy for Restarting handle
      * =========================================
      
           COPY RSTPNT.     
           
           EXIT.
