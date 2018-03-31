CREATE VIEW model_name_pre as
SELECT DISTINCT model.name as name, count(reservation.car_id) as num_model
FROM model JOIN car
    on model.id = car.model_id
    JOIN reservation
    on car.id = reservation.car_id
WHERE reservation.reservation_status = 'Completed' AND reservation.from_date >= '2017-01-01 00:00:00' AND 
reservation.to_date <= '2017-12-12 23:59:59'
GROUP BY model.name
ORDER BY num_model DESC, name ASC limit 1;

SELECT name
FROM model_name_pre;
