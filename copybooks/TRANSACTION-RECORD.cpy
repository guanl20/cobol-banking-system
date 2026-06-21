*> ============================================================
      *> Copybook:   TRANSACTION-RECORD
      *> Purpose:    Defines the standard transaction record layout
      *> ============================================================
       01 TRANSACTION-RECORD.
           05 TR-TXN-ID             PIC 9(10).
           05 TR-ACCOUNT-ID         PIC 9(8).
           05 TR-TXN-TYPE           PIC X(1).
               88 TR-DEPOSIT                 VALUE "D".
               88 TR-WITHDRAWAL              VALUE "W".
               88 TR-TRANSFER                VALUE "T".
               88 TR-INTEREST                VALUE "I".
           05 TR-AMOUNT             PIC 9(9)V99.
           05 TR-DATE               PIC 9(8).
           05 TR-STATUS             PIC X(1).
               88 TR-PENDING                 VALUE "P".
               88 TR-COMPLETE                VALUE "C".
               88 TR-FAILED                  VALUE "F".
           05 TR-DESCRIPTION        PIC X(30).