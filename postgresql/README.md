# PostgreSQL Learning Exercises

This document explains the SQL exercises in plain English to help you understand what each query does.

## Table Setup

### Creating the Cities Table
We create a table called `cities` to store information about different cities around the world. The table has four columns:
- **name**: stores the city name (up to 50 characters)
- **country**: stores the country name (up to 50 characters)
- **population**: stores the number of people living in the city
- **area**: stores the city's area in square kilometers

### Inserting Data
We add city information to the table in two steps:
1. First, we add Tokyo with its population of 38,505,000 and area of 8,223 square kilometers
2. Then, we add three more cities: Delhi (India), Shanghai (China), and São Paulo (Brazil)

## Basic Calculations

### Population Density
We calculate how crowded each city is by dividing the population by the area. This gives us the number of people per square kilometer, which we label as "population_density".

## Working with Text (String Functions)

### Combining Text
We can combine the city name and country in different ways:
- Using the `||` operator to join text with commas and spaces (for example: "Tokyo, Japan")
- Using the `CONCAT` function to do the same thing
- Using `UPPER` to make city names all uppercase, `LOWER` to make them lowercase, and `LENGTH` to count how many characters are in each name

## Filtering Data

### Basic Filtering
We can search for specific cities based on certain conditions:
- **Cities with large area**: Find cities where the area is greater than 4,000 square kilometers
- **Exact match**: Find cities where the area equals exactly 8,223 square kilometers
- **Not equal**: Find cities where the area is anything except 8,223 square kilometers

### Query Execution Order
When a query runs, SQL doesn't execute keywords in the order they're written. For a SELECT-FROM-WHERE query:
1. **FROM** executes first - it identifies which table to use
2. **WHERE** executes second - it filters the rows
3. **SELECT** executes third - it picks which columns to show

### Range Filtering
- **BETWEEN**: Find cities with area between 2,000 and 4,000 square kilometers (inclusive)

### List Filtering
We can check if values match items in a specific list:
- **IN**: Find cities whose names are Delhi or Shanghai
- **NOT IN**: Find cities whose names are NOT Delhi or Shanghai
- Also works with numbers: find cities whose area is not 3,043 or 8,223

### Combining Conditions
We can use multiple conditions together:
- **AND**: Both conditions must be true (example: area not in a list AND name equals Delhi)
- **OR**: At least one condition must be true (example: area not in a list OR name equals Delhi)

### Filtering Calculated Values
We can filter based on calculations done in the query itself. For example, find cities where the population density (population divided by area) is greater than 6,000 people per square kilometer.

## Modifying Data

### Updating Records
We can change existing data in the table. For example, we update Tokyo's population to 39,505,000 (increasing it by 1 million).

### Deleting Records
We can remove data from the table. For example, we delete all information about Tokyo from the cities table.

## SQL Joins

Joins let you pull together data from two or more tables in a single query by linking them through a common column.

### Setup

To illustrate joins we create two related tables:

- **users** — each user has an `id` and a `username`
- **photos** — each photo has an `id`, a `url`, and a `user_id` that points back to the `users` table

The sample data is intentionally designed to show edge cases:
- **Dave** is a user who has no photos
- One photo has `user_id = NULL`, making it an *orphaned* photo with no owner

### INNER JOIN
Returns only the rows where there is a matching value in **both** tables.

```
users  ──┐
          ├── only rows with a match on both sides
photos ──┘
```

Dave and the orphaned photo are excluded because neither has a match on the other side.

**Use when**: you only want records that exist in both tables.

### LEFT JOIN (LEFT OUTER JOIN)
Returns **all rows from the left table** (`users`) plus the matched rows from the right table (`photos`). Where there is no match, the photo columns are filled with `NULL`.

Dave appears in the result with `NULL` for the photo URL because he has no photos.

**Use when**: you want every record from the main (left) table regardless of whether a related record exists.

### RIGHT JOIN (RIGHT OUTER JOIN)
Returns **all rows from the right table** (`photos`) plus the matched rows from the left table (`users`). Where there is no match, the user columns are filled with `NULL`.

The orphaned photo appears in the result with `NULL` for the username.

**Use when**: you want every record from the secondary (right) table regardless of whether a related record exists. (In practice, most developers rewrite this as a LEFT JOIN by swapping the table order.)

### FULL JOIN (FULL OUTER JOIN)
Returns **all rows from both tables**. Unmatched rows from either side have `NULL` for the columns of the other table.

Both Dave (no photos) and the orphaned photo (no user) appear, each with `NULL` on the unmatched side.

**Use when**: you need a complete picture of both tables and want to see everything, matched or not.

### Practical Examples

#### Find users with no photos
Combine a LEFT JOIN with a `WHERE` filter for `NULL` on the right side. This is a common pattern for finding "missing" relationships.

```sql
SELECT users.username
FROM users
LEFT JOIN photos ON photos.user_id = users.id
WHERE photos.id IS NULL;
```

#### Count photos per user (including users with zero photos)
Use a LEFT JOIN so users with no photos still appear in the result, then use `COUNT` and `GROUP BY` to tally photos per person.

```sql
SELECT users.username, COUNT(photos.id) AS photo_count
FROM users
LEFT JOIN photos ON photos.user_id = users.id
GROUP BY users.username
ORDER BY photo_count DESC;
```

### Join Type Summary

| Join Type  | Left table rows | Right table rows |
|------------|----------------|-----------------|
| INNER JOIN | matched only   | matched only    |
| LEFT JOIN  | all            | matched only    |
| RIGHT JOIN | matched only   | all             |
| FULL JOIN  | all            | all             |

---

**Tutorial Source**: These exercises follow the PostgreSQL tutorials at https://www.pg-sql.com/

**Reference Source**: To visually understand the sql joins at https://joins.spathon.com/
