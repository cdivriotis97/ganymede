# Random Forest Algorithm

The **Random Forest** is an ensemble learning method that builds multiple decision trees to create a more robust and accurate model.

## Core Concept

A Random Forest is a collection of many **Decision Trees** working together. By combining multiple models, it reduces "variance" and becomes much less sensitive to specific fluctuations in the training data [[00:02:11]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D131s).

## How It Works

### 1. Bootstrapping (Data Sampling)

The algorithm creates multiple new datasets from the original one using **Bootstrapping**:

* **Row Sampling:** It randomly selects rows *with replacement* (the same row can appear multiple times in a new set) [[00:03:09]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D189s).
* **Feature Selection:** It does not use every feature for every tree. Instead, it randomly selects a subset of features (columns) to train each tree [[00:03:43]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D223s).

### 2. Building the Forest

A decision tree is trained independently for each bootstrap dataset [[00:03:34]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D214s). Because they use different data and different features, the trees look very different from one another [[00:04:36]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D276s).

### 3. Aggregation (Final Prediction)

To predict a value, the data point is passed through every tree in the forest [[00:05:21]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D321s):

* **Classification:** The final prediction is decided by a **majority vote**.
* **Regression:** The final prediction is the **average** of all individual tree results [[00:07:25]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D445s).

---

## Technical Jargon: Bagging

The combination of **B**ootstrap and **Agg**regat**ing** is known as **Bagging** [[00:05:46]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D346s).

!!! tip "Randomness is Key"
The name "Random" Forest comes from two random processes:
1. **Random Bootstrapping** of the data.
2. **Random Feature Selection** at each split.
This ensures the trees are uncorrelated and "balance each other out" [[00:06:29]](https://www.google.com/search?q=https://www.youtube.com/watch%3Fv%3Dv6VJ2RO66Ag%26t%3D389s).

---

**Source:** [Normalized Nerd - Random Forest Algorithm](https://www.youtube.com/watch?v=v6VJ2RO66Ag)

---