
CREATE TABLE mealitem
(
    id TEXT PRIMARY KEY,
    mealName TEXT,
    servingName TEXT,
    brandName TEXT,
    servingSize REAL,
    protein REAL,
    carbs REAL,
    fats REAL,
    sugar REAL,
    fiber REAL,
    saturatedFat REAL,
    monosaturatedFat REAL,
    polyunsaturatedFat REAL
)

CREATE TABLE track
(
    id TEXT PRIMARY KEY,
    protein REAL,
    carbs REAL,
    carbs REAL,
    date TEXT
)

CREATE TABLE meal_group
(
    id TEXT PRIMARY KEY,
    groupName TEXT
);

INSERT INTO meal_group
    (id,groupName)
VALUES('1', 'BreakFast');

INSERT INTO meal_group
    (id,groupName)
VALUES('2', 'Lunch');
INSERT INTO meal_group
    (id,groupName)
VALUES('3', 'Snack');
INSERT INTO meal_group
    (id,groupName)
VALUES('4', 'Dinner');


CREATE TABLE track_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    track_id TEXT NOT NULL,
    group_id TEXT NOT NULL,
    qty REAL NOT NULL,
    FOREIGN KEY
(track_id)
       REFERENCES track,
    FOREIGN KEY
(group_id)
       REFERENCES meal_group
(id) ,
    FOREIGN KEY
(meal_id)
       REFERENCES mealitem
(id)
)


CREATE TABLE goal
(
    id TEXT PRIMARY KEY,
    goalName TEXT NOT NULL,
    protein REAL,
    carbs REAL,
    fats REAL
)


CREATE TABLE recipie
(
    id TEXT PRIMARY KEY,
    recipeMeal TEXT,
    protein REAL,
    carbs REAL,
    fats REAL
)


CREATE TABLE recipie_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    recipie_id TEXT NOT NULL,
    qty REAL NOT NULL,
    FOREIGN KEY
(recipie)
       REFERENCES recipie
(id) ,
    FOREIGN KEY
(meal_id)
       REFERENCES mealitem
(id)
);




