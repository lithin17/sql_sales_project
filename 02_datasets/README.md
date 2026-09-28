# Dataset

## Overview

This folder contains information about the dataset used for the **E-commerce Sales & Customer Analytics** project.


> **Note:** The dataset is used for educational and portfolio purposes. Credit belongs to the original dataset creator/source.

---

## Dataset Structure

The project uses three main tables:

```text
Dataset
│
├── cus
├── pro
└── orders
```

### 1. `cus` — Customer Data

The `cus` table contains information related to customers.

Typical information includes:

* Customer ID
* Customer location
* Customer segment
* Other customer attributes available in the source dataset

**Purpose:**
Used for customer segmentation, customer-level analysis, revenue contribution, and customer behavior analysis.

---

### 2. `pro` — Product Data

The `pro` table contains information about products.

Typical information includes:

* Product ID
* Product name
* Product category
* Other product attributes available in the source dataset

**Purpose:**
Used for product performance, category analysis, revenue contribution, and product-level analysis.

---

### 3. `orders` — Order Data

The `orders` table contains transaction-level sales information.

Typical information includes:

* Order ID
* Customer ID
* Product ID
* Order date
* Sales/revenue
* Other transaction-related attributes available in the source dataset

**Purpose:**
Used as the main transaction table for sales analysis, customer revenue analysis, product performance, and time-based analysis.

---

# Table Relationships

The tables are connected using key fields.

```text
        cus
         │
         │ customer_id
         ▼
      orders
         │
         │ product_id
         ▼
        pro
```

### Relationship Flow

**Customer → Orders → Product**

This structure allows the project to analyze:

* Customer purchasing behavior
* Product performance
* Sales performance
* Customer revenue
* Product revenue
* Category performance
* Revenue trends

---

# Data Usage

The dataset is used throughout the project for:

### SQL Analysis

* Data exploration
* Customer analysis
* Product analysis
* Sales analysis
* Revenue analysis
* Year-over-year analysis
* Customer retention analysis
* Product performance analysis
* Pareto analysis

### Power BI

The processed data is also used to create interactive dashboards and visualizations for business reporting.

---

# Data Processing Workflow

```text
   Dataset
      ↓
Data Preparation
      ↓
SQL Server
      ↓
Data Exploration
      ↓
SQL Analysis
      ↓
Business Insights
      ↓
Power BI Dashboard



# Important Note

This project does not claim ownership of the original dataset.

The dataset is used to demonstrate:

* SQL skills
* Data analysis
* Business problem solving
* Power BI reporting
* End-to-end data analytics workflow



