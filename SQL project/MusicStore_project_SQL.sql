--Q1. Who is the senior most employee based on job title?

select * from employee 
order by levels desc 
limit 1

--Q2. Which countries have the most Invoices?

select count(*), billing_country from invoice
group by billing_country
order by count desc

--Q3. What are top 3 values of total invoice?

select invoice_id, total from invoice
order by total desc
limit 3


-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival 
--in the city we made the most money. Write a query that returns one city that has the highest 
--sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city, sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc
limit 1

--Q5. Who is the best customer? The customer who has spent the most money will be 
--declared the best customer.
--Write a query that returns the person who has spent the most money

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total from customer as c
join invoice as i on c.customer_id=i.customer_id
group by c.customer_id
order by total desc
limit 1


--Q6. Write query to return the email, first name, last name, 
--& Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A

select distinct c.first_name, c.last_name, c.email from customer as c
join invoice as i on c.customer_id=i.customer_id
join invoice_line as il on i.invoice_id=il.invoice_id
where track_id in(
	select track_id from track as t 
	join genre as g on t.genre_id=g.genre_id
	where g.name like 'Rock'
	)
order by email asc;

-------------------------
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

--------------------------

--Q7. Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands

select a.artist_id, a.name, count(a.name) as number_of_songs from artist as a
join album as ab on a.artist_id=ab.artist_id
join track as t on ab.album_id=t.album_id
join genre as g on t.genre_id=g.genre_id
where g.name like 'Rock'
group by a.name, a.artist_id
order by count(a.name) desc
limit 10;
-------------------------------


--Q8. Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

select name, milliseconds as song_length from track
where milliseconds > ( select avg(milliseconds) from track)
order by milliseconds desc

--Q9. Find how much amount spent by each customer on artists? 
--Write a query to return customer name, artist name and total spent

select c.first_name || ' ' || c.last_name as customer_name, a.name as artist_name, 
sum(il.unit_price*il.quantity) as Total from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album al on al.album_id=t.album_id
join artist a on a.artist_id=al.artist_id
group by artist_name, customer_name
order by customer_name asc


-----------------------------
--If asked for how much each spent on the best selling artist

With best_selling_artist as (
select sum(il.unit_price*il.quantity) as total_sales, a.name as artist_name, a.artist_id from artist as a
join album as al on a.artist_id=al.artist_id
join track as t on t.album_id=al.album_id
join invoice_line as il on il.track_id=t.track_id
group by artist_name, a.artist_id
order by total_sales desc
limit 1
)
select c.first_name || ' ' || c.last_name as customer_name, bsa.artist_name, 
sum(il.unit_price*il.quantity) as Amount_spent from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album al on al.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=al.artist_id
group by artist_name, customer_name
order by customer_name asc

--Q10. We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre. 
--For countries where the maximum number of purchases is shared return all Genres

With popular_genre as
(
select  count(il.quantity) as purchases, i.billing_country as country, g.name as genre, g.genre_id, 
row_number() over(partition by i.billing_country order by count(il.quantity) desc) as row_no
from invoice as i
join invoice_line as il on i.invoice_id=il.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
group by country, genre, g.genre_id
order by country asc, purchases desc
)
select * from popular_genre where row_no=1

--11. Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount

with customer_with_country as
(
		select c.customer_id, first_name, last_name, billing_country, sum(total) as total_spending from invoice as i
		join customer as c on c.customer_id=i.customer_id
		group by 1,2,3,4
		order by 1, 5 desc
)
,
ranked_customers as (
	select customer_id, first_name, last_name, billing_country, total_spending, 
	rank() over(partition by billing_country order by total_spending) as rank from customer_with_country)
	
select customer_id, first_name, last_name, billing_country, total_spending from ranked_customers
where rank=1
order by customer_id, billing_country;


-------------RECURSIVE-----------------

with recursive customer_with_country as
(
		select c.customer_id, first_name, last_name, billing_country, 
		sum(total) as total_spending from invoice as i
		join customer as c on c.customer_id=i.customer_id
		group by 1,2,3,4
		order by 1, 5 desc
),
country_max_spending  as (
select billing_country, max(total_spending) as max_spending
from customer_with_country as cc
group by billing_country)

select cc.billing_country, cms.max_spending, cc.first_name, cc.last_name
from customer_with_country as cc 
join country_max_spending as cms on cc.billing_country=cms.billing_country
and cc.total_spending=cms.max_spending
order by 1;


------------OR------------

with customer_with_country as(
select c.customer_id,c.first_name,c.last_name,i.billing_country, sum(i.total) as total_spending,
row_number () over(partition by i.billing_country order by sum(i.total) desc) as row_no
from invoice as i
join customer c on c.customer_id=i.customer_id
group by 1,2,3,4
order by 4 asc, 5 desc
)

select * from customer_with_country where row_no=1
order by customer_id;



		
		












