CREATE VIEW deleted_reservations as
SELECT customer.email as email, count(customer_reservation.reservation_id) as numerator
FROM customer JOIN customer_reservation
    on customer.email = customer_reservation.customer_email
     LEFT JOIN reservation
    on customer_reservation.reservation_id = reservation.id
WHERE reservation.reservation_status = 'Cancelled'
GROUP BY customer.email; 

CREATE VIEW not_cancelled_reservations as
SELECT customer.email as email, count(customer_reservation.reservation_id) as denominator
FROM customer JOIN customer_reservation
    on customer.email = customer_reservation.customer_email
    JOIN reservation
    on customer_reservation.reservation_id = reservation.id
WHERE reservation.reservation_status <> 'Cancelled'
GROUP BY customer.email;

CREATE VIEW deleted_reservation_cross as
SELECT deleted_reservations.email as demail, not_cancelled_reservations.email as cemail, numerator, denominator
FROM deleted_reservations RIGHT JOIN not_cancelled_reservations
    on deleted_reservations.email = not_cancelled_reservations.email;

CREATE VIEW top2 as
SELECT cemail as customer_email, COALESCE(CAST(numerator AS FLOAT)/ CAST(denominator AS FLOAT),0) as cancel_ratio, 
CASE
    WHEN denominator = 0 THEN denominator = 1
    ELSE denominator = denominator
END
FROM deleted_reservation_cross
ORDER BY cancel_ratio DESC, demail ASC limit 2;

SELECT customer_email, cancel_ratio
FROM top2;







    
