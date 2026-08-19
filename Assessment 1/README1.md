# E-Commerce Catalogue Exploration

This assignment examines a combined online-product catalogue with Python. The notebook takes the data from its raw CSV form through inspection, cleaning, feature creation, analysis, and visual reporting.

## What the analysis covers

- Review the dataset shape, columns, data types, and missing values.
- Convert price fields into usable numeric values and remove duplicate products.
- Produce savings, popularity, price-band, and discount-band fields for analysis.
- Compare ratings, review activity, prices, discounts, and product categories.
- Present the results with distributions, box plots, bar charts, correlation views, and scatter plots.

## Dataset

The input is a CSV file containing more than one thousand product listings. Important fields include `product_id`, `title`, `rating`, `ratings_count`, `initial_price`, `discount`, `final_price`, and `category`.

## Method used

Price text is cleaned before conversion to numeric values. Missing numeric entries are handled with appropriate summary values, and product identifiers are used to identify duplicates. The notebook then derives the amount saved, a weighted popularity score based on ratings and review counts, and descriptive price and discount groups.

## Project contents

```text
Assessment 1/
├── Assessment1.ipynb            # Analysis notebook
├── README1.md                   # Assignment overview
└── combined_dataset/
    └── Combined_dataset.csv     # Source catalogue
```

## Running the notebook

Use Python 3.8 or later, then install the required packages:

```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install pandas numpy matplotlib seaborn jupyter
jupyter notebook Assessment1.ipynb
```

Run the notebook in sequence so each transformation and chart uses the prepared dataset from the preceding steps.
