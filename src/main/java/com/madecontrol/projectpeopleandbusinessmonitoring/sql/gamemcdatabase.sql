DROP SCHEMA gamemcdatabase CASCADE;

CREATE SCHEMA gamemcdatabase;
SET search_path TO gamemcdatabase;


/* Создание своих ENUM типов */
CREATE TYPE money_currency AS ENUM('USD','EUR','UAH','RUR');
CREATE TYPE moneystorage_type AS ENUM('INCOME','INVESTMENT');



/* Создание таблиц */
/* Создание таблиц */
/* Создание таблиц */

CREATE TABLE man (
	id SERIAL PRIMARY KEY,
	name TEXT,
	job_id INT,
	position_id INT,
	moneystorage_id INT,
	town_id INT
);

CREATE TABLE moneystorage (
	id SERIAL PRIMARY KEY,
	money NUMERIC,
	currency money_currency,
	type moneystorage_type,
	man_id INT
);

CREATE TABLE job (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	salary NUMERIC,
	currency money_currency
);

CREATE TABLE position (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	salary NUMERIC,
	currency money_currency
);

CREATE TABLE job_position (
	job_id INT REFERENCES job(id) ON DELETE RESTRICT,
	position_id INT REFERENCES position(id) ON DELETE RESTRICT,
	PRIMARY KEY (job_id, position_id)
);

CREATE TABLE item (
	id SERIAL PRIMARY KEY,
	name TEXT,
	price NUMERIC,
	currency money_currency,
	quantity INT,
	man_id INT
);

CREATE TABLE business (
	id SERIAL PRIMARY KEY,
	name TEXT,
	minincome NUMERIC,
	maxincome NUMERIC,
	income NUMERIC,
	incomecurrency money_currency,
	price NUMERIC,
	pricecurrency money_currency,
	quantity INT,
	bribe NUMERIC,
	taxcontrol BOOLEAN,
	arrest BOOLEAN,
	town_id INT
);

CREATE TABLE business_owner (
	id SERIAL PRIMARY KEY,
	man_id INT,
	coefficient NUMERIC,
	business_id INT
);

CREATE TABLE investment (
	id SERIAL PRIMARY KEY,
	name TEXT,
	income NUMERIC,
	incomecurrency money_currency,
	price NUMERIC,
	pricecurrency money_currency,
	coefficient NUMERIC,
	bribe NUMERIC,
	taxcontrol BOOLEAN,
	arrest BOOLEAN,
	town_id INT
);

CREATE TABLE investment_owner (
	id SERIAL PRIMARY KEY,
	man_id INT,
	coefficient NUMERIC,
	investment_id INT
);

CREATE TABLE rent (
	id SERIAL PRIMARY KEY,
	name TEXT,
	income NUMERIC,
	incomecurrency money_currency,
	quantity INT,
	sqmeter INT,
	pricesqmeter NUMERIC,
	bribe NUMERIC,
	taxcontrol BOOLEAN,
	arrest BOOLEAN,
	town_id INT
);

CREATE TABLE rent_owner (
	id SERIAL PRIMARY KEY,
	man_id INT,
	coefficient NUMERIC,
	rent_id INT
);

CREATE TABLE racket (
	id SERIAL PRIMARY KEY,
	name TEXT,
	income NUMERIC,
	incomecurrency money_currency,
	quantity INT,
	racketmoney NUMERIC,
	bribe NUMERIC,
	arrest BOOLEAN,
	town_id INT
);

CREATE TABLE racket_owner (
	id SERIAL PRIMARY KEY,
	man_id INT,
	coefficient NUMERIC,
	racket_id INT
);

CREATE TABLE tax (
	id SERIAL PRIMARY KEY,
	name TEXT UNIQUE,
	coefficient NUMERIC CHECK (coefficient >= 0 AND coefficient <= 1.0)
);

/* Таблицы Страна, Область, Район, Город */
CREATE TABLE country(
	id SERIAL PRIMARY KEY,
	name TEXT,
	town_id INT
);

CREATE TABLE region(
	id SERIAL PRIMARY KEY,
	name TEXT,
	town_id INT,
	country_id INT
);

CREATE TABLE district(
	id SERIAL PRIMARY KEY,
	name TEXT,
	town_id INT,
	region_id INT
);

CREATE TABLE town(
	id SERIAL PRIMARY KEY,
	name TEXT,
	population INT,
	district_id INT
);

/* Департаменты и их работники */
CREATE TABLE department(
	id SERIAL PRIMARY KEY,
	name TEXT,
	position_id INT,
	department_id INT
);

CREATE TABLE employee(
	id SERIAL PRIMARY KEY,
	position_id INT,
	quantity INT,
	department_id INT
);

/* Создание связей между таблицами и редактирование значений полей */
/* Создание связей между таблицами и редактирование значений полей */
/* Создание связей между таблицами и редактирование значений полей */

ALTER TABLE man 
ALTER name SET NOT NULL,
ADD FOREIGN KEY(job_id) REFERENCES job(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(position_id) REFERENCES position(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(moneystorage_id) REFERENCES moneystorage(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE moneystorage
ADD CHECK (money >= 0),
ALTER currency SET NOT NULL,
ALTER type SET NOT NULL,
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE;

ALTER TABLE job
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD CHECK (salary >= 0),
ALTER currency SET NOT NULL;

ALTER TABLE position
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD CHECK (salary >= 0),
ALTER currency SET NOT NULL;

ALTER TABLE item
ALTER name SET NOT NULL,
ADD CHECK (price>=0),
ALTER currency SET NOT NULL,
ADD CHECK (quantity>=1),
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE;

ALTER TABLE business
ALTER name SET NOT NULL,
ADD CHECK (minincome >= 0 AND 
		   maxincome >= 0 AND
		   income >= 0 AND
		   price >= 0 AND
		   quantity >= 1 AND
		   bribe >= 0),
ALTER incomecurrency SET NOT NULL,
ALTER pricecurrency SET NOT NULL,
ALTER quantity SET DEFAULT 1,
ALTER bribe SET DEFAULT 0,
ALTER taxcontrol SET DEFAULT TRUE,
ALTER arrest SET DEFAULT FALSE,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE business_owner
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE,
ADD FOREIGN KEY (business_id) REFERENCES business(id) ON DELETE CASCADE,
ADD CHECK (coefficient >= 0 AND coefficient <= 1);

ALTER TABLE investment
ALTER name SET NOT NULL,
ADD CHECK (income >= 0 AND
		   price >= 0 AND
		   coefficient >= 0 AND
		   bribe >= 0),
ALTER incomecurrency SET NOT NULL,
ALTER pricecurrency SET NOT NULL,
ALTER bribe SET DEFAULT 0,
ALTER taxcontrol SET DEFAULT TRUE,
ALTER arrest SET DEFAULT FALSE,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE investment_owner
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE,
ADD FOREIGN KEY (investment_id) REFERENCES investment(id) ON DELETE CASCADE,
ADD CHECK (coefficient >= 0 AND coefficient <= 1);

ALTER TABLE rent
ALTER name SET NOT NULL,
ADD CHECK (income >= 0 AND
		   quantity >= 1 AND
		   sqmeter >= 1 AND
		   pricesqmeter >= 0 AND
		   bribe >= 0),
ALTER incomecurrency SET NOT NULL,
ALTER quantity SET DEFAULT 1,
ALTER bribe SET DEFAULT 0,
ALTER taxcontrol SET DEFAULT TRUE,
ALTER arrest SET DEFAULT FALSE,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE rent_owner
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE,
ADD FOREIGN KEY (rent_id) REFERENCES rent(id) ON DELETE CASCADE,
ADD CHECK (coefficient >= 0 AND coefficient <= 1);

ALTER TABLE racket
ALTER name SET NOT NULL,
ADD CHECK (income >= 0 AND
		   quantity >= 1 AND
		   racketmoney >= 0 AND
		   bribe >= 0),
ALTER incomecurrency SET NOT NULL,
ALTER quantity SET DEFAULT 1,
ALTER bribe SET DEFAULT 0,
ALTER arrest SET DEFAULT FALSE,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE racket_owner
ADD FOREIGN KEY (man_id) REFERENCES man(id) ON DELETE CASCADE,
ADD FOREIGN KEY (racket_id) REFERENCES racket(id) ON DELETE CASCADE,
ADD CHECK (coefficient >= 0 AND coefficient <= 1);

ALTER TABLE country
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT;

ALTER TABLE region
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(country_id) REFERENCES country(id) ON DELETE RESTRICT;

ALTER TABLE district
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD FOREIGN KEY(town_id) REFERENCES town(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(region_id) REFERENCES region(id) ON DELETE RESTRICT;

ALTER TABLE town
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD CHECK(population > 0),
ADD FOREIGN KEY(district_id) REFERENCES district(id) ON DELETE RESTRICT;

ALTER TABLE department
ADD UNIQUE(name),
ALTER name SET NOT NULL,
ADD FOREIGN KEY(position_id) REFERENCES position(id) ON DELETE RESTRICT,
ADD FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE;

ALTER TABLE employee
ADD FOREIGN KEY(position_id) REFERENCES position(id) ON DELETE CASCADE,
ADD CHECK(quantity >= 1),
ADD FOREIGN KEY(department_id) REFERENCES department(id) ON DELETE CASCADE;



/* Заполнение таблиц Страна, Область, Район, Город */
/* Заполнение таблиц Страна, Область, Район, Город */
/* Заполнение таблиц Страна, Область, Район, Город */
INSERT INTO country(name) VALUES('Украина');

/* 24 области Украины */
INSERT INTO region(name, country_id) VALUES('Винницкая область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Волынская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Днепропетровская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Донецкая область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Житомирская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Закарпатская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Запорожская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Ивано-Франковская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Киевская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Кировоградская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Луганская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Львовская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Николаевская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Одесская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Полтавская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Ровненская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Сумская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Тернопольская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Харьковская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Херсонская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Хмельницкая область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Черкасская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Черниговская область', (SELECT id FROM country WHERE name='Украина'));
INSERT INTO region(name, country_id) VALUES('Черновицкая область', (SELECT id FROM country WHERE name='Украина'));


/* ------------------------------------------------------------------------------------------------------------------------- */
/* Начало заполениния таблиц для Винницкой области */

/* Районы Винницкой области */
INSERT INTO district(name, region_id) VALUES('Винницкий район', (SELECT id FROM region WHERE name='Винницкая область'));
INSERT INTO district(name, region_id) VALUES('Гайсинский район', (SELECT id FROM region WHERE name='Винницкая область'));
INSERT INTO district(name, region_id) VALUES('Жмеринский район', (SELECT id FROM region WHERE name='Винницкая область'));
INSERT INTO district(name, region_id) VALUES('Могилёв-Подольский район', (SELECT id FROM region WHERE name='Винницкая область'));
INSERT INTO district(name, region_id) VALUES('Тульчинский район', (SELECT id FROM region WHERE name='Винницкая область'));
INSERT INTO district(name, region_id) VALUES('Хмельникский район', (SELECT id FROM region WHERE name='Винницкая область'));

/* Города Винницкого района */
INSERT INTO town(name, population, district_id) VALUES('Винница', 370000, (SELECT id FROM district WHERE name='Винницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Гнивань', 12000, (SELECT id FROM district WHERE name='Винницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Ильинцы', 11000, (SELECT id FROM district WHERE name='Винницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Липовец', 8000, (SELECT id FROM district WHERE name='Винницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Немиров', 12000, (SELECT id FROM district WHERE name='Винницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Погребище', 10000, (SELECT id FROM district WHERE name='Винницкий район'));

/* Города Гайсинского района */
INSERT INTO town(name, population, district_id) VALUES('Гайсин', 26000, (SELECT id FROM district WHERE name='Гайсинский район'));
INSERT INTO town(name, population, district_id) VALUES('Бершадь', 13000, (SELECT id FROM district WHERE name='Гайсинский район'));
INSERT INTO town(name, population, district_id) VALUES('Ладыжин', 23000, (SELECT id FROM district WHERE name='Гайсинский район'));

/* Города Жмеринского района */
INSERT INTO town(name, population, district_id) VALUES('Жмеринка', 34000, (SELECT id FROM district WHERE name='Жмеринский район'));
INSERT INTO town(name, population, district_id) VALUES('Бар', 16000, (SELECT id FROM district WHERE name='Жмеринский район'));
INSERT INTO town(name, population, district_id) VALUES('Шаргород', 7000, (SELECT id FROM district WHERE name='Жмеринский район'));

/* Города Могилёв-Подольского района */
INSERT INTO town(name, population, district_id) VALUES('Могилёв-Подольский', 31000, (SELECT id FROM district WHERE name='Могилёв-Подольский район'));
INSERT INTO town(name, population, district_id) VALUES('Ямполь', 11000, (SELECT id FROM district WHERE name='Могилёв-Подольский район'));

/* Города Тульчинского района */
INSERT INTO town(name, population, district_id) VALUES('Тульчин', 15000, (SELECT id FROM district WHERE name='Тульчинский район'));

/* Города Хмельникского района */
INSERT INTO town(name, population, district_id) VALUES('Хмельник', 27000, (SELECT id FROM district WHERE name='Хмельникский район'));
INSERT INTO town(name, population, district_id) VALUES('Калиновка', 19000, (SELECT id FROM district WHERE name='Хмельникский район'));
INSERT INTO town(name, population, district_id) VALUES('Казатин', 23000, (SELECT id FROM district WHERE name='Хмельникский район'));

/* Центры области и районов */
UPDATE region SET town_id=(SELECT id FROM town WHERE name='Винница') WHERE name='Винницкая область';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Винница') WHERE name='Винницкий район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Гайсин') WHERE name='Гайсинский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Жмеринка') WHERE name='Жмеринский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Могилёв-Подольский') WHERE name='Могилёв-Подольский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Тульчин') WHERE name='Тульчинский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Хмельник') WHERE name='Хмельникский район';

/* Конец заполениния таблиц для Винницкой области */
/* ------------------------------------------------------------------------------------------------------------------------- */

/* ------------------------------------------------------------------------------------------------------------------------- */
/* Начало заполениния таблиц для Киевской области */

/* Районы Киевской области */
INSERT INTO district(name, region_id) VALUES('Белоцерковский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Бориспольский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Броварский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Бучанский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Вышгородский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Обуховский район', (SELECT id FROM region WHERE name='Киевская область'));
INSERT INTO district(name, region_id) VALUES('Фастовский район', (SELECT id FROM region WHERE name='Киевская область'));

/* Столица Украины */
INSERT INTO town(name, population) VALUES('Киев', 3703000);

UPDATE country SET town_id=(SELECT id FROM town WHERE name='Киев') WHERE name='Украина';

/* Города Белоцерковского района */
INSERT INTO town(name, population, district_id) VALUES('Белая Церковь', 205000, (SELECT id FROM district WHERE name='Белоцерковский район'));
INSERT INTO town(name, population, district_id) VALUES('Сквира', 16000, (SELECT id FROM district WHERE name='Белоцерковский район'));
INSERT INTO town(name, population, district_id) VALUES('Тараща', 10000, (SELECT id FROM district WHERE name='Белоцерковский район'));
INSERT INTO town(name, population, district_id) VALUES('Тетиев', 13000, (SELECT id FROM district WHERE name='Белоцерковский район'));
INSERT INTO town(name, population, district_id) VALUES('Узин', 12000, (SELECT id FROM district WHERE name='Белоцерковский район'));

/* Города Бориспольского района */
INSERT INTO town(name, population, district_id) VALUES('Борисполь', 63000, (SELECT id FROM district WHERE name='Бориспольский район'));
INSERT INTO town(name, population, district_id) VALUES('Переяслав', 27000, (SELECT id FROM district WHERE name='Бориспольский район'));
INSERT INTO town(name, population, district_id) VALUES('Яготин', 20000, (SELECT id FROM district WHERE name='Бориспольский район'));

/* Города Броварского района */
INSERT INTO town(name, population, district_id) VALUES('Бровары', 109000, (SELECT id FROM district WHERE name='Броварский район'));
INSERT INTO town(name, population, district_id) VALUES('Березань', 17000, (SELECT id FROM district WHERE name='Броварский район'));

/* Города Бучанский района */
INSERT INTO town(name, population, district_id) VALUES('Буча', 36000, (SELECT id FROM district WHERE name='Бучанский район'));
INSERT INTO town(name, population, district_id) VALUES('Вишнёвое', 41000, (SELECT id FROM district WHERE name='Бучанский район'));
INSERT INTO town(name, population, district_id) VALUES('Ирпень', 60000, (SELECT id FROM district WHERE name='Бучанский район'));

/* Города Вышгородского района */
INSERT INTO town(name, population, district_id) VALUES('Вышгород', 30000, (SELECT id FROM district WHERE name='Вышгородский район'));
INSERT INTO town(name, population, district_id) VALUES('Славутич', 25000, (SELECT id FROM district WHERE name='Вышгородский район'));

/* Города Обуховского района */
INSERT INTO town(name, population, district_id) VALUES('Обухов', 33000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Богуслав', 16000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Васильков', 36000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Кагарлык', 14000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Мироновка', 11000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Ржищев', 7000, (SELECT id FROM district WHERE name='Обуховский район'));
INSERT INTO town(name, population, district_id) VALUES('Украинка', 16000, (SELECT id FROM district WHERE name='Обуховский район'));

/* Города Фастовского района */
INSERT INTO town(name, population, district_id) VALUES('Фастов', 45000, (SELECT id FROM district WHERE name='Фастовский район'));
INSERT INTO town(name, population, district_id) VALUES('Боярка', 35000, (SELECT id FROM district WHERE name='Фастовский район'));

/* Центры области и районов */
UPDATE region SET town_id=(SELECT id FROM town WHERE name='Киев') WHERE name='Киевская область';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Белая Церковь') WHERE name='Белоцерковский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Борисполь') WHERE name='Бориспольский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Бровары') WHERE name='Броварский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Буча') WHERE name='Бучанский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Буча') WHERE name='Вышгородский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Буча') WHERE name='Обуховский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Фастов') WHERE name='Фастовский район';

/* Конец заполениния таблиц для Киевской области */
/* ------------------------------------------------------------------------------------------------------------------------- */


/* ------------------------------------------------------------------------------------------------------------------------- */
/* Начало заполениния таблиц для Хмельницкой области */

/* Районы Хмельницкой области */
INSERT INTO district(name, region_id) VALUES('Хмельницкий район', (SELECT id FROM region WHERE name='Хмельницкая область'));
INSERT INTO district(name, region_id) VALUES('Каменец-Подольский район', (SELECT id FROM region WHERE name='Хмельницкая область'));
INSERT INTO district(name, region_id) VALUES('Шепетовский район', (SELECT id FROM region WHERE name='Хмельницкая область'));

/* Города Хмельницкого района */
INSERT INTO town(name, population, district_id) VALUES('Хмельницкий', 271000, (SELECT id FROM district WHERE name='Хмельницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Волочиск', 19000, (SELECT id FROM district WHERE name='Хмельницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Городок', 16000, (SELECT id FROM district WHERE name='Хмельницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Деражня', 10000, (SELECT id FROM district WHERE name='Хмельницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Красилов', 19000, (SELECT id FROM district WHERE name='Хмельницкий район'));
INSERT INTO town(name, population, district_id) VALUES('Староконстантинов', 34000, (SELECT id FROM district WHERE name='Хмельницкий район'));

/* Города Каменец-Подольского района */
INSERT INTO town(name, population, district_id) VALUES('Каменец-Подольский', 28000, (SELECT id FROM district WHERE name='Каменец-Подольский район'));
INSERT INTO town(name, population, district_id) VALUES('Дунаевцы', 16000, (SELECT id FROM district WHERE name='Каменец-Подольский район'));

/* Города Шепетовского района */
INSERT INTO town(name, population, district_id) VALUES('Шепетовка', 41000, (SELECT id FROM district WHERE name='Шепетовский район'));
INSERT INTO town(name, population, district_id) VALUES('Изяслав', 17000, (SELECT id FROM district WHERE name='Шепетовский район'));
INSERT INTO town(name, population, district_id) VALUES('Нетешин', 37000, (SELECT id FROM district WHERE name='Шепетовский район'));
INSERT INTO town(name, population, district_id) VALUES('Полонное', 21000, (SELECT id FROM district WHERE name='Шепетовский район'));
INSERT INTO town(name, population, district_id) VALUES('Славута', 35000, (SELECT id FROM district WHERE name='Шепетовский район'));

/* Центры области и районов */
UPDATE region SET town_id=(SELECT id FROM town WHERE name='Хмельницкий') WHERE name='Хмельницкая область';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Хмельницкий') WHERE name='Хмельницкий район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Каменец-Подольский') WHERE name='Каменец-Подольский район';
UPDATE district SET town_id=(SELECT id FROM town WHERE name='Шепетовка') WHERE name='Шепетовский район';

/* Конец заполениния таблиц для Хмельницкой области */
/* ------------------------------------------------------------------------------------------------------------------------- */


/* Заполнение таблицы Job(работы) */
/* Заполнение таблицы Job(работы) */
/* Заполнение таблицы Job(работы) */

INSERT INTO job(name, salary, currency) VALUES('Нету', 0, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Нету', 0, 'USD');

/* Верховная рада */
INSERT INTO job(name, salary, currency) VALUES('Народный депутат', 4000, 'USD');

/* Судьи */
INSERT INTO job(name, salary, currency) VALUES('Верховный судья', 6000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Судья', 3000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Помощник судьи', 1500, 'USD');

/* Депутаты */
INSERT INTO job(name, salary, currency) VALUES('Депутат областного совета', 2500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Депутат районного совета', 2000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Депутат городского совета', 1500, 'USD');

/* Ранги в армии */
INSERT INTO job(name, salary, currency) VALUES('Генерал армии', 2100, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Генерал-полковник', 2000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Генерал-лейтенант', 1900, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Генерал-майор', 1800, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Полковник', 1700, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Подполковник', 1600, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Майор', 1500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Капитан', 1400, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Старший лейтенант', 1300, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Лейтенант', 1200, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Младший лейтенант', 1100, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Старший прапорщик', 1000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Прапорщик', 900, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Старшина', 800, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Старший сержант', 700, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Сержант', 600, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Младший сержант', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Солдат', 400, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Рядовой', 300, 'USD');

/* Ранги врачей */
INSERT INTO job(name, salary, currency) VALUES('Хирург', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Стоматолог', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Терапевт', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Травматолог', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Гинеколог', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Венеролог', 500, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Фельдшер', 400, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Интерн', 300, 'USD');

/* Ранги в юстиции */
INSERT INTO job(name, salary, currency) VALUES('Прокурор', 2000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Помощник прокурора', 1000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Адвокат', 1000, 'USD');
INSERT INTO job(name, salary, currency) VALUES('Помощник адвоката', 500, 'USD');



/* Заполнение таблицы Position(должности) */
/* Заполнение таблицы Position(должности) */
/* Заполнение таблицы Position(должности) */

/* Президент и Кабинет министров */
INSERT INTO position(name, salary, currency) VALUES('Президент', 10000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Премьер-министр', 9000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель премьер-министра', 8000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр внутренних дел', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр обороны', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр здравоохранения', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр финансов', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр юстиции', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Министр энергетики', 7000, 'USD');

/* Власти области, района и города */
INSERT INTO position(name, salary, currency) VALUES('Губернатор', 5000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель губернатора', 4000, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Глава районной государственной администрации', 3500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель главы районной государственной администрации', 3000, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Мэр', 2500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель мэра', 2000, 'USD');

/* Директора и начальники */
INSERT INTO position(name, salary, currency) VALUES('Директор', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель директора', 1200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник отдела', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника отдела', 800, 'USD');

/* Должности Офиса Президента */
INSERT INTO position(name, salary, currency) VALUES('Глава Офиса президента', 8000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель главы Офиса президента', 6000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Руководитель Аппарата Офиса президента', 7000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Помощник президента', 5000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Советник президента', 5000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Пресс-секретарь президента', 5000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Представитель президента', 5000, 'USD');

/* Должности верховных судьев */
INSERT INTO position(name, salary, currency) VALUES('Председатель Большой Палаты Верхвоного Суда', 4000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя Большой Палаты Верхвоного Суда', 3000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Председатель кассационного административного суда', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Кассационный административный судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Председатель кассационного гражданского суда', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Кассационный гражданский судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Председатель кассационного уголовного суда', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Кассационный уголовный судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Председатель кассационного хозяйственного суда', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Кассационный хозяйственный судья', 1000, 'USD');

/* Должности апелляционных судьев */
INSERT INTO position(name, salary, currency) VALUES('Апелляционный административный судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Апелляционный гражданский судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Апелляционный уголовный судья', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Апелляционный хозяйственный судья', 1000, 'USD');

/* Должности местных судьев */
INSERT INTO position(name, salary, currency) VALUES('Административный судья', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Гражданский судья', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Уголовный судья', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Хозяйственный судья', 500, 'USD');

/* Должности прокуроров */
INSERT INTO position(name, salary, currency) VALUES('Генеральный прокурор', 3000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель генерального прокурора', 2500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Прокурор области', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель прокурора области', 1500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Прокурор района', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель прокурора района', 700, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Прокурор города', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель прокурора города', 200, 'USD');


/* Должности полиции */
INSERT INTO position(name, salary, currency) VALUES('Заместитель министра внутренних дел', 4000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник национальной полиции', 3000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника национальной полиции', 2500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник полиции области', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника полиции области', 1700, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник полиции района', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника полиции района', 1200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник полиции города', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника полиции города', 700, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник патрульной полиции', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника патрульной полиции', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший патрульный', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Патрульный', 100, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник внутренней безопасности', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника внутренней безопасности', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший агент внутренней безопасности', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Агент внутренней безопасности',100, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник киберполиции', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника киберполиции', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший инспектор киберполиции', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Инспектор киберполиции', 100, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник защиты экономики', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника защиты экономики', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший инспектор защиты экономики', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Инспектор защиты экономики', 100, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник полиции охраны', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника полиции охраны', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший охранник полиции', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Охранник полиции', 100, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Начальник КОРД', 500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника КОРД', 300, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Тренер КОРД', 200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Боец КОРД', 100, 'USD');

/* Должности народных депутатов */
INSERT INTO position(name, salary, currency) VALUES('Председатель Верховной рады', 3000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя Верховной рады', 2000, 'USD');


INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам антикоррупционной политики', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам антикоррупционной политики', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам антикоррупционной политики', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам бюджета', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам бюджета', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам бюджета', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам энергетики и жилищно-коммунальных услуг', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам энергетики и жилищно-коммунальных услуг', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам энергетики и жилищно-коммунальных услуг', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам финансов, налоговой и таможенной политики', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам финансов, налоговой и таможенной политики', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам финансов, налоговой и таможенной политики', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам правоохранительной деятельности', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам правоохранительной деятельности', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам правоохранительной деятельности', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства', 500, 'USD');

INSERT INTO position(name, salary, currency) VALUES('Председатель комитета по вопросам нацбезопасности, обороны и разведки', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель председателя комитета по вопросам нацбезопасности, обороны и разведки', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Член комитета по вопросам антикоррупционной нацбезопасности, обороны и разведки', 500, 'USD');

/* Врачи больницы */
INSERT INTO position(name, salary, currency) VALUES('Заместитель министра здравоохранения', 5000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник управления охраны здоровья области', 4000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника управления здравоохранения области', 3500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник управления охраны здоровья района', 3000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника управления охраны здоровья района', 2500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Начальник управления охраны здоровья города', 2000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель начальника управления охраны здоровья города', 1700, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Главный врач', 1500, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заместитель главного врача', 1200, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Заведующий отделением', 1000, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Старший специалист', 700, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Специалист', 600, 'USD');
INSERT INTO position(name, salary, currency) VALUES('Младший специалист', 500, 'USD');



/* Заполнение таблицы job_position (правила соответствия job и position) */
/* Заполнение таблицы job_position (правила соответствия job и position) */
/* Заполнение таблицы job_position (правила соответствия job и position) */

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Нету'));

/* Президент и Министры */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Президент'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Премьер-министр'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель премьер-министра'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр внутренних дел'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр обороны'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр финансов'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр юстиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Министр энергетики'));

/* Офис президента */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Глава Офиса президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель главы Офиса президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Руководитель Аппарата Офиса президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Помощник президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Советник президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Пресс-секретарь президента'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Представитель президента'));

/* Народные депутаты */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель Верховной рады'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя Верховной рады'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам антикоррупционной политики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам антикоррупционной политики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам антикоррупционной политики'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам бюджета'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам бюджета'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам бюджета'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам энергетики и жилищно-коммунальных услуг'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам энергетики и жилищно-коммунальных услуг'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам энергетики и жилищно-коммунальных услуг'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам здоровья нации, медицинской помощи и медицинского страхования'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам финансов, налоговой и таможенной политики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам финансов, налоговой и таможенной политики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам финансов, налоговой и таможенной политики'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам правоохранительной деятельности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам правоохранительной деятельности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам правоохранительной деятельности'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам организации государственной власти, местного самоуправления, регионального развития и градостроительства'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Председатель комитета по вопросам нацбезопасности, обороны и разведки'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Заместитель председателя комитета по вопросам нацбезопасности, обороны и разведки'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Народный депутат'), (SELECT id FROM position WHERE name='Член комитета по вопросам антикоррупционной нацбезопасности, обороны и разведки'));

/* Судьи */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Председатель Большой Палаты Верхвоного Суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Заместитель председателя Большой Палаты Верхвоного Суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Председатель кассационного административного суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Кассационный административный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Председатель кассационного гражданского суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Кассационный гражданский судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Председатель кассационного уголовного суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Кассационный уголовный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Председатель кассационного хозяйственного суда'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Верховный судья'), (SELECT id FROM position WHERE name='Кассационный хозяйственный судья'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Апелляционный административный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Апелляционный гражданский судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Апелляционный уголовный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Апелляционный хозяйственный судья'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Административный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Гражданский судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Уголовный судья'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Судья'), (SELECT id FROM position WHERE name='Хозяйственный судья'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Помощник судьи'), (SELECT id FROM position WHERE name='Нету'));

/* Власти области и городов */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Губернатор'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель губернатора'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Депутат областного совета'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Депутат районного совета'), (SELECT id FROM position WHERE name='Нету'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Мэр'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель мэра'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Депутат городского совета'), (SELECT id FROM position WHERE name='Нету'));

/* Правоохранительные органы */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал армии'), (SELECT id FROM position WHERE name='Заместитель министра внутренних дел'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Заместитель министра внутренних дел'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Заместитель министра внутренних дел'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Заместитель министра внутренних дел'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал армии'), (SELECT id FROM position WHERE name='Начальник национальной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Начальник национальной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Начальник национальной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Начальник национальной полиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Заместитель начальника национальной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Заместитель начальника национальной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Заместитель начальника национальной полиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Начальник полиции области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Начальник полиции области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Начальник полиции области'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Заместитель начальника полиции области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Заместитель начальника полиции области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Заместитель начальника полиции области'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Начальник полиции района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Начальник полиции района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник полиции района'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Заместитель начальника полиции района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Заместитель начальника полиции района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Заместитель начальника полиции района'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Начальник полиции города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник полиции города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник полиции города'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Заместитель начальника полиции города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника полиции города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника полиции города'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник патрульной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник патрульной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник патрульной полиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник внутренней безопасности'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник киберполиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник защиты экономики'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник полиции охраны'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник полиции охраны'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник полиции охраны'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Начальник КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Начальник КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Начальник КОРД'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника патрульной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника патрульной полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника патрульной полиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника внутренней безопасности'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника киберполиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника защиты экономики'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника полиции охраны'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника полиции охраны'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника полиции охраны'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Заместитель начальника КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Заместитель начальника КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Заместитель начальника КОРД'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Старший патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Старший патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Старший патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Старший патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Старший патрульный'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший прапорщик'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прапорщик'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старшина'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший сержант'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Сержант'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший сержант'), (SELECT id FROM position WHERE name='Патрульный'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Солдат'), (SELECT id FROM position WHERE name='Патрульный'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Старший агент внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Старший агент внутренней безопасности'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Агент внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Агент внутренней безопасности'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Агент внутренней безопасности'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Старший инспектор киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Старший инспектор киберполиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Инспектор киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Инспектор киберполиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Инспектор киберполиции'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Старший инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Старший инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Старший инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Старший инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Старший инспектор защиты экономики'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший прапорщик'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прапорщик'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старшина'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший сержант'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Сержант'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший сержант'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Солдат'), (SELECT id FROM position WHERE name='Инспектор защиты экономики'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Старший охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Старший охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Старший охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Старший охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Старший охранник полиции'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший прапорщик'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прапорщик'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старшина'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший сержант'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Сержант'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший сержант'), (SELECT id FROM position WHERE name='Охранник полиции'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Солдат'), (SELECT id FROM position WHERE name='Охранник полиции'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Тренер КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Тренер КОРД'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Боец КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Боец КОРД'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Боец КОРД'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал армии'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-полковник'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-лейтенант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Генерал-майор'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Полковник'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Подполковник'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Майор'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Капитан'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший лейтенант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Лейтенант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший лейтенант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший прапорщик'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прапорщик'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старшина'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Старший сержант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Сержант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Младший сержант'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Солдат'), (SELECT id FROM position WHERE name='Нету'));

/* Больница */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заместитель министра здравоохранения'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья области'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заместитель начальника управления здравоохранения области'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья района'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья района'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Начальник управления охраны здоровья города'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заместитель начальника управления охраны здоровья города'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Главный врач'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Главный врач'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Главный врач'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Главный врач'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Главный врач'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Главный врач'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заместитель главного врача'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заместитель главного врача'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заместитель главного врача'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заместитель главного врача'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заместитель главного врача'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заместитель главного врача'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Заведующий отделением'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Заведующий отделением'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Заведующий отделением'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Заведующий отделением'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Заведующий отделением'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Заведующий отделением'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Старший специалист'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Специалист'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Хирург'), (SELECT id FROM position WHERE name='Младший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Стоматолог'), (SELECT id FROM position WHERE name='Младший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Терапевт'), (SELECT id FROM position WHERE name='Младший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Травматолог'), (SELECT id FROM position WHERE name='Младший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Гинеколог'), (SELECT id FROM position WHERE name='Младший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Венеролог'), (SELECT id FROM position WHERE name='Младший специалист'));

INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Фельдшер'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Интерн'), (SELECT id FROM position WHERE name='Нету'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Директор'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель директора'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Начальник отдела'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Заместитель начальника отдела'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Старший специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Специалист'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Нету'), (SELECT id FROM position WHERE name='Младший специалист'));


/* Прокуроры */
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Генеральный прокурор'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Заместитель генерального прокурора'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Прокурор области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Заместитель прокурора области'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Прокурор района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Заместитель прокурора района'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Прокурор города'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Прокурор'), (SELECT id FROM position WHERE name='Заместитель прокурора города'));


INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Помощник прокурора'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Адвокат'), (SELECT id FROM position WHERE name='Нету'));
INSERT INTO job_position VALUES((SELECT id FROM job WHERE name='Помощник адвоката'), (SELECT id FROM position WHERE name='Нету'));


/* Департаменты */
/* Департаменты */
/* Департаменты */

 /* Кабинет Министров */
INSERT INTO department(name, position_id, department_id) 
VALUES('Кабинет Министров', (SELECT id FROM position WHERE name='Премьер-министр'), NULL);

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Премьер-министр'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));
	  
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель премьер-министра'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр внутренних дел'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр обороны'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));
	  
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр здравоохранения'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));	  
	  
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр финансов'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));	  
	  
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр юстиции'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));	  
	  
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр энергетики'), 1, (SELECT id FROM department WHERE name='Кабинет Министров'));	  
	  
	  
	  
/* Президент и Офис президента */
INSERT INTO department(name, position_id, department_id) 
VALUES('Офис президента', (SELECT id FROM position WHERE name='Глава Офиса президента'), NULL);

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Глава Офиса президента'), 1, (SELECT id FROM department WHERE name='Офис президента'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель главы Офиса президента'), 1, (SELECT id FROM department WHERE name='Офис президента'));	

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Руководитель Аппарата Офиса президента'), 1, (SELECT id FROM department WHERE name='Офис президента'));	

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Помощник президента'), 3, (SELECT id FROM department WHERE name='Офис президента'));	

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Советник президента'), 6, (SELECT id FROM department WHERE name='Офис президента'));	

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Пресс-секретарь президента'), 1, (SELECT id FROM department WHERE name='Офис президента'));	

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Представитель президента'), 6, (SELECT id FROM department WHERE name='Офис президента'));		



/* Губернатор и областная государственная администрация */
INSERT INTO department(name, position_id, department_id) 
VALUES('Областная государственная администрация', 
	   (SELECT id FROM position WHERE name='Губернатор'),
	   (SELECT id FROM department WHERE name='Офис президента'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Губернатор'), 1, (SELECT id FROM department WHERE name='Областная государственная администрация'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель губернатора'), 3, (SELECT id FROM department WHERE name='Областная государственная администрация'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Депутат областного совета'), 40, (SELECT id FROM department WHERE name='Областная государственная администрация'));	  



/* Управление агропромышленного развития */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление агропромышленного развития', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление агропромышленного развития'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление агропромышленного развития'));	  



/* Управление экономики */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление экономики', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление экономики'));	  



/* Управление финансов */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление финансов', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление финансов'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление финансов'));	  



/* Управление промышленности и развития инфраструктуры */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление промышленности и развития инфраструктуры', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление промышленности и развития инфраструктуры'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление промышленности и развития инфраструктуры'));	  



/* Управление жилищно-коммунального хозяйства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление жилищно-коммунального хозяйства', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление жилищно-коммунального хозяйства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление жилищно-коммунального хозяйства'));	  



/* Управление градостроительства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление градостроительства', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление градостроительства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление градостроительства'));	  



/* Управление благоустройства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление благоустройства', 
	   (SELECT id FROM position WHERE name='Директор'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Директор'), 1, (SELECT id FROM department WHERE name='Управление благоустройства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель директора'), 3, (SELECT id FROM department WHERE name='Управление благоустройства'));	  



/* Районная государственная администрация */
INSERT INTO department(name, position_id, department_id) 
VALUES('Районная государственная администрация', 
	   (SELECT id FROM position WHERE name='Глава районной государственной администрации'), 
	   (SELECT id FROM department WHERE name='Областная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Глава районной государственной администрации'), 1, (SELECT id FROM department WHERE name='Районная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель главы районной государственной администрации'), 3, (SELECT id FROM department WHERE name='Районная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Депутат районного совета'), 32, (SELECT id FROM department WHERE name='Районная государственная администрация'));



/* Городской совет */
INSERT INTO department(name, position_id, department_id) 
VALUES('Городской совет', 
	   (SELECT id FROM position WHERE name='Мэр'), 
	   (SELECT id FROM department WHERE name='Районная государственная администрация'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Мэр'), 1, (SELECT id FROM department WHERE name='Городской совет'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель мэра'), 1, (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Депутат городского совета'), 24, (SELECT id FROM department WHERE name='Городской совет'));


/* Отдел агропромышленного развития */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел агропромышленного развития', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел агропромышленного развития'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел агропромышленного развития'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел агропромышленного развития'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел агропромышленного развития'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел агропромышленного развития'));	  



/* Отдел экономики */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел экономики', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел экономики'));	  



/* Отдел финансов */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел финансов', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел финансов'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел финансов'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел финансов'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел финансов'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел финансов'));	  



/* Отдел промышленности и развития инфраструктуры */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел промышленности и развития инфраструктуры', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел промышленности и развития инфраструктуры'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел промышленности и развития инфраструктуры'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел промышленности и развития инфраструктуры'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел промышленности и развития инфраструктуры'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел промышленности и развития инфраструктуры'));	  



/* Отдел жилищно-коммунального хозяйства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел жилищно-коммунального хозяйства', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел жилищно-коммунального хозяйства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел жилищно-коммунального хозяйства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел жилищно-коммунального хозяйства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел жилищно-коммунального хозяйства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел жилищно-коммунального хозяйства'));	  



/* Отдел градостроительства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел градостроительства', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел градостроительства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел градостроительства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел градостроительства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел градостроительства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел градостроительства'));	  



/* Отдел благоустройства */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел благоустройства', 
	   (SELECT id FROM position WHERE name='Начальник отдела'), 
	   (SELECT id FROM department WHERE name='Городской совет'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник отдела'), 1, (SELECT id FROM department WHERE name='Отдел благоустройства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника отдела'), 1, (SELECT id FROM department WHERE name='Отдел благоустройства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший специалист'), 1, (SELECT id FROM department WHERE name='Отдел благоустройства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Специалист'), 3, (SELECT id FROM department WHERE name='Отдел благоустройства'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Младший специалист'), 9, (SELECT id FROM department WHERE name='Отдел благоустройства'));	  












/* Министерство внутренних дел */
/* Министерство внутренних дел */
/* Министерство внутренних дел */
INSERT INTO department(name, position_id, department_id) 
VALUES('Министерство внутренних дел', 
	   (SELECT id FROM position WHERE name='Министр внутренних дел'), 
	   (SELECT id FROM department WHERE name='Кабинет Министров'));
	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Министр внутренних дел'), 1, (SELECT id FROM department WHERE name='Министерство внутренних дел'));	  
	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель министра внутренних дел'), 3, (SELECT id FROM department WHERE name='Министерство внутренних дел'));	  
	   
	   	   
/* Управление национальной полиции */	   
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление национальной полиции', 
	   (SELECT id FROM position WHERE name='Начальник национальной полиции'), 
	   (SELECT id FROM department WHERE name='Министерство внутренних дел'));
	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник национальной полиции'), 1, (SELECT id FROM department WHERE name='Управление национальной полиции'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника национальной полиции'), 1, (SELECT id FROM department WHERE name='Управление национальной полиции'));	  
	   
	   
/* Управление полиции области */	  
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление полиции области', 
	   (SELECT id FROM position WHERE name='Начальник полиции области'), 
	   (SELECT id FROM department WHERE name='Управление национальной полиции'));
	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник полиции области'), 1, (SELECT id FROM department WHERE name='Управление полиции области'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника полиции области'), 1, (SELECT id FROM department WHERE name='Управление полиции области'));	  

	   
/* Управление полиции района */   
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление полиции района', 
	   (SELECT id FROM position WHERE name='Начальник полиции района'), 
	   (SELECT id FROM department WHERE name='Управление полиции области'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник полиции района'), 1, (SELECT id FROM department WHERE name='Управление полиции района'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника полиции района'), 1, (SELECT id FROM department WHERE name='Управление полиции района'));	  


/* Управление полиции города */
INSERT INTO department(name, position_id, department_id) 
VALUES('Управление полиции города', 
	   (SELECT id FROM position WHERE name='Начальник полиции города'), 
	   (SELECT id FROM department WHERE name='Управление полиции района'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник полиции города'), 1, (SELECT id FROM department WHERE name='Управление полиции города'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника полиции города'), 1, (SELECT id FROM department WHERE name='Управление полиции города'));	  


/* Отдел патрульной полиции */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел патрульной полиции', 
	   (SELECT id FROM position WHERE name='Начальник патрульной полиции'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник патрульной полиции'), 1, (SELECT id FROM department WHERE name='Отдел патрульной полиции'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника патрульной полиции'), 1, (SELECT id FROM department WHERE name='Отдел патрульной полиции'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший патрульный'), 25, (SELECT id FROM department WHERE name='Отдел патрульной полиции'));	  
	   	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Патрульный'), 100, (SELECT id FROM department WHERE name='Отдел патрульной полиции'));	  


/* Отдел внутренней безопасности */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел внутренней безопасности', 
	   (SELECT id FROM position WHERE name='Начальник внутренней безопасности'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));
	   
INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник внутренней безопасности'), 1, (SELECT id FROM department WHERE name='Отдел внутренней безопасности'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника внутренней безопасности'), 1, (SELECT id FROM department WHERE name='Отдел внутренней безопасности'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший агент внутренней безопасности'), 10, (SELECT id FROM department WHERE name='Отдел внутренней безопасности'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Агент внутренней безопасности'), 40, (SELECT id FROM department WHERE name='Отдел внутренней безопасности'));	  


/* Отдел киберполиции */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел киберполиции', 
	   (SELECT id FROM position WHERE name='Начальник киберполиции'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник киберполиции'), 1, (SELECT id FROM department WHERE name='Отдел киберполиции'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника киберполиции'), 1, (SELECT id FROM department WHERE name='Отдел киберполиции'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший инспектор киберполиции'), 10, (SELECT id FROM department WHERE name='Отдел киберполиции'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Инспектор киберполиции'), 40, (SELECT id FROM department WHERE name='Отдел киберполиции'));	 


/* Отдел защиты экономики */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел защиты экономики', 
	   (SELECT id FROM position WHERE name='Начальник защиты экономики'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник защиты экономики'), 1, (SELECT id FROM department WHERE name='Отдел защиты экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника защиты экономики'), 1, (SELECT id FROM department WHERE name='Отдел защиты экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший инспектор защиты экономики'), 10, (SELECT id FROM department WHERE name='Отдел защиты экономики'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Инспектор защиты экономики'), 40, (SELECT id FROM department WHERE name='Отдел защиты экономики'));	  


/* Отдел полиции охраны */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел полиции охраны', 
	   (SELECT id FROM position WHERE name='Начальник полиции охраны'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник полиции охраны'), 1, (SELECT id FROM department WHERE name='Отдел полиции охраны'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника полиции охраны'), 1, (SELECT id FROM department WHERE name='Отдел полиции охраны'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Старший охранник полиции'), 25, (SELECT id FROM department WHERE name='Отдел полиции охраны'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Охранник полиции'), 100, (SELECT id FROM department WHERE name='Отдел полиции охраны'));


/* Отдел КОРД */
INSERT INTO department(name, position_id, department_id) 
VALUES('Отдел КОРД', 
	   (SELECT id FROM position WHERE name='Начальник КОРД'), 
	   (SELECT id FROM department WHERE name='Управление полиции города'));

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Начальник КОРД'), 1, (SELECT id FROM department WHERE name='Отдел КОРД'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Заместитель начальника КОРД'), 1, (SELECT id FROM department WHERE name='Отдел КОРД'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Тренер КОРД'), 10, (SELECT id FROM department WHERE name='Отдел КОРД'));	  

INSERT INTO employee(position_id, quantity, department_id) 
VALUES((SELECT id FROM position WHERE name='Боец КОРД'), 40, (SELECT id FROM department WHERE name='Отдел КОРД'));	 

