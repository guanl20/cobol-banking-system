*> ============================================================
      *> Program:    BANK-INTEREST
      *> Author:     Guan
      *> Date:       2025
      *> Purpose:    Calculates and applies monthly interest to all
      *>             active accounts. Skips frozen/inactive accounts.
      *>             Generates interest transaction records.
      *> ============================================================

       IDENTIFICATION DIVISION.
           PROGRAM-ID. BANK-INTEREST.
           AUTHOR. Guan.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "../data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT INTEREST-LOG
               ASSIGN TO "../data/interest-log.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-LOG-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE.
       COPY "../copybooks/ACCOUNT-RECORD.cpy".

       FD  INTEREST-LOG.
       COPY "../copybooks/TRANSACTION-RECORD.cpy".

       WORKING-STORAGE SECTION.
           01 WS-FILE-STATUS        PIC X(2)    VALUE SPACES.
               88 FILE-OK                       VALUE "00".
               88 END-OF-FILE                   VALUE "10".
           01 WS-LOG-STATUS         PIC X(2)    VALUE SPACES.
           01 WS-INTEREST-AMOUNT    PIC 9(9)V99 VALUE ZEROS.
           01 WS-TOTAL-INTEREST     PIC 9(11)V99 VALUE ZEROS.
           01 WS-ACCOUNTS-PROCESSED PIC 9(4)    VALUE ZEROS.
           01 WS-ACCOUNTS-SKIPPED   PIC 9(4)    VALUE ZEROS.
           01 WS-TXN-ID             PIC 9(10)   VALUE 2000000001.
           01 WS-DISP               PIC $9,999,999,999.99.

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           DISPLAY "===== MONTHLY INTEREST CALCULATION ====="
           DISPLAY SPACES
           OPEN INPUT ACCOUNT-FILE
           OPEN OUTPUT INTEREST-LOG
           PERFORM UNTIL END-OF-FILE
               READ ACCOUNT-FILE
               IF FILE-OK
                   PERFORM 1000-CALCULATE-INTEREST
               END-IF
           END-PERFORM
           CLOSE ACCOUNT-FILE
           CLOSE INTEREST-LOG
           PERFORM 2000-DISPLAY-SUMMARY
           DISPLAY "===== INTEREST CALCULATION COMPLETE ====="
           STOP RUN.

       1000-CALCULATE-INTEREST.
           IF AR-ACTIVE
               COMPUTE WS-INTEREST-AMOUNT ROUNDED =
                   AR-BALANCE * AR-INTEREST-RATE / 100 / 12
               ADD WS-INTEREST-AMOUNT TO WS-TOTAL-INTEREST
               ADD 1 TO WS-ACCOUNTS-PROCESSED
               MOVE WS-DISP TO WS-DISP
               MOVE AR-BALANCE TO WS-DISP
               DISPLAY "Account : " AR-ACCOUNT-ID
                       " | " AR-CUSTOMER-NAME
               DISPLAY "Balance : " WS-DISP
               MOVE WS-INTEREST-AMOUNT TO WS-DISP
               DISPLAY "Interest: " WS-DISP
                       " (Rate: " AR-INTEREST-RATE "%)"
               MOVE WS-TXN-ID        TO TR-TXN-ID
               MOVE AR-ACCOUNT-ID    TO TR-ACCOUNT-ID
               MOVE "I"              TO TR-TXN-TYPE
               MOVE WS-INTEREST-AMOUNT TO TR-AMOUNT
               MOVE 20250101         TO TR-DATE
               MOVE "C"              TO TR-STATUS
               MOVE "Monthly interest credit" TO TR-DESCRIPTION
               WRITE TRANSACTION-RECORD
               ADD 1 TO WS-TXN-ID
               DISPLAY SPACES
           ELSE
               ADD 1 TO WS-ACCOUNTS-SKIPPED
               DISPLAY "SKIPPED: " AR-CUSTOMER-NAME
                       " (Status: " AR-STATUS ")"
               DISPLAY SPACES
           END-IF.

       2000-DISPLAY-SUMMARY.
           DISPLAY "--- Interest Summary ---"
           DISPLAY "Accounts Processed : " WS-ACCOUNTS-PROCESSED
           DISPLAY "Accounts Skipped   : " WS-ACCOUNTS-SKIPPED
           MOVE WS-TOTAL-INTEREST TO WS-DISP
           DISPLAY "Total Interest Paid: " WS-DISP
           DISPLAY SPACES.