WITH dim_person__source AS (
    SELECT 
    *
    FROM `data-wh-mihdatj1.Wide_World_Importers.Application_People`
)

, dim_person__rename AS (
    SELECT
        person_id AS person_key
        , full_name 
        , is_permitted_to_logon AS Is_Permitted_To_Logon_boolean
        , is_external_logon_provider AS Is_External_Logon_Provider_boolean
        , is_system_user AS Is_System_User_boolean
        , is_employee AS Is_Employee_boolean
        , is_salesperson AS Is_Sales_person_boolean
    FROM dim_person__source
)

, dim_person__cast_type AS (
    SELECT 
        Cast(person_key AS INTEGER) AS person_key
        , Cast(full_name AS STRING) AS FullName
        , Cast(Is_Permitted_To_Logon_boolean AS BOOLEAN) AS Is_Permitted_To_Logon_boolean
        , Cast(Is_External_Logon_Provider_boolean AS BOOLEAN) AS Is_External_Logon_Provider_boolean
        , Cast(Is_System_User_boolean AS BOOLEAN) AS Is_System_User_boolean
        , Cast(Is_Employee_boolean AS BOOLEAN) AS Is_Employee_boolean
        , Cast(Is_Sales_person_boolean AS BOOLEAN) AS Is_Sales_person_boolean
    FROM dim_person__rename
)

, dim_person__conver_boolean AS (
    SELECT
        *
        , CASE
            WHEN Is_Permitted_To_Logon_boolean IS TRUE THEN 'Permitted_To_Logon'
            WHEN Is_Permitted_To_Logon_boolean IS FALSE THEN 'Not Permitted_To_Logon'
            WHEN Is_Permitted_To_Logon_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS Is_Permitted_To_Logon
        , CASE
            WHEN Is_External_Logon_Provider_boolean IS TRUE THEN 'External_Logon_Provider'
            WHEN Is_External_Logon_Provider_boolean IS FALSE THEN 'Not External_Logon_Provider'
            WHEN Is_External_Logon_Provider_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS Is_External_Logon_Provider
        , CASE
            WHEN Is_System_User_boolean IS TRUE THEN 'System_User'
            WHEN Is_System_User_boolean IS FALSE THEN 'Not System_User'
            WHEN Is_System_User_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS Is_System_User
        , CASE
            WHEN Is_Employee_boolean IS TRUE THEN 'Employee'
            WHEN Is_Employee_boolean IS FALSE THEN 'Not Employee'
            WHEN Is_Employee_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS Is_Employee
        , CASE
            WHEN Is_Sales_person_boolean IS TRUE THEN 'Sales_person'
            WHEN Is_Sales_person_boolean IS FALSE THEN 'Not Sales_person'
            WHEN Is_Sales_person_boolean IS NULL THEN 'Undefined'
            ELSE 'Invalid' END 
        AS Is_Sales_person

    FROM dim_person__cast_type
)



, dim_person__union_all AS (
    SELECT 
        person_key
        , FullName
        , Is_Permitted_To_Logon
        , Is_External_Logon_Provider
        , Is_System_User
        , Is_Employee
        , Is_Sales_person
    FROM dim_person__conver_boolean

    UNION ALL 
    SELECT 
        0 AS person_key
        , 'Undefined' AS FullName
        , 'Undefined' AS Is_Permitted_To_Logon
        , 'Undefined' AS Is_External_Logon_Provider
        , 'Undefined' AS Is_System_User
        , 'Undefined' AS Is_Employee
        , 'Undefined' AS Is_Sales_person
    
    UNION ALL 
    SELECT 
        -1 AS person_key
        , 'Invalid' AS FullName
        , 'Invalid' AS Is_Permitted_To_Logon
        , 'Invalid' AS Is_External_Logon_Provider
        , 'Invalid' AS Is_System_User
        , 'Invalid' AS Is_Employee
        , 'Invalid' AS Is_Sales_person 
)

SELECT 
    person_key
    , FullName
    , Is_Permitted_To_Logon
    , Is_External_Logon_Provider
    , Is_System_User
    , Is_Employee
    , Is_Sales_person
FROM dim_person__union_all
