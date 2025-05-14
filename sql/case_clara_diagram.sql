CREATE TABLE `user_table` (
    `user_id` VARCHAR(10) PRIMARY KEY,
    `date` DATE,
    `device` ENUM('Desktop', 'Mobile'),
    `sex` ENUM('Female', 'Male')
);

CREATE TABLE `home_page_table` (
    `user_id` VARCHAR(10),
    `page` ENUM('home_page')
);

CREATE TABLE `payment_confirmation_table` (
    `user_id` VARCHAR(10),
    `page` ENUM('payment_confirmation_page')
);

CREATE TABLE `payment_page_table` (
    `user_id` VARCHAR(10),
    `page` ENUM('payment_page')
);

CREATE TABLE `search_page_table` (
    `user_id` VARCHAR(10),
    `page` ENUM('search_page')
);

ALTER TABLE `home_page_table` ADD FOREIGN KEY (`user_id`) REFERENCES `user_table` (`user_id`);

ALTER TABLE `payment_confirmation_table` ADD FOREIGN KEY (`user_id`) REFERENCES `user_table` (`user_id`);

ALTER TABLE `payment_page_table` ADD FOREIGN KEY (`user_id`) REFERENCES `user_table` (`user_id`);

ALTER TABLE `search_page_table` ADD FOREIGN KEY (`user_id`) REFERENCES `user_table` (`user_id`);