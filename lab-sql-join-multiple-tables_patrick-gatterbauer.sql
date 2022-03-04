
/** In this lab, you will be using the Sakila database of movie rentals.

Instructions
1. Write a query to display for each store its store ID, city, and country.
2. Write a query to display how much business, in dollars, each store brought in.
3. What is the average running time of films by category?
4. Which film categories are longest?
5. Display the most frequently rented movies in descending order.
6. List the top five genres in gross revenue in descending order.
7. Is "Academy Dinosaur" available for rent from Store 1? **/

USE sakila;

# 1. Write a query to display for each store its store ID, city, and country.
# tables: store (store_id, address_id), address (address_id, city_id), city (city_id, country_id), 
# country (country_id -> get country name)

SELECT
	s.store_id, 
    c.city, 
    co.country
FROM
	store s
JOIN
	address a
ON
	s.address_id = a.address_id
JOIN
	city c
ON	
	c.city_id = a.city_id
JOIN
	country co
ON co.country_id = c.country_id;

# 2. Write a query to display how much business, in dollars, each store brought in.
# store (store_id), staff(staff_id, store_id), payment(payment_id, staff_id)

SELECT
	s.store_id, 
    SUM(p.amount) 
FROM
	store s
JOIN
	staff st
ON
	s.store_id = st.store_id
JOIN
	staff sf
ON	
	sf.staff_id = st.staff_id
JOIN
	payment p
ON 
	p.staff_id = sf.staff_id
GROUP BY
	s.store_id;
    
# 3. What is the average running time of films by category?
# film (film_id), film_category(film_id, category_id

SELECT
	AVG(f.length),
    fc.category_id
FROM
	film f
JOIN
	film_category fc
ON
	fc.film_id = f.film_id
GROUP BY
	fc.category_id;

# 4. Which film categories are longest?
# film, film_category

SELECT
	MAX(f.length),
    fc.category_id
FROM
	film f
JOIN
	film_category fc
ON
	fc.film_id = f.film_id
GROUP BY
	fc.category_id
ORDER BY 
	fc.category_id DESC;
    
# 5. Display the most frequently rented movies in descending order.
# rental (rental_id, inventory_id), inventory (inventory_id, film_id)

SELECT
	i.film_id, 
    COUNT(r.rental_id)
FROM
	inventory i
JOIN
	rental r
ON
	i.inventory_id = r.inventory_id
GROUP BY
	i.film_id
ORDER BY
	COUNT(r.rental_id) DESC;


# 6. List the top five genres in gross revenue in descending order.
# film_category (film_id, cateory_id), film (film_id), inventory (inventory_id, film_id)
# rental (rental_id, inventory_id), payment (payment_id, rental_id -> amount)

SELECT
	fc.category_id,
    SUM(p.amount) AS total_amount
FROM
	film_category fc
JOIN
	film f
ON 
	fc.film_id = f.film_id
JOIN
	inventory i
ON
	f.film_id = i.film_id
JOIN
	rental r
ON
	r.inventory_id = i.inventory_id
JOIN
	payment p
ON
	p.rental_id = r.rental_id
GROUP BY
	fc.category_id
ORDER BY
	total_amount DESC
LIMIT 5;

# 7. Is "Academy Dinosaur" available for rent from Store 1? **/ -> Answer: Yes, it is.
# store (store_id), inventory (invetory_id, store_id) film (film_id -> title)

SELECT
	s.store_id, f.title
FROM
	store s
JOIN
	inventory i
ON
	i. store_id = s.store_id
JOIN
	film f
ON
	i.film_id = f.film_id
WHERE
	f.title = 'Academy Dinosaur' AND s.store_id = 1
GROUP BY 
	s.store_id;
