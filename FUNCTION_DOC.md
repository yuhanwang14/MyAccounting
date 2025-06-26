# Function Doc: MyAccounting

### 1. Project Name and Goal

*   **Project Name:** MyAccounting
*   **Goal:** To develop a straightforward personal accounting application for tracking and managing personal finances efficiently.

### 2. Problem It Solves

This application addresses the need for a simple, private, and customized tool to monitor income and expenses. It avoids the complexity and unwanted features of many commercial accounting applications, providing a focused solution for personal financial tracking.

### 3. Target Audience

The primary user is the developer, meaning the application can be tailored to specific personal workflows without needing to accommodate a wide range of users.

### 4. Core Features

*   **Account Books:**
    *   Ability to create, rename, and manage multiple account books (e.g., "Personal Savings", "Daily Expenses").

*   **Transaction Management:**
    *   Add new transactions with the following details:
        *   **Name:** A description of the transaction (e.g., "Dinner with friends").
        *   **Amount:** The cost of the transaction.
        *   **Currency:** Support for multiple currencies (e.g., GBP, CNY, USD), with automatic conversion to a primary currency (GBP) based on current exchange rates.
        *   **Type:** Classify as "Income" or "Expense".
        *   **Date:** A calendar selector to pick the transaction date.
        *   **Label:** Assign a category (e.g., "Food", "Transport"). Users can select from existing labels or create new ones on the fly.

*   **Data Visualization & Summaries:**
    *   **Period Summary:** Display total income, total expenses, and the final balance for a selected period (e.g., monthly or yearly).
    *   **Expenditure Trend Chart:** Show a histogram or line chart of expenses over the selected period, including average daily expenditure.
    *   **Expenditure Category Ranking:**
        *   Generate a pie chart showing the spending distribution across different categories (labels).
        *   Display a ranked list of categories by total spending, including the number of transactions per category.
    *   **Top Transactions:** List the top 10 individual expense transactions.


*   **CSV Import:**
    *   Import transaction data from a CSV file to allow for bulk entry from bank statements or other sources.

### 5. Nice-to-Haves

*   **Advanced Charting:** Introduce other chart types like bar charts for monthly expense/income comparisons or trend lines.
*   **Budgeting Module:** Set monthly or yearly budgets for different labels and track spending against them.
*   **Recurring Transactions:** Set up automatic entries for regular payments like rent or subscriptions.
*   **Data Export:** Export account books or reports to formats like PDF or Excel.
*   **Advanced Filtering:** More granular filtering options for transactions (e.g., by date range, amount, or label).
