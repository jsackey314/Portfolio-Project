WITH MainTable as (
    SELECT 
        -- "pgdbprod"."mv_oop_reports"."visit_id" AS "Visit ID",
        ---"mvs"."mv_pos_sales_transaction_item"."sale_id"                       AS "sale_id", 
        ---"mvs"."mv_pos_sales_transaction_item"."patient_facility_name"         AS "patient_facility_name", 
        ---"mvs"."mv_pos_sales_transaction_item"."sale_facility_id"              AS "sale_facility_id",
        ---"mvs"."mv_pos_sales_transaction_item"."customer_type"                 AS "customer_type",
        ---"mvs"."mv_pos_sales_transaction_item"."unit_vmi_cost_price_local"     AS "vmi_cost_price",
        ---"pgdbprod"."mv_oop_reports"."payment due date"                        AS "Payment Due Date",
        ---"mvs"."mv_pos_sales_transaction_item"."patient_risk_tier_type"        AS "patient_risk_tier_type",
        ---"mvs"."mv_pos_sales_transaction_item"."is_manual"                     AS "is_manual",
        ---"mvs"."mv_pos_sales_transaction_item"."vdl_drug_id"                   AS "vdl_drug_id",
        "mvs"."mv_pos_sales_transaction_item"."sale_date"                     AS "sale_date",
        "mvs"."mv_pos_sales_transaction_item"."sale_facility"                 AS "sale_facility",
        "mvs"."mv_pos_sales_transaction_item"."mpharma_id"                    AS "mPharma_id",
        "mvs"."mv_pos_sales_transaction_item"."customer_corporate_type"       AS "customer_corporate_type",
        "mvs"."mv_pos_sales_transaction_item"."corporate_facility_name"       AS "corporate_facility_name",
        "mvs"."mv_pos_sales_transaction_item"."insurance_payor"               AS "insurance_payor",
        "mvs"."mv_pos_sales_transaction_item"."vdl_drug_display_name"         AS "vdl_drug_display_name",
        "mvs"."mv_pos_sales_transaction_item"."unit_cost_price_local"         AS "mpharma_cost_price",
        "mvs"."mv_pos_sales_transaction_item"."unit_selling_price_local"      AS "unit_selling_price_local",
        "mvs"."mv_pos_sales_transaction_item"."quantity_in_units"             AS "quantity_in_units",
        "mvs"."mv_pos_sales_transaction_item"."sale_item_selling_price_local" AS "sale_total"
        ---"pgdbprod"."mv_oop_reports"."delivery_cost" AS "Delivery Cost",
        ---"pgdbprod"."mv_oop_reports"."discount_received" AS "Discount Received"
    FROM "mvs"."mv_pos_sales_transaction_item"
    JOIN "mvs"."mv_facilities" ON "mvs"."mv_pos_sales_transaction_item"."sale_facility_id" = "mvs"."mv_facilities"."facility_id_system"
    WHERE 
        (CAST("sale_date" as DATE) BETWEEN {{start_date}} AND {{end_date}})
        [[AND {{name_of_facility}}]]
        [[AND {{vdl_drug_display_name}}]]
        AND {{insurance_payor}}
    ORDER BY 
        "sale_date" DESC, "sale_id" ASC
    )
   
SELECT
    vdl_drug_display_name,
    sum(quantity_in_units) as qty_sold,
    round(sum(sale_total),0) as Total_Sales
FROM
    MainTable
GROUP by
    vdl_drug_display_name
Order BY
    Total_Sales DESC
