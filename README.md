# MyAccounting

MyAccounting is a straightforward personal accounting application designed for efficient tracking and management of personal finances. It addresses the need for a simple, private, and customized tool to monitor income and expenses, avoiding the complexity of commercial accounting applications.

## Core Features

*   **Account Books:** Create, rename, and manage multiple account books (e.g., "Personal Savings", "Daily Expenses").
*   **Transaction Management:** Add transactions with details like name, amount, currency (with automatic conversion), type (Income/Expense), date, and customizable labels.
*   **Data Visualization & Summaries:** 
    *   Period summaries (total income, expenses, and balance).
    *   Expenditure trend charts.
    *   Spending distribution by category (pie chart and ranked list).
    *   Top 10 individual expense transactions.
*   **CSV Import:** Import transaction data from CSV files for bulk entry.

For a detailed breakdown of features, please refer to the [FUNCTION_DOC.md](./FUNCTION_DOC.md).

## Tech Stack

*   **Framework:** Flutter (for Web and iOS)
*   **Backend:** Local-first architecture with plans for an optional future backend.
*   **Database:** A local database (Hive or Isar).
*   **State Management:** Riverpod

For more detailed information on the architecture, see [ARCHITECTURE.md](./ARCHITECTURE.md).
