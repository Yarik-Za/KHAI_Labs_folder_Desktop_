-- створюємо точні копії таблиць
CREATE TABLE prices LIKE `вартість бензину`;
CREATE TABLE sales LIKE `продаж`;
CREATE TABLE client LIKE `клієнт`;

-- копіюємо дані в нові таблиці
INSERT INTO prices SELECT * FROM `вартість бензину`;
INSERT INTO sales SELECT * FROM `продаж`;
INSERT INTO client SELECT * FROM `клієнт`;

-- створюємо нову БД, яка буде мати дані в зашифрованному вигляді
create database lw07var10bk;

-- переносимо копії таблиць у нову БД
RENAME TABLE lw07var10.prices TO lw07var10bk.prices;
RENAME TABLE lw07var10.sales TO lw07var10bk.sales;
RENAME TABLE lw07var10.client TO lw07var10bk.client;

-- створюємо нові ролі
--CREATE ROLE Guest, OperatorP,  OperatorC, OperatorSL;
CREATE ROLE 'Guest'@'localhost';
CREATE ROLE 'OperatorP'@'localhost';
CREATE ROLE 'OperatorC'@'localhost';
CREATE ROLE 'OperatorSL'@'localhost';

-- перевіріямо створення ролей
SELECT user FROM mysql.user;

-- створення нових користувачів
CREATE USER 'SimpleUser'@'localhost' PASSWORD EXPIRE DEFAULT;
CREATE USER 'UserP'@'localhost' PASSWORD EXPIRE DEFAULT;
CREATE USER 'UserC'@'localhost' PASSWORD EXPIRE DEFAULT;
CREATE USER 'UserSL'@'localhost' PASSWORD EXPIRE DEFAULT;

-- присвоєння паролей користувачам
ALTER USER 'SimpleUser'@'localhost' IDENTIFIED BY 'SimpleUser';
ALTER USER 'UserP'@'localhost' IDENTIFIED BY 'UserP';
ALTER USER 'UserC'@'localhost' IDENTIFIED BY 'UserC';
ALTER USER 'UserSL'@'localhost' IDENTIFIED BY 'UserSL';

-- надання привілегій ролям
GRANT SELECT ON lw07var10bk.* TO 'Guest'@'localhost';
GRANT SELECT,INSERT, UPDATE, DELETE ON lw07var10bk.prices TO 'OperatorP'@'localhost';
GRANT SELECT,INSERT, UPDATE, DELETE ON lw07var10bk.client TO 'OperatorC'@'localhost';
GRANT INSERT, UPDATE, DELETE ON lw07var10bk.sales TO 'OperatorSL'@'localhost'; 
GRANT SELECT ON lw07var10bk.* TO 'OperatorSL'@'localhost';


--DROP USER 'SimpleUser'@'localhost';
--DROP USER 'UserP'@'localhost';
--DROP USER 'UserC'@'localhost';
--DROP USER 'UserSL'@'localhost';
--flush privileges;



FLUSH PRIVILEGES;
-- присвоєння ролей користувачам БД
Grant 'Guest'@'localhost' TO 'SimpleUser'@'localhost';
Set default role 'Guest'@'localhost' to 'SimpleUser'@'localhost';

Grant 'UserP'@'localhost' TO 'OperatorP'@'localhost';
Set default role 'UserP'@'localhost' to 'OperatorP'@'localhost';

Grant 'UserC'@'localhost' TO 'OperatorC'@'localhost';
Set default role 'UserC'@'localhost' to 'OperatorC'@'localhost';

Grant 'UserSL'@'localhost' TO 'OperatorSL'@'localhost';
Set default role 'UserSL'@'localhost' to 'OperatorSL'@'localhost';

-- перегляд привілегій ролі
SHOW GRANTS for Guest@localhost;

-- редагування привілегій ролі
GRANT SELECT ON lw07var10bk.* TO 'Guest' @'localhost';
-- перегляд відредагованих привілегій ролі
SHOW GRANTS for 'Guest'@'localhost'
-- розблокування користувачів 
ALTER USER 'SimpleUser'@'localhost' ACCOUNT UNLOCK;
ALTER USER 'UserP'@'localhost' ACCOUNT UNLOCK;
ALTER USER 'UserC'@'localhost' ACCOUNT UNLOCK;
ALTER USER 'UserSL'@'localhost' ACCOUNT UNLOCK;

-- створення шифрованої таблиці з ключем
CREATE TABLE passTB (
    pass VARBINARY(150)DEFAULT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- заносимо ключ та шифруємо запис
INSERT INTO passTB (pass)
VALUES (aes_encrypt('P@$$w0rd', 'dji28173940'));

-- процедура перевірки паролів
DELIMITER //
CREATE PROCEDURE ComparePassword(
    IN input_password VARCHAR(255),
    OUT is_match BOOLEAN
)
BEGIN
    DECLARE decrypted_pass VARBINARY(150);

    -- Спробуємо розшифрувати пароль з таблиці passtb використовуючи введений пароль
    SET decrypted_pass = AES_DECRYPT(
        (SELECT pass FROM passtb LIMIT 1),
        input_password
    );

    -- Якщо розшифрування успішне і пароль не порожній, тоді паролі збігаються
    IF decrypted_pass IS NOT NULL THEN
        SET is_match = TRUE;
    ELSE
        SET is_match = FALSE;
    END IF;
END //
DELIMITER ;


-- створення шифрованих таблиць

-- Таблиця client
CREATE TABLE `client_encrypted` (
  `idAccount` int(11) NOT NULL,
  `DateGiven` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `LastName` VARBINARY(255) NOT NULL,
  `FirstName` VARBINARY(255) NOT NULL,
  `Father` VARBINARY(255) NOT NULL,
  `Percent` enum('0','1','2','3','4','5') NOT NULL,
  PRIMARY KEY (`idAccount`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Таблиця prices
CREATE TABLE `prices_encrypted` (
  `ДатаВстановленняВартості` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `МаркаБенизну` enum('А-76','А-92','А-95','А-98') CHARACTER SET cp1251 COLLATE cp1251_ukrainian_ci NOT NULL,
  `ЦінаПродажу_грн` VARBINARY(255) NOT NULL,
  `КодВартості` VARBINARY(255) NOT NULL,
  PRIMARY KEY (`КодВартості`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Таблица sales
CREATE TABLE `sales_encrypted` (
  `НомерПродажу` int(11) NOT NULL,
  `ДатаПродажу` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `НомерДисконту` VARBINARY(255) NOT NULL,
  `МаркаБензину` enum('А-76','А-92','А-95','А-98') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `КількістьЛітрів_л` VARBINARY(255) NOT NULL,
  `КодВартості` VARBINARY(255) NOT NULL,
  PRIMARY KEY (`НомерПродажу`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- шифрування існуючих данних
DELIMITER //
CREATE PROCEDURE EncryptAllTablesData(
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, шифруем данные
    IF is_match THEN
        -- Шифрование данных из таблицы `client`
        INSERT INTO `client_encrypted` (`idAccount`, `DateGiven`, `LastName`, `FirstName`, `Father`, `Percent`)
        SELECT 
            `idAccount`,
            `DateGiven`,
            AES_ENCRYPT(`LastName`, input_password),
            AES_ENCRYPT(`FirstName`, input_password),
            AES_ENCRYPT(`Father`, input_password),
            `Percent`
        FROM `client`;

        -- Шифрование данных из таблицы `prices`
        INSERT INTO `prices_encrypted` (`ДатаВстановленняВартості`, `МаркаБенизну`, `ЦінаПродажу_грн`, `КодВартості`)
        SELECT 
            `ДатаВстановленняВартості`,
            `МаркаБенизну`,
            AES_ENCRYPT(`ЦінаПродажу_грн`, input_password),
            AES_ENCRYPT(`КодВартості`, input_password)
        FROM `prices`;

        -- Шифрование данных из таблицы `sales`
        INSERT INTO `sales_encrypted` (`НомерПродажу`, `ДатаПродажу`, `НомерДисконту`, `МаркаБензину`, `КількістьЛітрів_л`, `КодВартості`)
        SELECT 
            `НомерПродажу`,
            `ДатаПродажу`,
            AES_ENCRYPT(`НомерДисконту`, input_password),
            `МаркаБензину`,
            AES_ENCRYPT(`КількістьЛітрів_л`, input_password),
            AES_ENCRYPT(`КодВартості`, input_password)
        FROM `sales`;
		 ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
    END IF;
END //
DELIMITER ;

-- пееревірка шифрування
SELECT * FROM `sales_encrypted` limit 3;
SELECT * FROM `prices_encrypted` limit 3;
SELECT * FROM `client_encrypted` limit 3;

-- Процедура для перегляду таблиці client_encrypted
DELIMITER //
CREATE PROCEDURE UnlockClientDataView(
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, показываем зашифрованные данные
    IF is_match THEN
        SELECT 
            `idAccount`, 
            `DateGiven`, 
            AES_DECRYPT(`LastName`, input_password) AS `LastName`, 
            AES_DECRYPT(`FirstName`, input_password) AS `FirstName`, 
            AES_DECRYPT(`Father`, input_password) AS `Father`, 
            `Percent`
        FROM 
            `client_encrypted`;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
	END IF;
END //
DELIMITER ;

-- Процедура для перегляду таблиці prices_encrypted
DELIMITER //
CREATE PROCEDURE UnlockPricesDataView(
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, показываем зашифрованные данные
    IF is_match THEN
        SELECT 
            `ДатаВстановленняВартості`, 
            `МаркаБенизну`, 
            AES_DECRYPT(`ЦінаПродажу_грн`, input_password) AS `ЦінаПродажу_грн`, 
            AES_DECRYPT(`КодВартості`, input_password) AS `КодВартості`
        FROM 
            `prices_encrypted`;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
		END IF;
END //
DELIMITER ;

-- Процедура для перегляду таблиці sales_encrypted
DELIMITER //
CREATE PROCEDURE UnlockSalesDataView(
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, показываем зашифрованные данные
    IF is_match THEN
        SELECT 
            `НомерПродажу`, 
            `ДатаПродажу`, 
            AES_DECRYPT(`НомерДисконту`, input_password) AS `НомерДисконту`, 
            `МаркаБензину`, 
            AES_DECRYPT(`КількістьЛітрів_л`, input_password) AS `КількістьЛітрів_л`, 
            AES_DECRYPT(`КодВартості`, input_password) AS `КодВартості`
        FROM 
            `sales_encrypted`;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
		END IF;
END //
DELIMITER ;

-- перевірка перегляду з розшифровкою частини даних таблиць
CALL UnlockClientDataView('dji28173940');
CALL UnlockPricesDataView('dji28173940');
CALL UnlockSalesDataView('dji28173940');

-- Процедура для вставки данних в таблицю client_encrypted
DELIMITER //
CREATE PROCEDURE InsertIntoClientEncrypted(
    IN input_password VARCHAR(255),
    IN idAccount INT,
    IN LastName VARBINARY(255),
    IN FirstName VARBINARY(255),
    IN Father VARBINARY(255),
    IN Percent ENUM('0','1','2','3','4','5')
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, вставляем данные
    IF is_match THEN
        INSERT INTO `client_encrypted` (`idAccount`, `DateGiven`, `LastName`, `FirstName`, `Father`, `Percent`)
        VALUES (idAccount,
		Now(),
		AES_ENCRYPT(LastName, input_password),
		AES_ENCRYPT(FirstName, input_password),
		AES_ENCRYPT(Father, input_password), Percent);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
		END IF;
END //
DELIMITER ;

-- Процедура для вставки данних в таблицю prices_encrypted
DELIMITER //
CREATE PROCEDURE InsertIntoPricesEncrypted(
    IN input_password VARCHAR(255),
    IN МаркаБенизну ENUM('А-76','А-92','А-95','А-98'),
    IN ЦінаПродажу_грн DECIMAL(4,2),
    IN КодВартості VARBINARY(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, вставляем данные
    IF is_match THEN
        INSERT INTO `prices_encrypted` (`ДатаВстановленняВартості`, `МаркаБенизну`,
		`ЦінаПродажу_грн`, `КодВартості`)
        VALUES (Now(), МаркаБенизну,
		AES_ENCRYPT(ЦінаПродажу_грн, input_password),
		AES_ENCRYPT(КодВартості, input_password));
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
		END IF;
END //
DELIMITER ;

-- Процедура для вставки данних в таблицю sales_encrypted
DELIMITER //
CREATE PROCEDURE InsertIntoSalesEncrypted(
    IN input_password VARCHAR(255),
    IN НомерПродажу INT,
    IN НомерДисконту VARBINARY(255),
    IN МаркаБензину ENUM('А-76','А-92','А-95','А-98'),
    IN КількістьЛітрів_л INT,
    IN КодВартості VARBINARY(255)
)
BEGIN
    DECLARE is_match BOOLEAN DEFAULT FALSE;
    
    -- Вызов процедуры для проверки пароля
    CALL ComparePassword(input_password, is_match);
    
    -- Если пароль правильный, вставляем данные
    IF is_match THEN
        INSERT INTO `sales_encrypted` (
            `НомерПродажу`, 
            `ДатаПродажу`,
            `НомерДисконту`, 
            `МаркаБензину`, 
            `КількістьЛітрів_л`, 
            `КодВартості`
        )
        VALUES (
            НомерПродажу, 
            NOW(), 
            AES_ENCRYPT(НомерДисконту, input_password),
            МаркаБензину,
            AES_ENCRYPT(КількістьЛітрів_л, input_password),
            AES_ENCRYPT(КодВартості, input_password)
        );
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid password for encryption key';
    END IF;
END //
DELIMITER ;

-- перевірка вставки зашифрованих даних
-- Вставка запису в таблицю client_encrypted
CALL InsertIntoClientEncrypted(
    'dji28173940', 1, 'Doe', 'John', 'Smith', '2'
);

-- Вставка запису в таблицю prices_encrypted
CALL InsertIntoPricesEncrypted(
    'dji28173940', 'А-95', 23.45, '12345'
);

-- Вставка запису в таблицю sales_encrypted
CALL InsertIntoSalesEncrypted(
    'dji28173940', 1, '67890', 'А-95', 50, '12345'
);

CALL GetClientData('dji28173940');
CALL GetPricesData('dji28173940');
CALL GetSalesData('dji28173940');









