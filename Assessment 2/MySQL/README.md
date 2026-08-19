# MySQL setup and query guide

The SQL files in this folder create a small sales database, load its sample data, and answer the assignment questions.

1. Connect to MySQL through the command-line client, Workbench, or another compatible tool.
2. Create the database structure:

   ```bash
   mysql -u root -p < setup/create_tables.sql
   ```

3. Insert the sample customers, products, orders, and order lines:

   ```bash
   mysql -u root -p < setup/load_data.sql
   ```

4. Execute the query files from Section A through Section E. They move from basic inspection to filters, aggregates, joins, and more advanced analysis.
