CREATE DATABASE matcha;

\c matcha;

--download exstension
create extension
if not exists "uuid-ossp";

CREATE TYPE gender AS ENUM
('Male', 'Female');

Create TYPE sexual_preference AS ENUM
('Heterosexual', 'Bisexual', 'Homosexual');


/*
'Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'
*/
/*
    INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Female',
    'Heterosexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '-woman.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);
    */

CREATE TABLE users
(
    user_id uuid PRIMARY KEY DEFAULT
    uuid_generate_v4(),
    user_first_name VARCHAR(255) NOT NULL,
    user_last_name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    user_password VARCHAR(255) NOT NULL,
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_complete BOOLEAN NOT NULL DEFAULT FALSE,
    reset_password_token VARCHAR(255) NOT NULL DEFAULT 0,--??????
    reset_password_expiry VARCHAR(255),
    user_birthday VARCHAR(255) NOT NULL DEFAULT 0,
    user_gender gender,
    user_sexual_preference sexual_preference DEFAULT 'Bisexual',
    user_biography VARCHAR(600),
    user_age smallint,
    user_last_connected TIMESTAMP,
    user_interests TEXT
    [],
    profile_picture VARCHAR(255),
    regular_pictures TEXT[],
    user_lon NUMERIC NOT NULL DEFAULT 0,
    user_lat NUMERIC NOT NULL DEFAULT 0,
    user_city VARCHAR
    (255) NOT NULL DEFAULT 0,
    user_score smallint DEFAULT 0
    );

    CREATE TABLE likes (
    like_id INT GENERATED ALWAYS AS IDENTITY,
    from_user_id VARCHAR
    (255) NOT NULL,
    to_user_id VARCHAR
    (255) NOT NULL);

    CREATE TABLE blocks(
    block_id INT GENERATED ALWAYS AS IDENTITY,
    from_user_id VARCHAR
    (255) NOT NULL,
    to_user_id VARCHAR
    (255) NOT NULL);

    CREATE TABLE profile_look (
    look_id INT GENERATED ALWAYS AS IDENTITY,
    from_user_id VARCHAR
    (255) NOT NULL,
    to_user_id VARCHAR
    (255) NOT NULL);

    CREATE TABLE notifications (
        notif_id INT GENERATED ALWAYS AS IDENTITY,
        to_user_id VARCHAR
    (255) NOT NULL,
        from_user_id VARCHAR
    (255) NOT NULL,
        notif_type VARCHAR
    (255) NOT NULL,
        is_read BOOLEAN NOT NULL DEFAULT FALSE);

    CREATE TABLE black_list(
        black_list INT GENERATED ALWAYS AS IDENTITY,
        token VARCHAR NOT NULL,
        timestamp timestamp NOT NULL DEFAULT NOW());
    
    CREATE TABLE messages(
        message_id INT GENERATED ALWAYS AS IDENTITY,
        from_user_id VARCHAR(255) NOT NULL,
        to_user_id VARCHAR(255) NOT NULL,
        content VARCHAR NOT NULL,
        created_at timestamp NOT NULL DEFAULT NOW()
    );

    CREATE TABLE matches(
        match_id INT GENERATED ALWAYS AS IDENTITY,
        from_user_id VARCHAR(255) NOT NULL,
        to_user_id VARCHAR(255) NOT NULL
    );

   
    CREATE FUNCTION delete_old_rows() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM black_list WHERE timestamp < NOW() - INTERVAL
        '1 hour';
    RETURN NULL;
    END;
$$;


    CREATE TRIGGER trigger_delete_old_rows
    AFTER
    INSERT ON
    black_list
    EXECUTE PROCEDURE delete_old_rows();

    CREATE TABLE reported_users (
        report_id INT GENERATED ALWAYS AS IDENTITY,
        from_user_id VARCHAR(255) NOT NULL,
        to_user_id VARCHAR (255) NOT NULL,
        timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Female',
    'Heterosexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '-woman.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

    INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Female',
    'Homosexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '-woman.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

    INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Female',
    'Bisexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '-woman.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

    INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Jacob','Michael','Matthew','Joshua','Christopher','Nicholas','Andrew','Joseph','Daniel','Tyler','William','Brandon','Ryan','John','Zachary','David','Anthony','James','Justin','Alexander','Jonathan','Christian','Austin','Dylan','Ethan','Benjamin','Noah','Samuel','Robert','Nathan','Cameron','Kevin','Thomas','Jose','Hunter'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Male',
    'Heterosexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

     INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Jacob','Michael','Matthew','Joshua','Christopher','Nicholas','Andrew','Joseph','Daniel','Tyler','William','Brandon','Ryan','John','Zachary','David','Anthony','James','Justin','Alexander','Jonathan','Christian','Austin','Dylan','Ethan','Benjamin','Noah','Samuel','Robert','Nathan','Cameron','Kevin','Thomas','Jose','Hunter'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Male',
    'Bisexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

     INSERT INTO users ( 
     user_first_name,
    user_last_name,
    username,
    user_email,
    user_password,
    is_verified,
    is_complete,
    user_gender,
    user_sexual_preference,
    user_biography,
    user_age,
    user_interests,
    user_last_connected,
    profile_picture,
    user_lat,
    user_lon
    ) SELECT
    (ARRAY['Jacob','Michael','Matthew','Joshua','Christopher','Nicholas','Andrew','Joseph','Daniel','Tyler','William','Brandon','Ryan','John','Zachary','David','Anthony','James','Justin','Alexander','Jonathan','Christian','Austin','Dylan','Ethan','Benjamin','Noah','Samuel','Robert','Nathan','Cameron','Kevin','Thomas','Jose','Hunter'])[floor(random() * 35 + 1)],
    (ARRAY['Emily','Hannah','Madison','Ashley','Sarah','Alexis','Samantha','Jessica','Elizabeth','Taylor','Lauren','Alyssa','Kayla','Abigail','Brianna','Olivia','Emma','Megan','Grace','Victoria','Rachel','Anna','Sydney','Destiny','Morgan','Jennifer','Jasmine','Haley','Julia','Kaitlyn','Nicole','Amanda','Katherine','Natalie','Hailey','Alexandra','Savannah','Chloe','Rebecca','Stephanie','Maria','Sophia','Mackenzie','Allison','Isabella','Amber','Mary'])[floor(random() * 35 + 1)],
    'user-' || round(random()*1000), -- for text
    'user@user.com', --for text
    '$2a$12$8oiPfd4Y30XOakOiTaOLqe5TsEsUeeIZyfeCgRZ9ctK9WUSBtYsyq',
    't',
    't',
    'Male',
    'Homosexual',
    'Lorem Ipsum',
     random() * (60-18+1) + 18::int,
    (ARRAY['{movies, poker, books}','{music, yoga, dance}', '{gaming, sport, travel}'])[floor(random() * 3 + 1)]::text[],
     now() + round(random()*1000) * '1 second'::interval,
     '/images/' || round(random()*50) || '.jpg',
    random() * (33.94707-33.400493+1) + 33.400493::int,
    random() * (-6.80350+6.07382) -6.07382::int
    FROM generate_series(1,100);

    