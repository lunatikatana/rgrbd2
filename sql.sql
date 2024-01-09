-- Создание базы данных
DROP DATABASE productsionOrdersss;
CREATE DATABASE productsionOrdersss;
USE productsionOrdersss;
DROP TABLE IF EXISTS Clientss, Productss, Orderss, OrderssDetail, DeliveryInfo;


CREATE TABLE IF NOT EXISTS Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL
);



CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_description TEXT
);



CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    client_id INT,
    product_id INT,
    order_date DATE,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);




CREATE TABLE IF NOT EXISTS OrdersDetail (
    detail_id INT PRIMARY KEY,
    order_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);




CREATE TABLE IF NOT EXISTS DeliveryInfo (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    delivery_date DATE,
    delivery_address VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


INSERT INTO Clients (client_id, client_name, client_email) VALUES
(1, 'Иванов Иван', 'ivanov@example.com'),
(2, 'Петров Петр', 'petrov@example.com'),
(3, 'Сидоров Сидор', 'sidorov@example.com'),
(4, 'Смирнова Елена', 'smirnova@example.com'),
(5, 'Кузнецов Алексей', 'kuznetsov@example.com'),
(6, 'Михайлова Анна', 'mikhaylova@example.com'),
(7, 'Новиков Денис', 'novikov@example.com'),
(8, 'Лебедева Татьяна', 'lebedeva@example.com'),
(9, 'Козлов Сергей', 'kozlov@example.com'),
(10, 'Антонова Ольга', 'antonova@example.com');


INSERT INTO Products (product_id, product_name, product_description) VALUES
(1, 'Ноутбук', 'Мощный ноутбук для профессионалов'),
(2, 'Смартфон', 'Современный смартфон с высоким разрешением камеры'),
(3, 'Планшет', 'Легкий и компактный планшет'),
(4, 'Наушники', 'Беспроводные наушники с шумоподавлением'),
(5, 'Монитор', 'Широкоформатный монитор для профессиональной работы'),
(6, 'Фотокамера', 'Зеркальная фотокамера с высоким разрешением'),
(7, 'Принтер', 'Цветной лазерный принтер'),
(8, 'Роутер', 'Быстрый и надежный беспроводной роутер'),
(9, 'Жесткий диск', 'Внешний жесткий диск емкостью 1 ТБ'),
(10, 'Графический планшет', 'Планшет для графических работ');


INSERT INTO Orders (order_id, client_id, product_id, order_date) VALUES
(1, 1, 1, '2024-01-01'),
(2, 2, 3, '2024-01-02'),
(3, 3, 2, '2024-01-03'),
(4, 4, 5, '2024-01-04'),
(5, 5, 6, '2024-01-05'),
(6, 6, 4, '2024-01-06'),
(7, 7, 7, '2024-01-07'),
(8, 8, 8, '2024-01-08'),
(9, 9, 9, '2024-01-09'),
(10, 10, 10, '2024-01-10');


INSERT INTO OrdersDetail (detail_id, order_id, quantity, price) VALUES
(1, 1, 5, 1500.00),
(2, 2, 2, 800.00),
(3, 3, 1, 1200.00),
(4, 4, 3, 500.00),
(5, 5, 1, 2000.00),
(6, 6, 2, 120.00),
(7, 7, 1, 300.00),
(8, 8, 1, 400.00),
(9, 9, 1, 100.00),
(10, 10, 1, 800.00);


INSERT INTO DeliveryInfo (delivery_id, order_id, delivery_date, delivery_address) VALUES
(1, 1, '2024-01-05', 'ул. Пушкина, д.10, кв. 20'),
(2, 2, '2024-01-06', 'ул. Лермонтова, д.15, кв. 30'),
(3, 3, '2024-01-07', 'ул. Толстого, д.5, кв. 15'),
(4, 4, '2024-01-08', 'ул. Гоголя, д.8, кв. 25'),
(5, 5, '2024-01-09', 'ул. Чехова, д.12, кв. 10'),
(6, 6, '2024-01-10', 'ул. Достоевского, д.18, кв. 22'),
(7, 7, '2024-01-11', 'ул. Шекспира, д.7, кв. 18'),
(8, 8, '2024-01-12', 'ул. Островского, д.3, кв. 12'),
(9, 9, '2024-01-13', 'ул. Бунина, д.6, кв. 28'),
(10, 10, '2024-01-14', 'ул. Тургенева, д.9, кв. 14');



DELIMITER //
CREATE TRIGGER check_unique_email
BEFORE INSERT ON Clients
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Clients WHERE client_email = NEW.client_email) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Данный адрес электронной почты уже используется';
  END IF;
END;
//
DELIMITER ;



DELIMITER //
CREATE TRIGGER check_client_before_delete
BEFORE DELETE ON Clients
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Orders WHERE client_id = OLD.client_id) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Нельзя удалить клиента, у которого есть заказы';
  END IF;
END;
//
DELIMITER ;




DELIMITER //
CREATE TRIGGER check_product_before_delete
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Orders WHERE product_id = OLD.product_id) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Нельзя удалить продукт, который есть в заказах';
  END IF;
END;
//
DELIMITER ;



DELIMITER //
CREATE TRIGGER check_order_before_delete
BEFORE DELETE ON Orders
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM OrdersDetail WHERE order_id = OLD.order_id) > 0 OR
     (SELECT COUNT(*) FROM DeliveryInfo WHERE order_id = OLD.order_id) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Нельзя удалить заказ, у которого есть детали заказа или информация о доставке';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_unique_product_name_before_insert
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM Products WHERE product_name = NEW.product_name) > 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Продукт с таким наименованием уже существует';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_client_and_product_existence_before_insert
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
  IF NOT EXISTS (SELECT 1 FROM Clients WHERE client_id = NEW.client_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Клиент с указанным ID не существует';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM Products WHERE product_id = NEW.product_id) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Продукт с указанным ID не существует';
  END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER check_positive_price_before_insert
BEFORE INSERT ON OrdersDetail
FOR EACH ROW
BEGIN
  IF NEW.price < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Цена не может быть отрицательной';
  END IF;
END;
//
DELIMITER ;



