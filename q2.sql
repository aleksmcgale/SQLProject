SELECT customer.email as customer_email, count(reservation.id) as num_shared
FROM customer JOIN customer_reservation
    on customer.email = customer_reservation.customer_email
    JOIN reservation
    on customer_reservation.reservation_id = reservation.id
WHERE reservation.reservation_status <> 'Cancelled' AND reservation.drivers > 1
GROUP BY customer.email limit 2;
