The sql code in the final_project.sql converts unstructured data to structured data.
ai_parse_document() is a Databricks SQL function used for Intelligent Document Processing. It takes unstructured documents such as PDFs and uses AI models to extract structured fields like invoice numbers, dates, or totals. It is typically used together with read_files() to build document processing pipelines for analytics or GenAI applications.
ai_classify() is used to classify the data into categories
ai_extract() is used to extract the data we want from the parsed data and load into tables
Just run this script whenever new data is loaded and it processes the new unstructured data and updates the tables with new data
