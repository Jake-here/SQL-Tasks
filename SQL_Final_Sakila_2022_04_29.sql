-- 1. 
/*
Use: sql_invoicing.invoices;
Return 'client_id', 'invoice_total', 'number' columns. Sort data by 'client_id'
in ascending order and by 'invoice_total' by descending order (1pt);
*/

select 
	client_id
    ,invoice_total
    ,number
from sql_invoicing.invoices
order by client_id asc, invoice_total desc;

-- 2. 
/*
Use: sql_invoicing.invoices; 
Return all unique 'client_id' values and sort them
in a descending order. (1pt);
*/

select distinct
	client_id
from sql_invoicing.invoices
order by client_id desc
;


-- 3.
/*
Use: sql_invoicing.payments;
Write a SQL query, that would calculate total sum of all payments ('amount') .
Return results in a column 'total'. 
Also calculate average payments and name the column 'payments average'. Calculate the smallest and the largest payment.
Give name to those columns.
Also calculate the number of uique clients and also amount of unique invoices and name the columns. 
(2pt);
*/

select 
	sum(amount) as 'total'
    ,round(avg(amount), 2) as 'payments average'
    ,min(amount) as min_amount
	,max(amount) as max_amount
    ,count(distinct client_id) as no_clients
    ,count(distinct invoice_id) as no_invoices
from sql_invoicing.payments
;


-- 4.
/*
Use: sql_hr.employees; 
Write a SQL query, that would return all entries, where in column 'salary'the value is less than 40 000.
Sort the entries by from largest salary in descending order.
Next to the filtered entries create a new column named 'new salary', where the salary would be increased by 15%.
(2pt);
*/

select 
	*
    ,(salary)*1.15 as new_salary
from sql_hr.employees
where salary < 40000
order by salary desc
;


-- 5. 
/*
Use: sql_store.products;
Analyse product ('name') column. At what position is the letter 'e'.
Sort the results starting with the furthest position of 'e' letter.
(1pt); 			
*/

select 
	name
	,locate('e', name) as letter_e_position
from sql_store.products
group by name
order by letter_e_position desc
;


-- 6. 
/*
Use: sql_store.customers; 
Write a SQL query, that would return all entries, where city is Vilnius, Klaipėda and Alytus,
and the loyalty points that a client has generated is no less than 1000. 
Sort the results by the loyalty points in ascending order.
(1pt);
*/


select 
	*
from sql_store.customers
where city = 'Vilnius' 
or city = 'Klaipėda' 
or city = 'Alytus'
having points < 1000
order by points asc
;


-- 7.
/*
Use: sql_hr.employees;
Write a SQL query, that would calculate the sum of the salaries of the employees,
whose job title contains 'Operacijų'
Name the column 'sum_salary'
(1pt);
*/

select
	sum(salary) as sum_salary
from sql_hr.employees
where job_title like '%Operacijų%'
;


-- 8.
/*
Use: sql_store.shippers,
         sql_store.orders,
         sql_store.order_items;
Write a SQL query, that would return shippers' names,
the amount of the different products and the amount of the different orders that they have completed.
Name the columns accordingly.
Sort the results by shippers' name in alphabetical order (3pt);
*/

select
	name
    ,count(distinct t3.product_id) as Cnt_unique_products
 ,count(distinct t2.order_id) as Cnt_unique_orders
from shippers t1
left join orders t2
on t1.shipper_id = t2.shipper_id
left join order_items t3
on t2.order_id = t3.order_id
group by name
order by name
;

-- 9.
/*
Use: sakila.film;
Write a SQL query, that would return film titles, ratings
and that would sort the films by their ratings to the following categories:
If rating is 'PG' or 'G' - then 'PG_G'.
If rating is 'NC-17' or „PG-13“ - then „NC-17_PG-13“.
All other ratings assign to category 'Not_important'
Return categories in a column 'Rating_group'
(2t)
*/

select
	title
    ,rating
    ,CASE
		when rating = 'PG' or rating = 'G' then 'PG_G'
        when rating = 'NC-17' or rating = 'PG-13' then 'NC-17_PG-13'
        else 'Not_important'
        end as Rating_group
from sakila.film
;

-- 10.
/*
Use: sakila.film;
Write a SQL query, that would calculate how many films belong to rating groups, that were created in task 9.
In the results provide only those rating groups, in which the amount is between 250 - 450 films.
Sort the results from the largest amount of films in a descending order.
(4pt)
*/

select
	CASE
		when rating = 'PG' or rating = 'G' then 'PG_G'
        when rating = 'NC-17' or rating = 'PG-13' then 'NC-17_PG-13'
        else 'Not_important'
        end as Rating_group
        ,count(film_id) as film_amount
from sakila.film
group by Rating_group
having film_amount between 250 and 450
order by film_amount desc
;

-- 11. 
/*
Use: sakila.customer, 
		 sakila.rental, 
         sakila.inventory, 
         sakila.film;
Please return clients first names and last names from CUSTOMER table, that have rented film 'AGENT TRUMAN'.
Use subqueries for this task. Sort the results by client's name in alphabetical order. 
(4pt);
*/

select 
	first_name
    ,last_name
from customer
where customer_id in (select customer_id
						from rental
						where inventory_id in (select inventory_id
												from inventory
												where film_id = (select film_id
												from film
												where title = 'AGENT TRUMAN')))
order by first_name asc

;

-- II way to solve this.

select 
	first_name
    ,last_name
from customer t1
left join rental t2
on t1.customer_id = t2.customer_id
left join inventory t3
on t2.inventory_id = t3.inventory_id
left join film t4
on t3.film_id = t4.film_id
where t4.title = 'AGENT TRUMAN'
order by first_name asc
;

    
-- 12.
/*
Use: sql_invoicing.clients, 
		 sql_invoicing.invoices;
Write a SQL query, that would return client id, client name and how many unpaid invoices they have.
For that you can use 'payment_date' column.
Sort the results by the client id from the largest value in a descending order.
(3pt);
*/

select 
		t1.client_id
        ,t1.name
        ,count(t2.payment_date) as Unpaid_invoices_amount
from clients t1
left join invoices t2
on t1.client_id = t2.client_id
group by t1.name
order by client_id desc
;


-- 13.
/*
Use: sql_store.products;
Form products table return product name.
Add a column next to it, where you would create a new product naming method and call it 'new_name'
Condition: if product name contains spaces, then in a new naming method change spaces with '***';  
			if product name does not have spaces, then befor the product name add 3 exclamation marks '!!!'.
(2pt);
*/

select
		name
			,CASE
				when name like '% %' then replace(name,' ', '***')
                else concat('!!!', name)
			END as new_name
from products
;


-- 14.
/*
Use: sql_store.customers;
Return entries from CUSTOMERS table if the buyer has loyalty points above the average of all buyers' points. 
For this use subqueries.
Sort the entries from the buyer with the largest amount of points.
(2pt);
*/

select
		*
from customers
where points > (select 
						avg(points)
				from customers)
order by points desc
;
            
select 
	avg(points)
from customers;               

-- 15.
/*
Write a SELECT quesry, that would return Your name as a value in a column called 'Name',
a column called 'MySQL course' with the value 'Very Good', and a column 'Points' with the number of point you think you got on this test.
(1pt);
*/

CREATE
TEMPORARY TABLE Kurso_rezultatai
(vardas VARCHAR(55) NOT NULL,
VCS_MySQL_kursas VARCHAR(55) NOT NULL,
Surinkau_taškų INT NOT NULL);

INSERT INTO Kurso_rezultatai (vardas, VCS_MySQL_kursas, Surinkau_taškų)
VALUES ('Jakūbas', 'Labai patiko', 99);

select *
from Kurso_rezultatai;