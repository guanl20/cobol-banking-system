*> ============================================================
      *> Program:    BANK-MAIN
      *> Author:     Guan
      *> Date:       2025
      *> Purpose:    Main controller for the COBOL Banking System.
      *>             Orchestrates initialization, transaction
      *>             processing, interest calculation and reporting.
      *> ============================================================

       IDENTIFICATION DIVISION.
           PROGRAM-ID. BANK-MAIN.
           AUTHOR. Guan.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 WS-CHOICE             PIC 9(1)    VALUE 0.
           01 WS-CONTINUE           PIC X(1)    VALUE "Y".
               88 CONTINUE-YES                  VALUE "Y" "y".

       PROCEDURE DIVISION.
       0000-MAIN-PARA.
           PERFORM 1000-DISPLAY-BANNER
           PERFORM 2000-MAIN-MENU UNTIL WS-CHOICE = 5
           DISPLAY "Thank you for using COBOL Banking System!"
           STOP RUN.

       1000-DISPLAY-BANNER.
           DISPLAY "╔══════════════════════════════════════════╗"
           DISPLAY "║       COBOL BANKING SYSTEM v1.0          ║"
           DISPLAY "║    Enterprise Batch Processing Demo      ║"
           DISPLAY "║          Author: Guan | 2025             ║"
           DISPLAY "╚══════════════════════════════════════════╝"
           DISPLAY SPACES.

       2000-MAIN-MENU.
           DISPLAY "========== MAIN MENU =========="
           DISPLAY "1. Initialize System & Create Accounts"
           DISPLAY "2. Process Transactions"
           DISPLAY "3. Calculate Monthly Interest"
           DISPLAY "4. Generate Reports"
           DISPLAY "5. Exit"
           DISPLAY "================================"
           DISPLAY "Enter choice (1-5): " WITH NO ADVANCING
           ACCEPT WS-CHOICE
           DISPLAY SPACES
           EVALUATE WS-CHOICE
               WHEN 1
                   CALL "BANK-INIT"
               WHEN 2
                   CALL "BANK-TRANSACTIONS"
               WHEN 3
                   CALL "BANK-INTEREST"
               WHEN 4
                   CALL "BANK-REPORTS"
               WHEN 5
                   DISPLAY "Exiting system..."
               WHEN OTHER
                   DISPLAY "Invalid choice. Please try again."
           END-EVALUATE
           DISPLAY SPACES.