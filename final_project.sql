-- Databricks notebook source
select * 
from read_files('/Volumes/idp/default/final_project')

-- COMMAND ----------

create or replace table parsed_table AS
select path,
ai_parse_document(content) as parsed_content
from read_files('/Volumes/idp/default/final_project')

-- COMMAND ----------

select * from parsed_table

-- COMMAND ----------

create or replace table pretty_data AS
select path,
concat_ws('\n',
transform(try_cast(parsed_content:document:elements AS ARRAY<VARIANT>),
e -> coalesce(try_cast(e:content AS STRING), ''))
) as doc_text
from parsed_table

-- COMMAND ----------

create or replace table classified_data as
select *,
ai_classify(doc_text, ARRAY('Invoice', 'purchase Order', 'Receipt', 'other')) as doc_classification
from pretty_data

-- COMMAND ----------

create or replace table invoice_data as
select *,
ai_extract(doc_text, Array('VendorName',
'InvoiceNumber',
'InvoiceDate',
'DueDate',
'address',
'PaymentMethod',
'Total')) as extracted
from classified_data
where doc_classification = 'Invoice'

-- COMMAND ----------

create schema if not exists idp.finance

-- COMMAND ----------

create or replace table idp.finance.invoices
select path,
extracted.VendorName as Vendor,
extracted.InvoiceDate as Invoice_Date,
extracted.InvoiceNumber as Invoice_Number,
extracted.address as Address,
extracted.Total as Total,
extracted.DueDate as Due_Date,
extracted.PaymentMethod as Payment_Method
from invoice_data

-- COMMAND ----------

select * from idp.finance.invoices

-- COMMAND ----------

create or replace table purchase_order_data as
select *,
ai_extract(doc_text, Array('Merchant_Name',
'PO_Number',
'Purchase_Order_Date',
'Total')) as extracted
from classified_data
where doc_classification = 'purchase Order'

-- COMMAND ----------

create or replace table idp.finance.purchase_orders
select path,
extracted.Merchant_Name as Merchant_Name,
extracted.Purchase_Order_Date as Purchase_Order_Date,
extracted.PO_Number as PO_Number,
extracted.Total as Total
from purchase_order_data

-- COMMAND ----------

create or replace table receipts_data as
select *,
ai_extract(doc_text, Array('Merchant_Name',
'Receipt_Number',
'Transaction_Date',
'Total')) as extracted
from classified_data
where doc_classification = 'Receipt'

-- COMMAND ----------

create or replace table idp.finance.receipts
select path,
extracted.Merchant_Name as Merchant_Name,
extracted.Receipt_Number as Receipt_Number,
extracted.Transaction_Date as Transaction_Date,
extracted.Total as Total
from receipts_data