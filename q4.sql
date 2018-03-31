CREATE VIEW custo_reso as
SELECT customer.email as customer_email, customer.age as age, reservation.old_reservation_id as old_reso
FROM customer JOIN customer_reservation
    on customer.email = customer_reservation.customer_email
    JOIN reservation
    on reservation.id = customer_reservation.reservation_id
WHERE customer.age < 30 AND reservation.old_reservation_id is not NULL AND reservation.from_date >= (CURRENT_TIMESTAMP - (INTERVAL '1 day' * 540));

CREATE VIEW num_cust_reso as
SELECT customer_email, count(customer_email) 
FROM custo_reso
GROUP BY customer_email;

SELECT customer_email
FROM num_cust_reso
WHERE count >1;