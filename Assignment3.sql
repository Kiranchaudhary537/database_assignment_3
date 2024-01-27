-- All Tables 
-- users table
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone_number VARCHAR(10) UNIQUE NOT NULL
);

-- tweets table 
CREATE TABLE tweets (
  tweet_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  tweeted_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- like table
CREATE TABLE likes (
  like_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  tweet_id INTEGER NOT NULL,
  liked_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id)
);

-- retretweets table
CREATE TABLE retweets (
  retweet_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  original_tweet_id INTEGER NOT NULL,
  retweeted_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (original_tweet_id) REFERENCES tweets(tweet_id)
);

-- comments table
CREATE TABLE comments (
  comment_id SERIAL PRIMARY KEY,
  tweet_id INTEGER  NOT NULL,
  parent_comment_id INTEGER ,
  commented_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
  FOREIGN KEY (parent_comment_id) REFERENCES tweets(tweet_id)
);

-- followers table
CREATE TABLE followers (
  follower_id SERIAL PRIMARY KEY,
  following_user_id INTEGER  NOT NULL,
  follower_user_id INTEGER  NOT NULL,
  followed_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  FOREIGN KEY (following_user_id) REFERENCES users(user_id),
  FOREIGN KEY (follower_user_id) REFERENCES users(user_id)
);


-----  Data for tables

-- Insert data into Users table
INSERT INTO users (user_id, name, email, phone_number)
VALUES 
  (1, 'Vander', 'vader@example.com', '6354844565'),
  (2, 'Leia', 'leia@example.com', '9425753836'),
  (3, 'Obi-Wan', 'obiwan@example.com', '8780230582');

-- Insert data into Tweets table
INSERT INTO tweets (tweet_id, user_id, content)
VALUES 
  (1, 1, 'I find your lack of faith disturbing.'),
  (2, 3, 'The Force will be with you. Always.'),
  (3, 2, 'Help me, Obi-Wan Kenobi. You’re my only hope.');

-- Insert data into Retweets table
INSERT INTO retweets (retweet_id, user_id, original_tweet_id)
VALUES 
  (1, 3, 1);

-- Insert data into Likes table
INSERT INTO likes (like_id, user_id, tweet_id)
VALUES 
  (1, 2, 1);

-- Insert data into Followers table
INSERT INTO followers (follower_id, following_user_id, follower_user_id)
VALUES 
  (1, 1, 2),
  (2, 3, 1);

-- Insert data into Comments table
INSERT INTO comments (comment_id, tweet_id, parent_comment_id)
VALUES 
  (1, 1, NULL), (2, 2, NULL),(3,3,2);



--- All query

-- 1. Fetch all users name from database.
  SELECT name FROM users;

-- 2. Fetch all tweets of user by user id most recent tweets first.
  SELECT tweet_id, content, tweeted_at
  FROM tweets
  WHERE user_id = 1
  ORDER BY tweeted_at DESC;


-- 3. Fetch like count of particular tweet by tweet id.
  SELECT COUNT(*) AS total_likes_count
  FROM likes
  WHERE tweet_id = 1;

-- 4. Fetch retweet count of particular tweet by tweet id.
  SELECT COUNT(*) AS total_retweet_count
  FROM retweets
  WHERE original_tweet_id = 1;

-- 5. Fetch comment count of particular tweet by tweet id.
  SELECT COUNT(*) AS total_comment_count
  FROM comments
  WHERE tweet_id = 2;

-- 6. Fetch all user’s name who have retweeted particular tweet by tweet id.
  SELECT u.name
  FROM retweets r
  JOIN users u ON r.user_id = u.user_id
  WHERE r.original_tweet_id = 1;

-- 7. Fetch all commented tweet’s content for particular tweet by tweet id.
  SELECT t.content
  FROM comments c
  JOIN tweets t ON c.tweet_id = t.tweet_id
  WHERE c.parent_comment_id =2;


-- 8. Fetch user’s timeline (All tweets from users whom I am following with tweet content and user name who has tweeted it)
  SELECT t.tweet_id, t.content, u.name AS user_name
  FROM tweets t
  JOIN users u ON t.user_id = u.user_id 
  WHERE u.user_id in (SELECT following_user_id from followers WHERE follower_user_id=1) 
  ORDER BY t.tweeted_at DESC;
