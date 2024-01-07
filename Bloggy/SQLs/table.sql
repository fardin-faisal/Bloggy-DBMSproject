-- Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posts Table
CREATE TABLE Posts (
    post_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    publish_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_edit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Comments Table
CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    post_id INTEGER REFERENCES Posts(post_id),
    comment_text TEXT NOT NULL,
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- PostCategories Table 
CREATE TABLE PostCategories (
    post_id INTEGER REFERENCES Posts(post_id),
    category_id INTEGER REFERENCES Categories(category_id),
    PRIMARY KEY (post_id, category_id)
);

-- Likes Table
CREATE TABLE Likes (
    like_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    post_id INTEGER REFERENCES Posts(post_id),
    like_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
