*> ============================================================
      *> Program:    BANK-TRANSACTIONS
      *> Author:     Guan
      *> Date:       2025
      *> Purpose:    Processes deposits, withdrawals and transfers.
      *>             Validates transactions and updates balances.
      *>             Writes full audit trail to transaction log.
      *> ============================================================

       IDENTIFICATION DIVISION.
           PROGRAM-ID. BANK-TRANSACTIONS.
           AUTHOR. Guan.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "../data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-ACCT-STATUS.

           SELECT TRANSACTION-FILE
               ASSIGN TO "../data/transactions.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TXN-STATUS.

           SELECT UPDATED-ACCOUNT-FILE
               ASSIGN TO "../data/accounts-updated.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-UPD-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE.
       COPY "../copybooks/ACCOUNT-RECORD.cpy".

       FD  TRANSACTION-FILE.
       COPY "../copybooks/TRANSACTION-RECORD.cpy".

       FD  UPDATED-ACCOUNT-FILE.
       01  UPDATED-ACCOUNT-REC  PIC X(100).

       WORKING-STORAGE SECTION.
           01 WS-ACCT-STATUS        PIC X(2)    VALUE SPACES.
               88 ACCT-OK                       VALUE "00".
               88 ACCT-EOF                      VALUE "10".
           01 WS-TXN-STATUS         PIC X(2)    VALUE SPACES.
               88 TXN-OK                        VALUE "00".
               88 TXN-EOF                       VALUE "10".
           01 WS-UPD-STATUS         PIC X(2)    VALUE SPACES.
               88 UPD-OK                        VALUE "00".

           01 WS-TXN-ID             PIC 9(10)   VALUE 1000000001.
           01 WS-SUCCESS-COUNT      PIC 9(4)    VALUE ZEROS.
           01 WS-FAIL-COUNT         PIC 9(4)    VALUE ZEROS.
           01 WS-TOTAL-DEPOSITS     PIC 9(11)V99 VALUE ZEROS.
           01 WS-TOTAL-WITHDRAWALS  PIC 9(11)V99 VALUE ZEROS.
           01 WS-DISP               PIC $9,999,999,999.99.

           01 WS-CURRENT-ACCOUNT.
               05 WS-AR-ACCOUNT-ID      PIC 9(8).
               05 WS-AR-CUSTOMER-NAME   PIC X(30).
               05 WS-AR-ACCOUNT-TYPE    PIC X(1).
               05 WS-AR-BALANCE         PIC 9(9)V99.
               05 WS-AR-INTEREST-RATE   PIC 9(2)V99.
               05 WS-AR-STATUS          PIC X(1).
                   88 WS-AR-ACTIVE              VALUE "A".
                   88 WS-AR-FROZEN              VALUE "F".
               05 WS-AR-OPEN-DATE       PIC 9(8).
               05 WS-AR-LAST-TXN-DATE   PIC 9(8).

           01 WS-TRANSACTIONS.
               05 WS-TXN OCCURS 20 TIMES.
                   10 WS-TXN-ACCT-ID    PIC 9(8).
                   10 WS-TXN-TYPE       PIC X(1).
                   10 WS-TXN-AMOUNT     PIC 9(9)V99.
                   10 WS-TXN-DESC       PIC X(30).

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           DISPLAY "===== BANK TRANSACTION PROCESSOR ====="
           DISPLAY SPACES
           PERFORM 1000-LOAD-TRANSACTIONS
           PERFORM 2000-PROCESS-ALL-ACCOUNTS
           PERFORM 3000-DISPLAY-SUMMARY
           DISPLAY "===== TRANSACTION PROCESSING COMPLETE ====="
           STOP RUN.

       1000-LOAD-TRANSACTIONS.
           DISPLAY "--- Loading Transactions ---"
           MOVE 10000001 TO WS-TXN-ACCT-ID(1)
           MOVE "D"      TO WS-TXN-TYPE(1)
           MOVE 5000.00  TO WS-TXN-AMOUNT(1)
           MOVE "Salary deposit"        TO WS-TXN-DESC(1)

           MOVE 10000001 TO WS-TXN-ACCT-ID(2)
           MOVE "W"      TO WS-TXN-TYPE(2)
           MOVE 1200.00  TO WS-TXN-AMOUNT(2)
           MOVE "Rent payment"          TO WS-TXN-DESC(2)

           MOVE 10000002 TO WS-TXN-ACCT-ID(3)
           MOVE "D"      TO WS-TXN-TYPE(3)
           MOVE 3000.00  TO WS-TXN-AMOUNT(3)
           MOVE "Freelance payment"     TO WS-TXN-DESC(3)

           MOVE 10000002 TO WS-TXN-ACCT-ID(4)
           MOVE "W"      TO WS-TXN-TYPE(4)
           MOVE 15000.00 TO WS-TXN-AMOUNT(4)
           MOVE "Insufficient funds test" TO WS-TXN-DESC(4)

           MOVE 10000003 TO WS-TXN-ACCT-ID(5)
           MOVE "D"      TO WS-TXN-TYPE(5)
           MOVE 50000.00 TO WS-TXN-AMOUNT(5)
           MOVE "Investment deposit"    TO WS-TXN-DESC(5)

           MOVE 10000004 TO WS-TXN-ACCT-ID(6)
           MOVE "W"      TO WS-TXN-TYPE(6)
           MOVE 500.00   TO WS-TXN-AMOUNT(6)
           MOVE "ATM withdrawal"        TO WS-TXN-DESC(6)

           MOVE 10000005 TO WS-TXN-ACCT-ID(7)
           MOVE "D"      TO WS-TXN-TYPE(7)
           MOVE 1000.00  TO WS-TXN-AMOUNT(7)
           MOVE "Frozen account test"   TO WS-TXN-DESC(7)

           MOVE 10000006 TO WS-TXN-ACCT-ID(8)
           MOVE "W"      TO WS-TXN-TYPE(8)
           MOVE 25000.00 TO WS-TXN-AMOUNT(8)
           MOVE "Portfolio withdrawal"  TO WS-TXN-DESC(8)

           DISPLAY "8 transactions loaded."
           DISPLAY SPACES.

       2000-PROCESS-ALL-ACCOUNTS.
           DISPLAY "--- Processing Transactions ---"
           OPEN INPUT ACCOUNT-FILE
           OPEN OUTPUT TRANSACTION-FILE
           OPEN OUTPUT UPDATED-ACCOUNT-FILE

           PERFORM UNTIL ACCT-EOF
               READ ACCOUNT-FILE
               IF ACCT-OK
                   MOVE AR-ACCOUNT-ID    TO WS-AR-ACCOUNT-ID
                   MOVE AR-CUSTOMER-NAME TO WS-AR-CUSTOMER-NAME
                   MOVE AR-ACCOUNT-TYPE  TO WS-AR-ACCOUNT-TYPE
                   MOVE AR-BALANCE       TO WS-AR-BALANCE
                   MOVE AR-INTEREST-RATE TO WS-AR-INTEREST-RATE
                   MOVE AR-STATUS        TO WS-AR-STATUS
                   MOVE AR-OPEN-DATE     TO WS-AR-OPEN-DATE
                   MOVE AR-LAST-TXN-DATE TO WS-AR-LAST-TXN-DATE
                   PERFORM 2100-APPLY-TRANSACTIONS
               END-IF
           END-PERFORM

           CLOSE ACCOUNT-FILE
           CLOSE TRANSACTION-FILE
           CLOSE UPDATED-ACCOUNT-FILE
           DISPLAY SPACES.

       2100-APPLY-TRANSACTIONS.
           PERFORM VARYING WS-TXN-ID FROM 1 BY 1
               UNTIL WS-TXN-ID > 8
               IF WS-TXN-ACCT-ID(WS-TXN-ID) = WS-AR-ACCOUNT-ID
                   PERFORM 2200-VALIDATE-AND-PROCESS
               END-IF
           END-PERFORM
           MOVE WS-AR-ACCOUNT-ID    TO AR-ACCOUNT-ID
           MOVE WS-AR-CUSTOMER-NAME TO AR-CUSTOMER-NAME
           MOVE WS-AR-ACCOUNT-TYPE  TO AR-ACCOUNT-TYPE
           MOVE WS-AR-BALANCE       TO AR-BALANCE
           MOVE WS-AR-INTEREST-RATE TO AR-INTEREST-RATE
           MOVE WS-AR-STATUS        TO AR-STATUS
           MOVE WS-AR-OPEN-DATE     TO AR-OPEN-DATE
           MOVE WS-AR-LAST-TXN-DATE TO AR-LAST-TXN-DATE
           WRITE UPDATED-ACCOUNT-REC FROM ACCOUNT-RECORD.

       2200-VALIDATE-AND-PROCESS.
           DISPLAY "Account: " WS-AR-ACCOUNT-ID
                   " | " WS-AR-CUSTOMER-NAME
           DISPLAY "TXN: " WS-TXN-DESC(WS-TXN-ID)
           IF WS-AR-FROZEN
               DISPLAY "ERROR: Account is FROZEN - transaction rejected!"
               MOVE "F" TO TR-STATUS
               ADD 1 TO WS-FAIL-COUNT
           ELSE
               EVALUATE WS-TXN-TYPE(WS-TXN-ID)
                   WHEN "D"
                       ADD WS-TXN-AMOUNT(WS-TXN-ID)
                           TO WS-AR-BALANCE
                       ADD WS-TXN-AMOUNT(WS-TXN-ID)
                           TO WS-TOTAL-DEPOSITS
                       MOVE "C" TO TR-STATUS
                       ADD 1 TO WS-SUCCESS-COUNT
                       MOVE WS-AR-BALANCE TO WS-DISP
                       DISPLAY "DEPOSIT OK. New Balance: " WS-DISP
                   WHEN "W"
                       IF WS-TXN-AMOUNT(WS-TXN-ID) > WS-AR-BALANCE
                           DISPLAY "ERROR: Insufficient funds!"
                           MOVE "F" TO TR-STATUS
                           ADD 1 TO WS-FAIL-COUNT
                       ELSE
                           SUBTRACT WS-TXN-AMOUNT(WS-TXN-ID)
                               FROM WS-AR-BALANCE
                           ADD WS-TXN-AMOUNT(WS-TXN-ID)
                               TO WS-TOTAL-WITHDRAWALS
                           MOVE "C" TO TR-STATUS
                           ADD 1 TO WS-SUCCESS-COUNT
                           MOVE WS-AR-BALANCE TO WS-DISP
                           DISPLAY "WITHDRAWAL OK. New Balance: " WS-DISP
                       END-IF
                   WHEN OTHER
                       DISPLAY "ERROR: Unknown transaction type!"
                       ADD 1 TO WS-FAIL-COUNT
               END-EVALUATE
           END-IF
           MOVE WS-TXN-ID           TO TR-TXN-ID
           MOVE WS-AR-ACCOUNT-ID    TO TR-ACCOUNT-ID
           MOVE WS-TXN-TYPE(WS-TXN-ID) TO TR-TXN-TYPE
           MOVE WS-TXN-AMOUNT(WS-TXN-ID) TO TR-AMOUNT
           MOVE 20250101            TO TR-DATE
           MOVE WS-TXN-DESC(WS-TXN-ID) TO TR-DESCRIPTION
           WRITE TRANSACTION-RECORD
           DISPLAY SPACES.

       3000-DISPLAY-SUMMARY.
           DISPLAY "--- Transaction Summary ---"
           DISPLAY "Successful : " WS-SUCCESS-COUNT
           DISPLAY "Failed     : " WS-FAIL-COUNT
           MOVE WS-TOTAL-DEPOSITS TO WS-DISP
           DISPLAY "Total Deposits    : " WS-DISP
           MOVE WS-TOTAL-WITHDRAWALS TO WS-DISP
           DISPLAY "Total Withdrawals : " WS-DISP
           DISPLAY SPACES.