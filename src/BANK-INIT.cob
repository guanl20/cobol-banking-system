*> ============================================================
      *> Program:    BANK-INIT
      *> Author:     Guan
      *> Date:       2025
      *> Purpose:    Initializes the banking system by creating
      *>             customer accounts and seeding account data file
      *> ============================================================

       IDENTIFICATION DIVISION.
           PROGRAM-ID. BANK-INIT.
           AUTHOR. Guan.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNT-FILE
               ASSIGN TO "../data/accounts.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  ACCOUNT-FILE.
       COPY "../copybooks/ACCOUNT-RECORD.cpy".

       WORKING-STORAGE SECTION.
           01 WS-FILE-STATUS        PIC X(2)    VALUE SPACES.
               88 FILE-OK                       VALUE "00".
           01 WS-COUNT              PIC 9(4)    VALUE ZEROS.

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           DISPLAY "===== BANK SYSTEM INITIALIZATION ====="
           OPEN OUTPUT ACCOUNT-FILE
           IF NOT FILE-OK
               DISPLAY "ERROR: Cannot create accounts file!"
               STOP RUN
           END-IF
           PERFORM 1000-CREATE-ACCOUNTS
           CLOSE ACCOUNT-FILE
           DISPLAY "===== INITIALIZATION COMPLETE ====="
           DISPLAY WS-COUNT " accounts created successfully."
           STOP RUN.

       1000-CREATE-ACCOUNTS.
           MOVE 10000001       TO AR-ACCOUNT-ID
           MOVE "Alice Johnson" TO AR-CUSTOMER-NAME
           MOVE "S"            TO AR-ACCOUNT-TYPE
           MOVE 25000.00       TO AR-BALANCE
           MOVE 3.50           TO AR-INTEREST-RATE
           MOVE "A"            TO AR-STATUS
           MOVE 20200101       TO AR-OPEN-DATE
           MOVE 20250101       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [SAVINGS]"

           MOVE 10000002       TO AR-ACCOUNT-ID
           MOVE "Bob Smith"    TO AR-CUSTOMER-NAME
           MOVE "C"            TO AR-ACCOUNT-TYPE
           MOVE 8500.75        TO AR-BALANCE
           MOVE 1.00           TO AR-INTEREST-RATE
           MOVE "A"            TO AR-STATUS
           MOVE 20190615       TO AR-OPEN-DATE
           MOVE 20250101       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [CHECKING]"

           MOVE 10000003       TO AR-ACCOUNT-ID
           MOVE "Carol White"  TO AR-CUSTOMER-NAME
           MOVE "I"            TO AR-ACCOUNT-TYPE
           MOVE 150000.00      TO AR-BALANCE
           MOVE 7.50           TO AR-INTEREST-RATE
           MOVE "A"            TO AR-STATUS
           MOVE 20180301       TO AR-OPEN-DATE
           MOVE 20250101       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [INVESTMENT]"

           MOVE 10000004       TO AR-ACCOUNT-ID
           MOVE "David Brown"  TO AR-CUSTOMER-NAME
           MOVE "S"            TO AR-ACCOUNT-TYPE
           MOVE 42000.50       TO AR-BALANCE
           MOVE 3.50           TO AR-INTEREST-RATE
           MOVE "A"            TO AR-STATUS
           MOVE 20210901       TO AR-OPEN-DATE
           MOVE 20250101       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [SAVINGS]"

           MOVE 10000005       TO AR-ACCOUNT-ID
           MOVE "Eve Davis"    TO AR-CUSTOMER-NAME
           MOVE "C"            TO AR-ACCOUNT-TYPE
           MOVE 3200.25        TO AR-BALANCE
           MOVE 1.00           TO AR-INTEREST-RATE
           MOVE "F"            TO AR-STATUS
           MOVE 20170501       TO AR-OPEN-DATE
           MOVE 20240601       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [CHECKING/FROZEN]"

           MOVE 10000006       TO AR-ACCOUNT-ID
           MOVE "Frank Miller" TO AR-CUSTOMER-NAME
           MOVE "I"            TO AR-ACCOUNT-TYPE
           MOVE 500000.00      TO AR-BALANCE
           MOVE 7.50           TO AR-INTEREST-RATE
           MOVE "A"            TO AR-STATUS
           MOVE 20150101       TO AR-OPEN-DATE
           MOVE 20250101       TO AR-LAST-TXN-DATE
           WRITE ACCOUNT-RECORD
           ADD 1 TO WS-COUNT
           DISPLAY "Created: " AR-CUSTOMER-NAME " [INVESTMENT]".