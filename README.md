The sql code in the final_project.sql converts unstructured data to structured data.
ai_parse_document() is a Databricks SQL function used for Intelligent Document Processing. It takes unstructured documents such as PDFs and uses AI models to extract structured fields like invoice numbers, dates, or totals. It is typically used together with read_files() to build document processing pipelines for analytics or GenAI applications.
ai_classify() is used to classify the data into categories
ai_extract() is used to extract the data we want from the parsed data and load into tables
Just run this script whenever new data is loaded and it processes the new unstructured data and updates the tables with new data


parse_doc_sample.ipynb notebook is implementation of how to parse, transform and chunk data. For transforming parsed json data to text i used llm and for chunking i used LangChain's RecursiveCharacterTextSplitter to split the text by the provided tokens. Chunked data is stored in the delta tables for later use.

vector_search_test.ipynb notebook shows the demo of how to create embeddings and stored in vector index. Also different search types and re-ranking is implemented for demo purpose. (Databricks hosted embedding model is used to generate emneddings)
