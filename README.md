# COBOL Banking System

A full-scale enterprise COBOL batch processing banking system demonstrating
real-world mainframe development patterns including file handling, transaction
processing, interest calculation, audit trails, and report generation.

## Author
**Guan** | COBOL Developer Portfolio | 2025

---

## System Overview

This system simulates a production banking batch processing environment of
the kind found in major banks, insurance companies, and financial institutions
running on IBM mainframes. It demonstrates the core competencies required
for enterprise COBOL development.

---

## Programs

### BANK-INIT — System Initialization
Initializes the banking system by creating and seeding the customer account
master file with 6 accounts across three account types.

**Features:**
- Creates savings, checking, and investment accounts
- Sets account status (active/frozen)
- Assigns interest rates per account type
- Writes formatted records to sequential master file

---

### BANK-TRANSACTIONS — Transaction Processor
Core batch processing engine that reads accounts, applies transactions,
validates business rules, and writes an audit trail.

**Features:**
- Deposit processing with balance update
- Withdrawal validation (insufficient funds check)
- Frozen account detection and rejection
- Full transaction audit trail written to file
- Batch summary reporting (success/fail counts, totals)

**Business Rules Enforced:**
- Withdrawals rejected if amount exceeds balance
- All transactions blocked on frozen accounts
- Every transaction logged with status (Complete/Failed)

---

### BANK-INTEREST — Interest Calculation Engine
Monthly batch interest calculation program that processes all active accounts,
calculates interest based on account type rate, and generates interest
transaction records.

**Features:**
- Per-account interest calculation (`Balance × Rate / 12`)
- Automatic skipping of frozen/inactive accounts
- Interest transaction records written to log file
- Summary of total interest paid across all accounts

**Interest Rates:**
| Account Type | Annual Rate |
|---|---|
| Savings | 3.50% |
| Checking | 1.00% |
| Investment | 7.50% |

---

### BANK-REPORTS — Report Generator
Generates a comprehensive management report from the account master file,
writing output both to screen and to a formatted report file.

**Features:**
- Full account listing with balances and status
- Account type breakdown (savings/checking/investment counts)
- Total assets under management
- Frozen account flagging
- Report saved to `reports/bank-report.txt`
