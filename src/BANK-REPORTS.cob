*> ============================================================
      *> Program:    BANK-REPORTS
      *> Author:     Guan
      *> Date:       2025
      *> Purpose:    Generates comprehensive banking reports:
      *>             - Full account summary report
      *>             - Account type breakdown
      *>             - Total assets under management
      *>             - Flagged/frozen account report
      *> ============================================================

       IDENTIFICATION DIVISION.
           PROGRAM-ID. BANK-REPORTS.
           AUTHOR. Guan.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "../data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

           SELECT REPORT-FILE
               ASSIGN TO "../reports/bank-report.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-RPT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE.
       COPY "../copybooks/ACCOUNT-RECORD.cpy".

       FD  REPORT-FILE.
       01  REPORT-LINE              PIC X(80).

       WORKING-STORAGE SECTION.
           01 WS-FILE-STATUS        PIC X(2)    VALUE SPACES.
               88 FILE-OK                       VALUE "00".
               88 END-OF-FILE                   VALUE "10".
           01 WS-RPT-STATUS         PIC X(2)    VALUE SPACES.
           01 WS-TOTAL-ASSETS       PIC 9(11)V99 VALUE ZEROS.
           01 WS-SAVINGS-TOTAL      PIC 9(11)V99 VALUE ZEROS.
           01 WS-CHECKING-TOTAL     PIC 9(11)V99 VALUE ZEROS.
           01 WS-INVESTMENT-TOTAL   PIC 9(11)V99 VALUE ZEROS.
           01 WS-SAVINGS-COUNT      PIC 9(4)    VALUE ZEROS.
           01 WS-CHECKING-COUNT     PIC 9(4)    VALUE ZEROS.
           01 WS-INVESTMENT-COUNT   PIC 9(4)    VALUE ZEROS.
           01 WS-FROZEN-COUNT       PIC 9(4)    VALUE ZEROS.
           01 WS-TOTAL-ACCOUNTS     PIC 9(4)    VALUE ZEROS.
           01 WS-DISP               PIC $9,999,999,999.99.
           01 WS-REPORT-LINE        PIC X(80)   VALUE SPACES.
           01 WS-BAL-DISP           PIC X(20)   VALUE SPACES.

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           DISPLAY "===== GENERATING BANK REPORTS ====="
           OPEN INPUT ACCOUNT-FILE
           OPEN OUTPUT REPORT-FILE
           PERFORM 1000-WRITE-HEADER
           PERFORM UNTIL END-OF-FILE
               READ ACCOUNT-FILE
               IF FILE-OK
                   PERFORM 2000-PROCESS-ACCOUNT
               END-IF
           END-PERFORM
           PERFORM 3000-WRITE-SUMMARY
           CLOSE ACCOUNT-FILE
           CLOSE REPORT-FILE
           DISPLAY "Report saved to: reports/bank-report.txt"
           DISPLAY "===== REPORT GENERATION COMPLETE ====="
           STOP RUN.

       1000-WRITE-HEADER.
           MOVE "================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE
           MOVE "     COBOL BANKING SYSTEM - ACCOUNT REPORT"
               TO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE
           MOVE "     Generated: 2025-01-01"
               TO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE
           MOVE "================================================"
               TO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE.

       2000-PROCESS-ACCOUNT.
           ADD 1 TO WS-TOTAL-ACCOUNTS
           ADD AR-BALANCE TO WS-TOTAL-ASSETS

           EVALUATE TRUE
               WHEN AR-SAVINGS
                   ADD AR-BALANCE TO WS-SAVINGS-TOTAL
                   ADD 1 TO WS-SAVINGS-COUNT
               WHEN AR-CHECKING
                   ADD AR-BALANCE TO WS-CHECKING-TOTAL
                   ADD 1 TO WS-CHECKING-COUNT
               WHEN AR-INVESTMENT
                   ADD AR-BALANCE TO WS-INVESTMENT-TOTAL
                   ADD 1 TO WS-INVESTMENT-COUNT
           END-EVALUATE

           IF AR-FROZEN
               ADD 1 TO WS-FROZEN-COUNT
           END-IF

           MOVE AR-BALANCE TO WS-DISP
           MOVE SPACES TO REPORT-LINE
           STRING "ID:" AR-ACCOUNT-ID
                  " " AR-CUSTOMER-NAME
                  " TYPE:" AR-ACCOUNT-TYPE
                  " BAL:" WS-DISP
                  " ST:" AR-STATUS
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE.

       3000-WRITE-SUMMARY.
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           MOVE "--- ACCOUNT SUMMARY ---" TO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "Total Accounts  : " WS-TOTAL-ACCOUNTS
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "Savings Accounts: " WS-SAVINGS-COUNT
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "Checking Accts  : " WS-CHECKING-COUNT
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "Investment Accts: " WS-INVESTMENT-COUNT
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE SPACES TO REPORT-LINE
           STRING "Frozen Accounts : " WS-FROZEN-COUNT
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE WS-TOTAL-ASSETS TO WS-DISP
           MOVE SPACES TO REPORT-LINE
           STRING "Total Assets    : " WS-DISP
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE WS-SAVINGS-TOTAL TO WS-DISP
           MOVE SPACES TO REPORT-LINE
           STRING "Savings Total   : " WS-DISP
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE WS-CHECKING-TOTAL TO WS-DISP
           MOVE SPACES TO REPORT-LINE
           STRING "Checking Total  : " WS-DISP
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE

           MOVE WS-INVESTMENT-TOTAL TO WS-DISP
           MOVE SPACES TO REPORT-LINE
           STRING "Investment Total: " WS-DISP
               DELIMITED SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           DISPLAY REPORT-LINE.