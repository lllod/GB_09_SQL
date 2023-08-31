CREATE TABLE IF NOT EXISTS cars
(
    id   SMALLINT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(20) NOT NULL,
    Cost INT         NOT NULL
);

INSERT INTO cars (Name, Cost) VALUE
    ('Audi', 52642),
    ('Mercedes', 57127),
    ('Skoda', 9000),
    ('Volvo', 29000),
    ('Bentley', 350000),
    ('Citroen', 21000),
    ('Hummer', 41400),
    ('Volkswagen', 21600);

# 1.	Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов

CREATE VIEW cars_new AS
SELECT *
FROM cars
WHERE Cost < 25000;

SELECT *
FROM cars_new;

# 2.	Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов
# (используя оператор ALTER VIEW)

ALTER VIEW cars_new AS
    SELECT *
    FROM cars
    WHERE cars.Cost < 30000;

SELECT *
FROM cars_new;

# 3. 	Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”

CREATE VIEW cars_not_all AS
SELECT *
FROM cars
WHERE Name in ('Skoda', 'Audi');

SELECT *
FROM cars_not_all;

# Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.

CREATE TABLE IF NOT EXISTS Analysis
(
    an_id    INT AUTO_INCREMENT PRIMARY KEY,
    an_name  VARCHAR(50) NOT NULL,
    an_cost  INT         NOT NULL,
    an_price INT         NOT NULL,
    an_group INT
);

CREATE TABLE IF NOT EXISTS Groups_t
(
    gr_id   INT AUTO_INCREMENT PRIMARY KEY,
    gr_name VARCHAR(50) NOT NULL,
    gr_temp SMALLINT    NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders
(
    ord_id       INT AUTO_INCREMENT PRIMARY KEY,
    ord_datetime DATETIME NOT NULL,
    ord_an       INT
);

ALTER TABLE Analysis
    ADD FOREIGN KEY (an_group) REFERENCES Groups_t (gr_id);

ALTER TABLE Orders
    ADD FOREIGN KEY (ord_an) REFERENCES Analysis (an_id);

INSERT INTO Groups_t (gr_name, gr_temp) VALUE
    ('Group I', 10),
    ('Group II', 0),
    ('Group III', -10);

INSERT INTO Analysis (an_name, an_cost, an_price, an_group) VALUE
    ('Общий анализ крови', 100, 200, 1),
    ('Общий анализ мочи', 90, 170, 1),
    ('Биохимический анализ крови', 150, 280, 1),
    ('Анализ кала', 200, 450, 2),
    ('Электрокардиограмма', 500, 1200, 3),
    ('Флюорография', 500, 800, 3),
    ('Клинический анализ крови на гормоны', 800, 2000, 1);

INSERT INTO Orders (ord_datetime, ord_an) VALUE
    ('2020-02-04 09:17:00', 1),
    ('2021-02-04 10:12:00', 2),
    ('2020-02-05 09:19:00', 3),
    ('2020-02-08 10:17:00', 3),
    ('2022-02-04 13:57:00', 2),
    ('2020-03-04 10:34:00', 2),
    ('2020-04-09 16:27:00', 1),
    ('2023-02-04 14:24:00', 1),
    ('2020-06-03 11:16:00', 1),
    ('2020-02-04 08:10:00', 1);

SELECT A.an_name, A.an_price
FROM Analysis A
         JOIN Orders O on A.an_id = O.ord_an
WHERE (SELECT CAST(O.ord_datetime AS DATE)) BETWEEN '2020-02-05' AND '2020-02-12';


# Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение,
# мы вычитаем время станций для пар смежных станций. Мы можем вычислить это значение без использования
# оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD .
# Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат.
# В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.

CREATE TABLE IF NOT EXISTS Train
(
    train_id      INT         NOT NULL,
    station      VARCHAR(20) NOT NULL,
    station_time TIME        NOT NULL
);

INSERT INTO Train VALUE
    (110, 'San Francisco', '10:00:00'),
    (110, 'Redwood City', '10:54:00'),
    (110, 'Palo Alto', '11:02:00'),
    (110, 'San Jose', '12:35:00'),
    (120, 'San Francisco', '11:00:00'),
    (120, 'Palo Alto', '12:49:00'),
    (120, 'San Jose', '13:30:00');


SELECT train_id,
       station,
       station_time,
       TIMEDIFF(LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time),
                station_time) AS time_to_next_station
FROM Train;
