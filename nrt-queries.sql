-- cleanup
DROP TABLE IF EXISTS "products";
DROP TABLE IF EXISTS "countries";
DROP TABLE IF EXISTS "orders";

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  category TEXT,
  name TEXT
);

CREATE TABLE countries (
  code CHAR(2) PRIMARY KEY,
  country TEXT
);

CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT,
  product_id INT REFERENCES products(id),
  country_code CHAR(2) REFERENCES countries(code),
  amount DECIMAL(10,2),
  order_date TIMESTAMP DEFAULT now()
);

INSERT INTO products(category, name) VALUES
 ('Electronics', 'Headphones'),
 ('Home', 'Lamp');

INSERT INTO countries(code, country) VALUES
 ('US', 'United States'),
 ('SG', 'Singapore');

INSERT INTO orders(user_id, product_id, country_code, amount)
VALUES (1, 1, 'US', 50.00),
       (2, 2, 'SG', 30.00);