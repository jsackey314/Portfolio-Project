/*
SELECT 	*
FROM
    smaller_data_set order by client_id,loan_number, loan_disbursement_date;
 
SELECT  -- Group  the data into monthly cohorts
    client_cohort,
    COUNT(DISTINCT loan_id) AS total_loans,
    COUNT(DISTINCT client_id) AS total_clients,
    SUM(total_loan_disbursed_amount) AS total_disbursed
FROM 
    smaller_data_set
GROUP BY 
    client_cohort
ORDER BY 
    client_cohort;
    
SELECT DISTINCT
    (MONTH(loan_disbursement_date))
FROM
    smaller_data_set
WHERE
    loan_number = 0; -- Crosschecking that there are only 3 cohorts based on first loan

SELECT DISTINCT
    client_cohort
FROM
    smaller_data_set;
    */



WITH		loansCTE AS(
SELECT		client_cohort, SUM(total_loan_disbursed_amount) as total_disbursed
FROM		(
SELECT		DISTINCT *
FROM		(
				SELECT		client_cohort,
							client_id,
							loan_number,
							loan_ID,
							total_loan_disbursed_amount
                            
				FROM		smaller_data_set) tld) tld2
GROUP BY		1
),

installmentsCTE AS(
SELECT		client_cohort, ROUND(SUM(installment_disbursed_amount),2) AS installment_disbursed,
			ROUND(SUM(installment_total_due),2) AS total_due
FROM		(
SELECT		DISTINCT *
FROM		(
				SELECT		client_cohort,
							loan_ID,
							installment_disbursed_amount,
                            installment_total_due
                            
				FROM		smaller_data_set) itd) itd2
GROUP BY	1
),

cohort_paymentCTE AS(
SELECT		client_cohort,
			COUNT(DISTINCT loan_id) AS total_loans,
			COUNT(DISTINCT client_id) AS total_clients,
            ROUND(SUM(paid_amount),2) AS total_paid
FROM		smaller_data_set
GROUP BY	1
)

SELECT		a.client_cohort,
			c.total_loans,
            c.total_clients,
			a.total_disbursed,
            b.installment_disbursed,
            b.total_due,
            total_paid,
            ROUND((total_paid/b.total_due)*100,2) AS repayment_rate,
            ROUND(1-(total_paid/b.total_due),2) AS default_rate,
            ROUND(b.total_due-a.total_disbursed,2) AS interest
FROM		loansCTE a	
JOIN	 	installmentsCTE b ON a.client_cohort = b.client_cohort
JOIN		cohort_paymentCTE c ON b.client_cohort = c.client_cohort;




-- select CLIENT_COHORT, LOAN_DISBURSEMENT_DATE, TRANSACTION_DATE, (TRANSACTION_DATE-LOAN_DISBURSEMENT_DATE)
-- from	smaller_data_set



    
    
 
 