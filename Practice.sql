--Chapter 4
--Get a list of the sales that was made for each sales type.
SELECT
    s.sale_id,
    st.name
FROM
    salestypes st
    JOIN sales s ON st.sales_type_id = s.sales_type_id
GROUP BY
    st.name,
    s.sale_id
ORDER BY
    st.name;

--Get a list of sales with the VIN of the vehicle, the first name and last name of the customer, first name and last name of the employee who made the sale and the name, city and state of the dealership.
SELECT
    s.sale_id,
    v.vin,
    concat(c.first_name, ' ', c.last_name) AS customer_name,
    concat(e.first_name, ' ', e.last_name) AS salesperson_name,
    d.business_name,
    d.city,
    d.state
FROM
    sales s
    JOIN vehicles v ON s.vehicle_id = v.vehicle_id
    JOIN customers c ON s.customer_id = c.customer_id
    JOIN employees e ON s.employee_id = e.employee_id
    JOIN dealerships d ON s.dealership_id = d.dealership_id;

--Get a list of all the dealerships and the employees, if any, working at each one.
SELECT
    d.business_name,
    concat(e.first_name, ' ', e.last_name) AS employee_name
FROM
    dealerships d
    LEFT JOIN dealershipemployees de ON d.dealership_id = de.dealership_id
    JOIN employees e ON e.employee_id = de.employee_id;

--Get a list of vehicles with the names of the body type, make, model and color.
SELECT
    v.vin,
    v.exterior_color,
    vbt.name,
    vmk.name,
    vmd.name
FROM
    vehicles v
    JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
    JOIN vehiclebodytypes vbt ON vt.body_type_id = vbt.vehicle_body_type_id
    JOIN vehiclemakes vmk ON vt.make_id = vmk.make_id
    JOIN vehiclemodels vmd ON vt.model_id = vmd.model_id;

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
    2;

--What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
    count(c.state),
    c.state
FROM
    customers c
    JOIN sales s ON s.customer_id = c.customer_id
GROUP BY
    c.state
ORDER BY
    count(c.state) DESC
LIMIT
    5;

--What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
    count(c.zipcode),
    c.zipcode
FROM
    customers c
    JOIN sales s ON s.customer_id = c.customer_id
GROUP BY
    c.zipcode
ORDER BY
    count(c.zipcode) DESC
LIMIT
    5;

--What are the top 5 dealerships with the most customers?
SELECT
    count(d.business_name),
    d.business_name
FROM
    dealerships d
    JOIN sales s ON s.dealership_id = d.dealership_id
    JOIN customers c ON c.customer_id = s.customer_id
GROUP BY
    d.business_name
ORDER BY
    count(d.business_name) DESC
LIMIT
    5;

--Create a view that lists all vehicle body types, makes and models.
--Create a view that shows the total number of employees for each employee type.
CREATE VIEW employee_type_totals AS
SELECT
    count(e.employee_type_id),
    et.name
FROM
    employees e
    JOIN employeetypes et ON e.employee_type_id = et.employee_type_id
GROUP BY
    e.employee_type_id,
    et.name --Create a view that lists all customers without exposing their emails, phone numbers and street address.
    CREATE VIEW customers_public AS
SELECT
    customer_id,
    first_name,
    last_name,
    city,
    state,
    zipcode,
    company_name
FROM
    customers c;

--Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.
CREATE VIEW sales2018 AS
SELECT
    st.name,
    count(s.sales_type_id)
FROM
    salestypes st
    JOIN sales s ON s.sales_type_id = st.sales_type_id
WHERE
    EXTRACT(
        YEAR
        FROM
            s.purchase_date
    ) = 2018
GROUP BY
    st.name,
    s.sales_type_id
ORDER BY
    count(s.sales_type_id) DESC;

--Create a view that shows the employee at each dealership with the most number of sales.
--Who are the top 5 employees for generating sales income?
SELECT
    e.first_name,
    e.last_name,
    sum(s.price) AS sales_total
FROM
    employees e
    JOIN sales s ON s.employee_id = e.employee_id
    AND s.sales_type_id = 1
GROUP BY
    e.first_name,
    e.last_name,
    s.price
ORDER BY
    sum(s.price)
LIMIT
    5;

--Who are the top 5 dealership for generating sales income?
SELECT
    d.business_name,
    sum(s.price) AS sales_total
FROM
    dealerships d
    JOIN sales s ON s.dealership_id = d.dealership_id
    AND s.sales_type_id = 1
GROUP BY
    d.business_name,
    s.price
ORDER BY
    sum(s.price)
LIMIT
    5;

--Which vehicle model generated the most sales income?
SELECT
    vm.name,
    sum(s.price)
FROM
    vehiclemodels vm
    JOIN vehicletypes vt ON vm.vehicle_model_id = vt.model_id
    JOIN vehicles v ON v.vehicle_type_id = vt.vehicle_type_id
    JOIN sales s ON s.vehicle_id = v.vehicle_id
GROUP BY
    vm.name,
    s.price
ORDER BY
    sum(s.price) DESC
LIMIT
    1;

--Which employees generate the most income per dealership?
SELECT
    d.business_name,
    concat(e.first_name, ' ', e.last_name) AS "Top Employee"
FROM
    dealerships d
    JOIN employees e ON e.employee_id = (
        SELECT
            e.employee_id
        FROM
            sales s
            JOIN employees e ON s.employee_id = e.employee_id
        WHERE
            s.dealership_id = d.dealership_id
        GROUP BY
            e.employee_id,
            s.dealership_id
        ORDER BY
            sum(s.price) DESC
        LIMIT
            1
    );

--In our Vehicle inventory, show the count of each Model that is in stock.
SELECT
    vm.name,
    count(vm.name) AS model_count
FROM
    vehiclemodels vm
    JOIN vehicletypes vt ON vt.model_id = vm.vehicle_model_id
    JOIN vehicles v ON v.vehicle_type_id = vt.vehicle_type_id
GROUP BY
    vm.name;

--In our Vehicle inventory, show the count of each Make that is in stock.
SELECT
    vmk.name,
    count(vmk.name) AS make_count
FROM
    vehiclemakes vmk
    JOIN vehicletypes vt ON vt.make_id = vmk.vehicle_make_id
    JOIN vehicles v ON v.vehicle_type_id = vt.vehicle_type_id
GROUP BY
    vmk.name;

--In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT
    vbt.name,
    count(vbt.name) AS body_type_count
FROM
    vehiclebodytypes vbt
    JOIN vehicletypes vt ON vt.make_id = vbt.vehicle_body_type_id
    JOIN vehicles v ON v.vehicle_type_id = vt.vehicle_type_id
GROUP BY
    vbt.name;

--Which US state's customers have the highest average purchase price for a vehicle?
SELECT
    round(avg(s.price)),
    c.state
FROM
    sales s
    JOIN customers c ON s.customer_id = c.customer_id
GROUP BY
    c.state
ORDER BY
    avg(s.price) DESC
LIMIT
    1;

--Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?
SELECT
    round(avg(s.price)),
    c.state
FROM
    sales s
    JOIN customers c ON s.customer_id = c.customer_id
GROUP BY
    c.state
ORDER BY
    avg(s.price) DESC
LIMIT
    5;