# Machine Learning Efficiency Project

This project evaluates the efficiency of machine learning algorithms implemented in various programming languages by
tracking energy consumption, CO2 emissions, and performance metrics. The goal is to understand the trade-offs between
speed, accuracy, and environmental impact across languages and algorithms.

---

## Table of Contents

- [Introduction](#introduction)
- [Languages and Algorithms](#languages-and-algorithms)
- [Datasets](#datasets)
- [Installation](#installation)
- [Usage](#usage)
    - [Run All Experiments](#run-all-experiments)
    - [Run Individual Experiments](#run-individual-experiments)
- [Tracking Emissions](#tracking-emissions)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction

This project investigates the trade-offs between machine learning performance and sustainability. By comparing the same
algorithms across multiple programming languages (Python, MATLAB, R, Java, C++, etc.), we aim to highlight which
languages and implementations are the most energy-efficient while maintaining model performance.

We track:

- **Execution Time**
- **Energy Consumption**
- **CO2 Emissions**

The emissions are monitored using the `CodeCarbon` library in Python and integrated into other languages through system
calls.

---

## Languages and Algorithms
 
### Supported Languages:

- Python
- MATLAB
- R
- Java
- C++
- (Future) Rust, Go, Julia, Scala, Swift, Fortran

### Algorithms Implemented:

- **Logistic Regression**
- **Decision Tree**
- **Random Forest**
- **AdaBoost**
- **K-Nearest Neighbors (KNN)**
- **Support Vector Classifier (SVC)**
- **Naive Bayes**

All algorithms are implemented with a minimal set of hyperparameters to ensure consistency across different languages.

---

## Datasets

The following datasets are used in the experiments:

- **Breast Cancer**
- **Wine Quality**
- **Iris Dataset**

Each dataset has been preprocessed and saved as CSV files located in the `datasets/` directory.

---


---

## Installation

### Prerequisites:
1. [Conda](https://docs.conda.io/en/latest/miniconda.html) (for managing environments)
2. [MATLAB](https://www.mathworks.com/products/matlab.html) (with **Statistics and Machine Learning Toolbox**)
3. [Java SDK](https://www.oracle.com/java/technologies/javase-downloads.html)
4. [R](https://cran.r-project.org/)
5. [g++](https://gcc.gnu.org/) for C++

### Steps:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/ml-efficiency-project.git
   cd ml-efficiency-project
