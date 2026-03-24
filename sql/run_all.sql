-- ============================================
-- Master Execution Script
-- ============================================

-- 1. Required objects
@init/required_objects.sql

-- 2. Packages
@../packages/enrollment_pkg.sql
@../packages/reporting_pkg.sql
@../packages/assessment_pkg.sql

-- 3. Trigger
@../triggers/audit_grade_change.sql

-- 4. Tests
@../tests/tests.sql