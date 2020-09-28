
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
);

CREATE TABLE track
(
    id TEXT PRIMARY KEY,
    protein REAL,
    carbs REAL,
    fats REAL,
    date TEXT
);

CREATE TABLE meal_group
(
    id TEXT PRIMARY KEY,
    groupName TEXT
);


CREATE TABLE track_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    track_id TEXT NOT NULL,
    group_id TEXT NOT NULL,
    origin TEXT NOT NULL,
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
(id) ON DELETE CASCADE
);


CREATE TABLE goal
(
    id TEXT PRIMARY KEY,
    isActive BOOLEAN ,
    goalName TEXT NOT NULL,
    protein REAL,
    carbs REAL,
    fats REAL
);

INSERT INTO goal
    (id,isActive,goalName,protein,carbs,fats)
VALUES('1', 1, 'MyGoal', 180, 250, 60);


CREATE TABLE recipe
(
    id TEXT PRIMARY KEY,
    recipeName TEXT,
    protein REAL,
    carbs REAL,
    fats REAL
);


CREATE TABLE recipe_meal
(
    id TEXT PRIMARY KEY ,
    meal_id TEXT NOT NULL,
    recipe_id TEXT NOT NULL,
    qty REAL NOT NULL,
    FOREIGN KEY
(recipe)
       REFERENCES recipe
(id) ,
    FOREIGN KEY
(meal_id)
       REFERENCES mealitem 
(id) ON DELETE CASCADE
);




