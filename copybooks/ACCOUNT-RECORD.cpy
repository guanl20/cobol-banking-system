*> ============================================================
      *> Copybook:   ACCOUNT-RECORD
      *> Purpose:    Defines the standard bank account record layout
      *> ============================================================
       01 ACCOUNT-RECORD.
           05 AR-ACCOUNT-ID         PIC 9(8).
           05 AR-CUSTOMER-NAME      PIC X(30).
           05 AR-ACCOUNT-TYPE       PIC X(1).
               88 AR-SAVINGS                 VALUE "S".
               88 AR-CHECKING                VALUE "C".
               88 AR-INVESTMENT              VALUE "I".
           05 AR-BALANCE            PIC 9(9)V99.
           05 AR-INTEREST-RATE      PIC 9(2)V99.
           05 AR-STATUS             PIC X(1).
               88 AR-ACTIVE                  VALUE "A".
               88 AR-INACTIVE                VALUE "I".
               88 AR-FROZEN                  VALUE "F".
           05 AR-OPEN-DATE          PIC 9(8).
           05 AR-LAST-TXN-DATE      PIC 9(8).