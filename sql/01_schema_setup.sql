-- ================================================
-- File: 01_schema_setup.sql
-- Project: Supply Chain Performance Analytics
-- Description: Database schema - table definitions,
--              primary keys, foreign keys
-- Author: Shriya Torgale
-- Date: July 2026
-- ================================================

CREATE DATABASE IF NOT EXISTS supply_chain_db;
USE supply_chain_db;

-- ── 1. CATEGORIES ──────────────────────────────
CREATE TABLE IF NOT EXISTS categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- ── 2. DEPARTMENTS ─────────────────────────────
CREATE TABLE IF NOT EXISTS departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- ── 3. CUSTOMERS ───────────────────────────────
CREATE TABLE IF NOT EXISTS customers (
    customer_id       INT PRIMARY KEY,
    customer_fname    VARCHAR(50),
    customer_lname    VARCHAR(50),
    customer_segment  VARCHAR(50),
    customer_city     VARCHAR(100),
    customer_state    VARCHAR(50),
    customer_country  VARCHAR(100),
    customer_zipcode  FLOAT
);

-- ── 4. PRODUCTS ────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
    product_card_id  INT PRIMARY KEY,
    product_name     VARCHAR(200),
    product_price    FLOAT,
    product_status   INT,
    category_id      INT,
    department_id    INT,
    FOREIGN KEY (category_id)   REFERENCES categories(category_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ── 5. ORDERS ──────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    order_id                    INT PRIMARY KEY,
    customer_id                 INT,
    order_date                  VARCHAR(50),
    order_status                VARCHAR(50),
    order_region                VARCHAR(100),
    order_city                  VARCHAR(100),
    order_country               VARCHAR(100),
    order_state                 VARCHAR(100),
    shipping_mode               VARCHAR(50),
    shipping_date               VARCHAR(50),
    delivery_status             VARCHAR(50),
    late_delivery_risk          INT,
    days_for_shipping_real      INT,
    days_for_shipment_scheduled INT,
    market                      VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ── 6. ORDER_ITEMS ─────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id            INT PRIMARY KEY,
    order_id                 INT,
    product_card_id          INT,
    order_item_quantity      INT,
    order_item_discount      FLOAT,
    order_item_discount_rate FLOAT,
    order_item_product_price FLOAT,
    order_item_total         FLOAT,
    order_item_profit_ratio  FLOAT,
    sales                    FLOAT,
    order_profit_per_order   FLOAT,
    benefit_per_order        FLOAT,
    FOREIGN KEY (order_id)        REFERENCES orders(order_id),
    FOREIGN KEY (product_card_id) REFERENCES products(product_card_id)
);