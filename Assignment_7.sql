--- Assignment 7 ---

--- 1a ---
use sakila;
select first_name, last_name
from actor;

--- 1b ---

SELECT CONCAT(first_name, ' ', last_name)
AS 'Actor Name'
FROM actor;

SELECT CONCAT(
CONCAT(LEFT(first_name, 1), SUBSTRING(LOWER(first_name, 2))), 
CONCAT(LEFT(last_name, 1), SUBSTRING(LOWER(last_name, 2))))
AS 'Actor Name'
FROM actor;

SELECT
CONCAT(LEFT(first_name, 1)), SUBSTRING(LOWER(first_name), 2)) AS 'First Name',
CONCAT(LEFT(last_name, 1), SUBSTRING(LOWER(last_name), 2)) AS 'Last Name'
from actor;

--- 2a ---
SELECT actor_id, last_name, first_name
FROM actor
WHERE first_name = 'Joe';

--- 2b ---
SELECT actor_id, last_name, first_name 
FROM actor
WHERE last_name LIKE '%GEN%';

--- 2c ---
SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

--- 2d ----
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

--- 3a ---
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE actor
ADD description BLOB;
SELECT * FROM actor;
SET SQL_SAFE_UPDATES = 1;

--- 3b ---
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE actor
DROP COLUMN description;
SET SQL_SAFE_UPDATES = 1;

--- 4a ---
SELECT last_name, count(last_name) AS 'Total Count'
FROM actor
GROUP BY last_name;

--- 4b ---
SELECT last_name, COUNT(last_name) AS 'Total Count'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;


--- 4c ---
SET SQL_SAFE_UPDATES = 0;

UPDATE actor SET first_name = 'HARPO'
WHERE actor_id = 172;

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM actor
WHERE last_name = 'Williams';

--- 4d ---
SET SQL_SAFE_UPDATES = 0;

UPDATE actor SET first_name = 'GROUCHO'
WHERE actor_id = 172;

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM actor
WHERE last_name = 'Williams';


--- 5a ---
SHOW CREATE TABLE address;
DESCRIBE address;

--- 6a ---
SELECT first_name, last_name, address
FROM staff
INNER JOIN address USING (address_id);

--- 6b ---
SELECT last_name, first_name, SUM(amount) AS 'Total Amount'
FROM payment
INNER JOIN staff USING (staff_id)
GROUP BY payment.staff_id;

--- 6c ---
SELECT film.title, COUNT(actor_id) AS 'Number of Actor'
FROM film
INNER JOIN film_actor USING (film_id)
GROUP BY film.title;

--- 6d ---
SELECT film.title, COUNT(inventory_id) AS 'Copies in Inventory'
FROM inventory
INNER JOIN film USING (film_id)
WHERE film.title = 'Hunchback Impossible';

--- 6e ---
SELECT last_name, first_name, SUM(amount) AS 'Total Amount Paid'
FROM payment
INNER JOIN customer USING (customer_id)
GROUP BY payment.customer_id
ORDER BY customer.last_name ASC;

--- 7a ---
SELECT title
FROM film
WHERE title LIKE 'K%' or title LIKE 'Q%' AND language_id = (
	SELECT language_id
    FROM language
    WHERE name = 'English');

--- 7b ---
SELECT last_name, first_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip')
);

--- 7c ---
SELECT last_name, first_name, email
FROM customer
WHERE address_id IN (
	SELECT address_id
    FROM address
    WHERE city_id IN (
		SELECT city_id
        FROM city
        WHERE country_id = (
			SELECT country_id
            FROM country
            WHERE country = 'Canada')
));

--- 7d ---
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id = (
		SELECT category_id
        FROM category
        WHERE name = 'Family')
);

--- 7e ---
SELECT film.title, COUNT(rental_id) AS 'Rent Frequency'
FROM inventory
INNER JOIN film USING (film_id)
INNER JOIN rental USING (inventory_id)
GROUP BY film.film_id
ORDER BY COUNT(rental_id);

--- 7f ----
SELECT store_id AS 'Store', SUM(amount) AS 'Total Revenue'
FROM staff
INNER JOIN payment USING (staff_id)
INNER JOIN store USING (store_id)
GROUP BY store.store_id;

--- 7g ---
SELECT store_id AS 'Store', 
(SELECT city
FROM city
WHERE city_id IN (
	SELECT city_id
    FROM address
    WHERE address_id IN (
		SELECT address_id 
        FROM store))),
(SELECT country
FROM country
WHERE country_id IN (
	SELECT country_id
	FROM city
	WHERE city_id IN (
		SELECT city_id
		FROM address
		WHERE address_id IN (
			SELECT address_id 
			FROM store))))
FROM store;


SELECT city
FROM city
WHERE city_id IN (
	SELECT city_id
    FROM address
    WHERE address_id IN (
		SELECT address_id 
        FROM store));

SELECT country
FROM country
WHERE country_id IN (
	SELECT country_id
	FROM city
	WHERE city_id IN (
		SELECT city_id
		FROM address
		WHERE address_id IN (
			SELECT address_id 
			FROM store)));

SELECT store_id AS 'Store'
FROM store;

SELECT store_id, city, country
FROM store
INNER JOIN address USING (address_id)
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
GROUP BY store.store_id;


--- 7h ---
SELECT name AS 'Genres', 
(SELECT SUM(amount)
FROM payment
WHERE rental_id IN (
	SELECT rental_id
    FROM Rental
    WHERE inventory_id IN (
		SELECT inventory_id 
        FROM inventory
        WHERE film_id IN (
			SELECT film_id
            FROM film_category
            GROUP BY category_id)))) AS 'Total Revenue'
FROM category;

SELECT name AS 'Genres', SUM(amount) AS 'Total Revenue'
FROM payment
INNER JOIN rental USING (rental_id)
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(amount) DESC LIMIT 5;

--- 8a ---
CREATE VIEW gross_revenue AS
SELECT name AS 'Genres', SUM(amount) AS 'Total Revenue'
FROM payment
INNER JOIN rental USING (rental_id)
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY SUM(amount) DESC LIMIT 5;



--- 8b ---
SELECT * from gross_revenue;

--- 8c ---
DROP VIEW gross_revenue;



