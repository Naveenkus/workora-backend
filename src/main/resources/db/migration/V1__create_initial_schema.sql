
    CREATE TABLE users (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(150) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        role VARCHAR(20) NOT NULL CHECK (role IN ('client', 'freelancer', 'admin')),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );


    CREATE TABLE profiles (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        bio TEXT,
        education TEXT,
        experience TEXT,
        city VARCHAR(100),
        phone VARCHAR(20),
        profile_image_url VARCHAR(500),
        hourly_rate DECIMAL(10, 2),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE skills (
        id BIGSERIAL PRIMARY KEY,
        name VARCHAR(100) UNIQUE NOT NULL,
        category VARCHAR(100)
    );

    CREATE TABLE user_skills (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
        proficiency VARCHAR(20) NOT NULL CHECK (proficiency IN ('beginner', 'intermediate', 'expert')),
        UNIQUE(user_id, skill_id)
    );

    CREATE TABLE jobs (
        id BIGSERIAL PRIMARY KEY,
        client_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        title VARCHAR(200) NOT NULL,
        description TEXT,
        budget DECIMAL(10,2),
        deadline DATE,
        category VARCHAR(100),
        city VARCHAR(100),
        status VARCHAR(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'completed')),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    CREATE TABLE job_skills (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
        skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
        UNIQUE(job_id, skill_id)
    );

    CREATE TABLE applications (
        id BIGSERIAL PRIMARY KEY,
        job_id BIGINT NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
        freelancer_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        proposal TEXT,
        status VARCHAR(20) NOT NUll DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
        applied_at TIMESTAMP DEFAULT NOW(),
        UNIQUE(job_id, freelancer_id)
    );

    CREATE TABLE portfolios (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        title VARCHAR(200) NOT NULL,
        description TEXT,
        project_link VARCHAR(500),
        image_url VARCHAR(500),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );


    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_users_updated_at
        BEFORE UPDATE ON users
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

    CREATE TRIGGER trigger_profiles_updated_at
        BEFORE UPDATE ON profiles
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

    CREATE TRIGGER trigger_jobs_updated_at
        BEFORE UPDATE ON jobs
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

    CREATE TRIGGER trigger_portfolios_updated_at
        BEFORE UPDATE ON portfolios
        FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

