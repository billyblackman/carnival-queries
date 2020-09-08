--Chapter 8
--Write a query that shows the total purchase sales income per dealership.
SELECT
    sum(s.price) AS sales_total,
    d.business_name
FROM
    sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
    s.sales_type_id = 1
GROUP BY
    d.business_name;

--Write a query that shows the purchase sales income per dealership for the current month.
SELECT
    sum(s.price) AS sales_total,
    d.business_name
FROM
    sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
    s.sales_type_id = 1
    AND extract(
        MONTH
        FROM
            s.purchase_date
    ) = extract(
        MONTH
        FROM
            CURRENT_TIMESTAMP
    )
GROUP BY
    d.business_name;

--Write a query that shows the purchase sales income per dealership for the current year.
SELECT
    sum(s.price) AS sales_total,
    d.business_name
FROM
    sales s
    JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
    s.sales_type_id = 1
    AND extract(
        YEAR
        FROM
            s.purchase_date
    ) = extract(
        YEAR
        FROM
            CURRENT_TIMESTAMP
    )
GROUP BY
    d.business_name;

--Write a query that shows the total income (purchase and lease) per employee.
SELECT
    sum(s.price),
    e.first_name,
    e.last_name
FROM
    sales s
    JOIN employees e ON e.employee_id = s.employee_id
GROUP BY
    e.employee_id;

--Chapter 9
--Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.
SELECT
    sum(vt.model_id),
    m.name
FROM
    vehicletypes vt
    JOIN vehiclemodels m ON vt.model_id = m.vehicle_model_id
GROUP BY
    m.name
ORDER BY
    sum(vt.model_id);

--Which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.
SELECT
    sum(vt.model_id),
    m.name
FROM
    vehicletypes vt
    JOIN vehiclemodels m ON vt.model_id = m.vehicle_model_id
GROUP BY
    m.name
ORDER BY
    sum(vt.model_id) DESC;

--Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.
SELECT
    count(v.vehicle_type_id),
    vm.name,
    d.business_name,
    s.dealership_id
FROM
    dealerships d
    JOIN sales s ON d.dealership_id = s.dealership_id
    JOIN vehicles v ON v.vehicle_id = s.vehicle_id
    JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
    JOIN vehiclemodels vm ON vt.model_id = vehicle_model_id
GROUP BY
    vm.name,
    d.business_name,
    vm.name,
    s.dealership_id,
    v.vehicle_type_id,
    vt.vehicle_type_id
ORDER BY
    count(vm.name);

--Which dealerships are currently selling the highest number of vehicle models? This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT
    count(v.vehicle_type_id),
    vm.name,
    d.business_name,
    s.dealership_id
FROM
    dealerships d
    JOIN sales s ON d.dealership_id = s.dealership_id
    JOIN vehicles v ON v.vehicle_id = s.vehicle_id
    JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
    JOIN vehiclemodels vm ON vt.model_id = vehicle_model_id
GROUP BY
    vm.name,
    d.business_name,
    vm.name,
    s.dealership_id,
    v.vehicle_type_id,
    vt.vehicle_type_id
ORDER BY
    count(vm.name) DESC;

--Chapter 10
--How many emloyees are there for each role?
SELECT
    count(e.employee_type_id),
    et.name
FROM
    employees e
    JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
GROUP BY
    e.employee_type_id,
    et.name;

--How many finance managers work at each dealership?
SELECT
    d.business_name,
    count(e.employee_type_id),
    et.name
FROM
    dealerships d
    JOIN dealershipemployees de ON de.dealership_id = d.dealership_id
    JOIN employees e ON e.employee_id = de.employee_id
    JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
WHERE
    et.name = 'Finance Manager'
GROUP BY
    e.employee_type_id,
    d.business_name,
    et.name;

--Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT
    e.first_name,
    e.last_name,
    count(de.dealership_employee_id)
FROM
    employees e
    JOIN dealershipemployees de ON de.employee_id = e.employee_id
GROUP BY
    de.dealership_employee_id,
    e.first_name,
    e.last_name
ORDER BY
    dealership_employee_id DESC
LIMIT
    3;

--Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT
    e.first_name,
    e.last_name,
    count(s.employee_id)
FROM
    employees e
    JOIN sales s ON s.employee_id = e.employee_id
WHERE
    s.sales_type_id = 2
GROUP BY
    s.employee_id,
    e.first_name,
    e.last_name
LIMIT
    2 --What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
    count(c.state),
    c.state
FROM
    customers c
    JOIN sales s ON s.customer_id = c.customer_id
GROUP BY
    c.state
ORDER BY count(c.state) DESC
LIMIT
    5