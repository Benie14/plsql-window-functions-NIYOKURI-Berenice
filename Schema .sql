-- Drop tables if they exist (clean start)
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE transactions CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE products CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

-- Create Customers Table with constraints
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    region VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(20),
    created_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_region CHECK (region IN ('Kigali', 'Rubavu', 'Huye', 'Musanze')),
    CONSTRAINT chk_customer_id CHECK (customer_id > 0)
);

-- Create Products Table with constraints
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    category VARCHAR2(50) NOT NULL,
    price NUMBER(10,2) CHECK (price >= 0),
    cost_price NUMBER(10,2) CHECK (cost_price >= 0),
    is_active CHAR(1) DEFAULT 'Y' NOT NULL,
    created_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_category CHECK (category IN ('Coffee', 'Equipment', 'Accessories')),
    CONSTRAINT chk_product_id CHECK (product_id > 0),
    CONSTRAINT chk_is_active CHECK (is_active IN ('Y', 'N'))
);

-- Create Transactions Table with comprehensive constraints
CREATE TABLE transactions (
    transaction_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    sale_date DATE NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    quantity NUMBER DEFAULT 1 NOT NULL,
    unit_price NUMBER(10,2) NOT NULL,
    created_date DATE DEFAULT SYSDATE NOT NULL,
    created_by VARCHAR2(50) DEFAULT USER NOT NULL,
    
    -- Foreign key constraints with proper naming
    CONSTRAINT fk_trans_customer 
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_trans_product 
        FOREIGN KEY (product_id) REFERENCES products(product_id),
    
    -- Check constraints
    CONSTRAINT chk_transaction_id CHECK (transaction_id > 0),
    CONSTRAINT chk_amount CHECK (amount > 0),
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_sale_date CHECK (sale_date >= DATE '2024-01-01'),
    
    -- Ensure amount = quantity * unit_price
    CONSTRAINT chk_amount_calculation CHECK (amount = quantity * unit_price)
);

-- Create indexes for better performance
CREATE INDEX idx_transactions_customer_id ON transactions(customer_id);
CREATE INDEX idx_transactions_product_id ON transactions(product_id);
CREATE INDEX idx_transactions_sale_date ON transactions(sale_date);
CREATE INDEX idx_transactions_region ON customers(region);

-- Insert sample data with proper values
INSERT INTO customers (customer_id, name, region, email) VALUES 
(1, 'Alice Uwase', 'Kigali', 'alice.uwase@email.com');
INSERT INTO customers (customer_id, name, region, email) VALUES 
(2, 'Bob Mugisha', 'Rubavu', 'bob.mugisha@email.com');
INSERT INTO customers (customer_id, name, region, email) VALUES 
(3, 'Claire Iragena', 'Kigali', 'claire.iragena@email.com');
INSERT INTO customers (customer_id, name, region, email) VALUES 
(4, 'David Habimana', 'Huye', 'david.habimana@email.com');
INSERT INTO customers (customer_id, name, region, email) VALUES 
(5, 'Emma Uwimana', 'Rubavu', 'emma.uwimana@email.com');

INSERT INTO products (product_id, name, category, price, cost_price) VALUES 
(101, 'Premium Arabica Beans', 'Coffee', 12000, 8000);
INSERT INTO products (product_id, name, category, price, cost_price) VALUES 
(102, 'French Press', 'Equipment', 25000, 15000);
INSERT INTO products (product_id, name, category, price, cost_price) VALUES 
(103, 'Ceramic Mug', 'Accessories', 8000, 4000);
INSERT INTO products (product_id, name, category, price, cost_price) VALUES 
(104, 'Robusta Blend', 'Coffee', 9000, 6000);
INSERT INTO products (product_id, name, category, price, cost_price) VALUES 
(105, 'Coffee Grinder', 'Equipment', 45000, 30000);

INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1001, 1, 101, DATE '2024-01-15', 24000, 2, 12000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1002, 2, 102, DATE '2024-01-20', 25000, 1, 25000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1003, 3, 101, DATE '2024-01-25', 12000, 1, 12000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1004, 1, 103, DATE '2024-02-05', 8000, 1, 8000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1005, 4, 104, DATE '2024-02-10', 18000, 2, 9000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1006, 2, 105, DATE '2024-02-15', 45000, 1, 45000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1007, 5, 101, DATE '2024-02-20', 12000, 1, 12000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1008, 3, 102, DATE '2024-03-01', 25000, 1, 25000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1009, 1, 105, DATE '2024-03-10', 45000, 1, 45000);
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, amount, quantity, unit_price) VALUES 
(1010, 4, 103, DATE '2024-03-15', 16000, 2, 8000);

-- Final verification query
SELECT 
    (SELECT COUNT(*) FROM customers) as customer_count,
    (SELECT COUNT(*) FROM products) as product_count,
    (SELECT COUNT(*) FROM transactions) as transaction_count,
    (SELECT SUM(amount) FROM transactions) as total_sales
FROM DUAL;