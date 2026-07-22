-- Database initialization script for Don't Buy Yet application

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum types
CREATE TYPE personality_type AS ENUM ('impulsive', 'rational', 'emotional', 'frugal');
CREATE TYPE recommendation_type AS ENUM ('buy', 'wait', 'dont_buy');
CREATE TYPE cooling_status AS ENUM ('cooling', 'purchased', 'abandoned', 'expired');
CREATE TYPE final_decision AS ENUM ('purchased', 'abandoned', 'expired');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_user_profiles_personality ON user_profiles(personality_type);
CREATE INDEX IF NOT EXISTS idx_products_user_id ON products(user_id);
CREATE INDEX IF NOT EXISTS idx_questionnaires_product_id ON questionnaires(product_id);
CREATE INDEX IF NOT EXISTS idx_analysis_results_product_id ON analysis_results(product_id);
CREATE INDEX IF NOT EXISTS idx_cooling_items_user_id ON cooling_items(user_id);
CREATE INDEX IF NOT EXISTS idx_cooling_items_status ON cooling_items(status);
CREATE INDEX IF NOT EXISTS idx_purchase_reviews_user_id ON purchase_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_purchase_reviews_product_id ON purchase_reviews(product_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create function to calculate user's monthly spending
CREATE OR REPLACE FUNCTION calculate_monthly_spending(user_id_param INTEGER)
RETURNS DECIMAL(10,2) AS $$
DECLARE
    total_spending DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(actual_purchase_price), 0)
    INTO total_spending
    FROM purchase_reviews
    WHERE user_id = user_id_param
    AND EXTRACT(MONTH FROM reviewed_at) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM reviewed_at) = EXTRACT(YEAR FROM CURRENT_DATE);
    
    RETURN total_spending;
END;
$$ LANGUAGE plpgsql;

-- Create view for user spending summary
CREATE OR REPLACE VIEW user_spending_summary AS
SELECT 
    u.id as user_id,
    u.nickname,
    u.monthly_disposable_budget,
    u.current_month_spending,
    COUNT(DISTINCT p.id) as total_products,
    COUNT(DISTINCT q.id) as total_questionnaires,
    COUNT(DISTINCT a.id) as total_analyses,
    COUNT(DISTINCT c.id) as total_cooling_items,
    COUNT(DISTINCT pr.id) as total_purchases,
    COALESCE(SUM(pr.actual_purchase_price), 0) as total_spent,
    COALESCE(AVG(pr.satisfaction_score), 0) as avg_satisfaction,
    COALESCE(AVG(pr.regret_score), 0) as avg_regret
FROM user_profiles u
LEFT JOIN products p ON u.id = p.user_id
LEFT JOIN questionnaires q ON p.id = q.product_id
LEFT JOIN analysis_results a ON p.id = a.product_id
LEFT JOIN cooling_items c ON p.id = c.product_id AND c.user_id = u.id
LEFT JOIN purchase_reviews pr ON p.id = pr.product_id AND pr.user_id = u.id
GROUP BY u.id, u.nickname, u.monthly_disposable_budget, u.current_month_spending;

-- Create view for cooling pool effectiveness
CREATE OR REPLACE VIEW cooling_pool_effectiveness AS
SELECT 
    c.user_id,
    COUNT(*) as total_items,
    SUM(CASE WHEN c.status = 'purchased' THEN 1 ELSE 0 END) as purchased_count,
    SUM(CASE WHEN c.status = 'abandoned' THEN 1 ELSE 0 END) as abandoned_count,
    SUM(CASE WHEN c.status = 'expired' THEN 1 ELSE 0 END) as expired_count,
    SUM(CASE WHEN c.status = 'cooling' THEN 1 ELSE 0 END) as cooling_count,
    ROUND(
        (SUM(CASE WHEN c.status IN ('abandoned', 'expired') THEN 1 ELSE 0 END)::DECIMAL / 
        NULLIF(SUM(CASE WHEN c.status IN ('purchased', 'abandoned', 'expired') THEN 1 ELSE 0 END), 0)) * 100, 
        2
    ) as success_rate,
    AVG(
        CASE 
            WHEN c.completed_at IS NOT NULL AND c.start_time IS NOT NULL 
            THEN EXTRACT(EPOCH FROM (c.completed_at - c.start_time)) / 3600
            ELSE NULL 
        END
    ) as avg_cooling_hours
FROM cooling_items c
GROUP BY c.user_id;

-- Create view for recommendation accuracy
CREATE OR REPLACE VIEW recommendation_accuracy AS
SELECT 
    a.user_id,
    COUNT(*) as total_recommendations,
    SUM(
        CASE 
            WHEN a.recommendation = 'buy' AND pr.satisfaction_score >= 70 THEN 1
            WHEN a.recommendation = 'dont_buy' AND pr.satisfaction_score < 50 THEN 1
            WHEN a.recommendation = 'wait' AND pr.satisfaction_score BETWEEN 50 AND 70 THEN 1
            ELSE 0
        END
    ) as correct_recommendations,
    ROUND(
        (SUM(
            CASE 
                WHEN a.recommendation = 'buy' AND pr.satisfaction_score >= 70 THEN 1
                WHEN a.recommendation = 'dont_buy' AND pr.satisfaction_score < 50 THEN 1
                WHEN a.recommendation = 'wait' AND pr.satisfaction_score BETWEEN 50 AND 70 THEN 1
                ELSE 0
            END
        )::DECIMAL / NULLIF(COUNT(*), 0)) * 100, 
        2
    ) as accuracy_percentage
FROM analysis_results a
LEFT JOIN purchase_reviews pr ON a.product_id = pr.product_id AND a.user_id = pr.user_id
WHERE pr.id IS NOT NULL
GROUP BY a.user_id;

-- Create indexes for views (if needed)
CREATE INDEX IF NOT EXISTS idx_user_spending_summary_user_id ON user_profiles(id);
CREATE INDEX IF NOT EXISTS idx_cooling_pool_effectiveness_user_id ON cooling_items(user_id);
CREATE INDEX IF NOT EXISTS idx_recommendation_accuracy_user_id ON analysis_results(user_id);