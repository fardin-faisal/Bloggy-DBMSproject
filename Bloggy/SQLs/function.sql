-- Drop the function if it already exists
DROP FUNCTION IF EXISTS create_user;

-- Create the function
CREATE OR REPLACE FUNCTION create_user(data JSON)
RETURNS JSON AS $$
DECLARE
	_user JSON = NULL::JSON;
	_username VARCHAR(50) = coalesce((data->>'username')::VARCHAR(50), NULL);
	_email VARCHAR(100) = coalesce((data->>'email')::VARCHAR(100), NULL);
	_password VARCHAR(255) = coalesce((data->>'password')::VARCHAR(255), NULL);
BEGIN
	-- Check if all required variables are available or not
	IF _username IS NULL THEN
		RETURN JSON_BUILD_OBJECT(
			'status', 'failed',
			'username', 'required'
		);
	END IF;
	IF _email IS NULL THEN
		RETURN JSON_BUILD_OBJECT(
			'status', 'failed',
			'email', 'required'
		);
	END IF;
	IF _password IS NULL THEN
		RETURN JSON_BUILD_OBJECT(
			'status', 'failed',
			'password', 'required'
		);
	END IF;

	-- Insert into the Users table
	INSERT INTO Users (username, email, password)
	VALUES (_username, _email, _password)
	RETURNING JSON_BUILD_OBJECT(
		'user_id', user_id,
		'username', username,
		'email', email,
		'registration_date', registration_date
	) INTO _user;

	-- Return the created user
	RETURN JSON_BUILD_OBJECT(
		'status', CASE WHEN _user IS NULL THEN 'failed' ELSE 'success' END,
		'user', _user
	);
END;
$$ LANGUAGE plpgsql;


SELECT create_user('{"username": "Faisal", "email": "fardin006@gmail.com", "password": "123"}'::JSON)


CREATE OR REPLACE FUNCTION get_users(_page INT DEFAULT 1, _limit INT DEFAULT 10)
RETURNS JSON AS $$
DECLARE
	_users JSON = NULL::JSON;
	_page INT = coalesce(_page, 1);
	_limit INT = coalesce(_limit, 10);
BEGIN
	_users = (
		SELECT JSON_AGG(u) 
		FROM (
			SELECT *
			FROM Users
			ORDER BY user_id ASC
			LIMIT _limit
			OFFSET (_page - 1) * _limit
		) u
	)::JSON;
	
	RETURN JSON_BUILD_OBJECT(
		'status', 'success',
		'users', _users
	);
END;
$$ LANGUAGE plpgsql;

SELECT get_users();


-- Drop the function if it already exists
DROP FUNCTION IF EXISTS update_user;

-- Create the function
CREATE OR REPLACE FUNCTION update_user(_user_id INTEGER, data JSON)
RETURNS JSON AS $$
DECLARE
    _user JSON = NULL::JSON;
    _username VARCHAR(50) = coalesce((data->>'username')::VARCHAR(50), NULL);
    _email VARCHAR(100) = coalesce((data->>'email')::VARCHAR(100), NULL);
    _password VARCHAR(255) = coalesce((data->>'password')::VARCHAR(255), NULL);
BEGIN
    -- Check if all required variables are available or not
    IF _user_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'userid', 'required'
        );
    END IF;
    

    -- Update the Users table
    UPDATE Users
    SET username = coalesce(_username,username) , 
	email = coalesce(_email,email), 
	password = coalesce(_password,password)
	
    WHERE user_id = _user_id
    RETURNING JSON_BUILD_OBJECT(
        'user_id', user_id,
        'username', username,
        'email', email,
        'registration_date', registration_date
    ) INTO _user;

    -- Return the updated user
    RETURN JSON_BUILD_OBJECT(
        'status', CASE WHEN _user IS NULL THEN 'failed' ELSE 'success' END,
        'user', _user
    );
END;
$$ LANGUAGE plpgsql;



-- Drop the function if it already exists
DROP FUNCTION IF EXISTS delete_user;

-- Create the function
CREATE OR REPLACE FUNCTION delete_user(_user_id INTEGER)
RETURNS JSON AS $$
DECLARE
    _user JSON = NULL::JSON;
BEGIN
    -- Delete the user from the Users table
    DELETE FROM Users
    WHERE user_id = _user_id
    RETURNING JSON_BUILD_OBJECT(
        'user_id', user_id
    ) INTO _user;

    -- Return the deleted user
    RETURN JSON_BUILD_OBJECT(
        'status', CASE WHEN _user IS NULL THEN 'failed' ELSE 'success' END,
        'user', _user
    );
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION create_category(data JSON)
RETURNS JSON AS $$
DECLARE
	_category JSON = NULL::JSON;
	_category_name VARCHAR(50) = coalesce((data->>'category_name')::VARCHAR(50), NULL);
BEGIN
	-- Check if all required variables are available or not
	IF _category_name IS NULL THEN
		RETURN JSON_BUILD_OBJECT(
			'status', 'failed',
			'category_name', 'required'
		);
	END IF;

	-- Insert into the Users table
	INSERT INTO Categories (category_name)
	VALUES (_category_name)
	RETURNING JSON_BUILD_OBJECT(
		'category_id', category_id,
		'category_name', category_name
	) INTO _category;

	-- Return the created user
	RETURN JSON_BUILD_OBJECT(
		'status', CASE WHEN _category IS NULL THEN 'failed' ELSE 'success' END,
		'category', _category
	);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_categories(_page INT DEFAULT 1, _limit INT DEFAULT 10)
RETURNS JSON AS $$
DECLARE
	_categories JSON = NULL::JSON;
	_page INT = coalesce(_page, 1);
	_limit INT = coalesce(_limit, 10);
BEGIN
	_categories = (
		SELECT JSON_AGG(c) 
		FROM (
			SELECT *
			FROM categories
			ORDER BY category_id ASC
			LIMIT _limit
			OFFSET (_page - 1) * _limit
		) c
	)::JSON;
	
	RETURN JSON_BUILD_OBJECT(
		'status', 'success',
		'categories', _categories
	);
END;
$$ LANGUAGE plpgsql;

SELECT get_categories();



CREATE OR REPLACE FUNCTION create_post(data JSON)
RETURNS JSON AS $$
DECLARE
	_post JSON = NULL::JSON;
	_user_id INT = coalesce((data->>'user_id')::INT, NULL);
	_category_id INT = coalesce((data->>'user_id')::INT, NULL);
	_title VARCHAR(50) = coalesce((data->>'title')::VARCHAR, NULL);
	_content VARCHAR(50) = coalesce((data->>'content')::VARCHAR, NULL);
BEGIN

	-- Insert into the Users table
	INSERT INTO Posts (user_id, category_id, title, content)
	VALUES (_user_id, _category_id, _title, _content)
	RETURNING JSON_BUILD_OBJECT(
		'user_id', user_id,
		'category_id', category_id,
		'title', title,
		'content', content
	) INTO _post;

	-- Return the created user
	RETURN JSON_BUILD_OBJECT(
		'status', CASE WHEN _post IS NULL THEN 'failed' ELSE 'success' END,
		'post', _post
	);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_posts(_page INT DEFAULT 1, _limit INT DEFAULT 10)
RETURNS JSON AS $$
DECLARE
	_posts JSON = NULL::JSON;
	_page INT = coalesce(_page, 1);
	_limit INT = coalesce(_limit, 10);
BEGIN
	_posts = (
		SELECT JSON_AGG(c) 
		FROM (
			SELECT *
			FROM posts
			LEFT JOIN categories ON posts.category_id = categories.category_id
			LIMIT _limit
			OFFSET (_page - 1) * _limit
		) c
	)::JSON;
	
	RETURN JSON_BUILD_OBJECT(
		'status', 'success',
		'posts', _posts
	);
END;
$$ LANGUAGE plpgsql;


-- Drop the function if it already exists
DROP FUNCTION IF EXISTS create_comment;

-- Create the function
CREATE OR REPLACE FUNCTION create_comment(data JSON)
RETURNS JSON AS $$
DECLARE
    _result JSON = NULL::JSON;
    _user_id INTEGER = (data->>'user_id')::INTEGER;
    _post_id INTEGER = (data->>'post_id')::INTEGER;
    _comment_text TEXT = data->>'comment_text';
BEGIN
    -- Check if all required variables are available or not
    IF _user_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'user_id', 'required'
        );
    END IF;
    IF _post_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'post_id', 'required'
        );
    END IF;
    IF _comment_text IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'comment_text', 'required'
        );
    END IF;

    -- Insert into the Comments table
    INSERT INTO Comments (user_id, post_id, comment_text)
    VALUES (_user_id, _post_id, _comment_text)
    RETURNING JSON_BUILD_OBJECT(
        'comment_id', comment_id,
        'user_id', user_id,
        'post_id', post_id,
        'comment_text', comment_text,
        'comment_date', comment_date
    ) INTO _result;

    -- Return success
    RETURN JSON_BUILD_OBJECT(
        'status', 'success',
        'message', 'Comment created successfully',
        'data', _result
    );
END;
$$ LANGUAGE plpgsql;



-- Drop the function if it already exists
DROP FUNCTION IF EXISTS create_like;

-- Create the function
CREATE OR REPLACE FUNCTION create_like(data JSON)
RETURNS JSON AS $$
DECLARE
    _result JSON = NULL::JSON;
    _user_id INTEGER = (data->>'user_id')::INTEGER;
    _post_id INTEGER = (data->>'post_id')::INTEGER;
BEGIN
    -- Check if all required variables are available or not
    IF _user_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'user_id', 'required'
        );
    END IF;
    IF _post_id IS NULL THEN
        RETURN JSON_BUILD_OBJECT(
            'status', 'failed',
            'post_id', 'required'
        );
    END IF;

    -- Insert into the Likes table
    INSERT INTO Likes (user_id, post_id)
    VALUES (_user_id, _post_id)
    RETURNING JSON_BUILD_OBJECT(
        'like_id', like_id,
        'user_id', user_id,
        'post_id', post_id,
        'like_date', like_date
    ) INTO _result;

    -- Return success
    RETURN JSON_BUILD_OBJECT(
        'status', 'success',
        'message', 'Like created successfully',
        'data', _result
    );
END;
$$ LANGUAGE plpgsql;


-- Drop the function if it already exists
DROP FUNCTION IF EXISTS get_comments;

-- Create the function
CREATE OR REPLACE FUNCTION get_comments(_post_id INTEGER)
RETURNS JSON AS $$
DECLARE
    _result JSON = NULL::JSON;
BEGIN
    -- Retrieve comments for the specified post
    SELECT JSON_AGG(JSON_BUILD_OBJECT(
        'comment_id', comment_id,
        'user_id', user_id,
        'comment_text', comment_text,
        'comment_date', comment_date
    )) INTO _result
    FROM Comments
    WHERE post_id = _post_id;

    -- Return the result
    RETURN _result;
END;
$$ LANGUAGE plpgsql;


-- Drop the function if it already exists
DROP FUNCTION IF EXISTS get_likes;

-- Create the function
CREATE OR REPLACE FUNCTION get_likes(post_id INTEGER)
RETURNS JSON AS $$
DECLARE
    _result JSON = NULL::JSON;
BEGIN
    -- Retrieve likes for the specified post
    SELECT JSON_AGG(JSON_BUILD_OBJECT(
        'like_id', like_id,
        'user_id', user_id,
        'like_date', like_date
    )) INTO _result
    FROM Likes
    WHERE post_id = post_id;

    -- Return the result
    RETURN _result;
END;
$$ LANGUAGE plpgsql;
