INSERT INTO managers (id, name, login, salary, plan, unit, boss_id)
VALUES (1, 'Vasya', 'vasya', 100000, 0, NULL, NULL), -- Ctrl + D
       (2, 'Petya', 'petya', 90000, 90000, 'boy', 1),
       (3, 'Vanya', 'vanya', 80000, 80000, 'boy', 2),
       (4, 'Masha', 'masha', 80000, 80000, 'girl', 1),
       (5, 'Dasha', 'dasha', 60000, 60000, 'girl', 4),
       (6, 'Sasha', 'sasha', 40000, 40000, 'girl', 5);

INSERT INTO products(name, price, qty)
VALUES ('Big Mac', 200, 10),       -- 1
       ('Chicken Mac', 150, 15),   -- 2
       ('Cheese Burger', 100, 20), -- 3
       ('Tea', 50, 10),            -- 4
       ('Coffee', 80, 10),         -- 5
       ('Cola', 100, 20); -- 6

INSERT INTO sales(manager_id, product_id, price, qty)
VALUES (1, 1, 150, 10), -- Vasya big mac со скидкой
       (2, 2, 150, 5),  -- Petya Chicken Mac без скидки
       (3, 3, 100, 5),  -- Vanya Cheese Burger без скидки
       (4, 1, 250, 5),  -- Masha Big Mac с наценкой
       (4, 4, 100, 5),  -- Masha Tea тоже с наценкой
       (5, 5, 100, 5),  -- Dasha Coffee c наценкой
       (5, 6, 120, 10);

SELECT s.id,
       (
           SELECT p.name
           FROM products p
           WHERE p.id = s.product_id
       ),
       (
           SELECT m.name
           FROM managers m
           WHERE m.id = s.manager_id
       ),
       s.price * s.qty
FROM sales s;

----2
SELECT m.name,
       (
           SELECT COUNT(*) FROM sales GROUP BY manager_id HAVING manager_id = m.id
       )
FROM managers m;

---3
SELECT m.name, (SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id)
FROM managers M;

---4
SELECT m.name,( SELECT sum(s.price * s.qty) FROM sales s WHERE s.product_id = m.id)
FROM products M;

--5
select m.id,
       m.name,
       (select sum(s.price * s.qty) from sales s where s.manager_id = m.id order by s.manager_id) sold
from managers m
order by sold desc
limit 3;

--6
select s.product_id,
       (
           select p.name
           from products p
           where p.id = s.product_id
       ) name,
       sum(qty) total
from sales s
group by name order by total desc limit 3;

--7
select s.product_id,
       (
           select p.name
           from products p
           where p.id = s.product_id
       ) name,
       sum(qty * price) total
from sales s
group by name order by total desc limit 3;

---8
SELECT m.name,  m.plan, (((SELECT sum(s.price * s.qty) FROM sales s WHERE s.manager_id = m.id))*100.0)/m.plan
FROM managers m;

--9
SELECT m.unit,
       ifnull((
                  SELECT ss.total
                  FROM (
                               SELECT sum(s.qty * s.price)total,
                                  (SELECT mm.unit FROM managers mm WHERE mm.id = s.manager_id) unit
                           FROM sales s
                           WHERE unit = m.unit) ss
              )
                  * 100.0 /
              (
                  SELECT sum(mm.plan)
                  FROM managers mm
                  WHERE mm.unit = m.unit
              ), 0)
FROM managers m;