# Decision Tree Classification

Decision trees are supervised learning algorithms used to classify data by asking a series of logical questions.

## Core Concept
The goal is to classify data points (for example, red and green dots) by recursively splitting the dataset based on specific features [00:00:42].

### Structure of the Tree
* **Decision Nodes:** These represent conditions or questions (e.g., is $X_0 \leq -12$?).
* **Leaf Nodes:** The final "branches" that provide the classification outcome [00:01:42].
* **Paths:**
    * Exit to the **Left**: Represents **Yes / True** (condition met) [00:02:12].
    * Exit to the **Right**: Represents **No / False** (condition not met) [00:02:27].

![Decision Tree Diagram](../../assets/decision-tree.png)

## Finding the Best Split: Information Gain
Since there are many possible ways to split data, the algorithm must identify the "best" one. It does this by maximizing **Information Gain** [00:06:13].

### Entropy (Measuring Uncertainty)
Entropy is used to quantify the impurity or uncertainty within a group of data [00:06:48].
* **Entropy = 1:** Highest uncertainty (e.g., a 50/50 mix of red and green dots) [00:07:13].
* **Entropy = 0:** Perfectly classified data. This is known as a **Pure Node** [00:07:59].

### Calculating Information Gain
To decide which feature to split on, the algorithm subtracts the entropy of the "child" nodes from the entropy of the "parent" node:

$$\text{Information Gain} = \text{Entropy (Parent)} - \text{Weighted Entropy (Children)}$$

The model traverses every possible feature and value to find the split that results in the highest Information Gain [00:08:07].

!!! note "Greedy Algorithm"
    The Decision Tree is a **greedy algorithm**. It makes the best possible choice at each step (locally optimal) but does not backtrack to change previous decisions [00:09:03].

---
**Source:** [Decision Tree Classification Clearly Explained!](https://www.youtube.com/watch?v=ZVR2Way4nwQ)