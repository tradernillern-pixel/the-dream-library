-- The Dream Library: read-only Supabase security audit
-- Run this in Supabase SQL Editor. These statements inspect configuration only;
-- they do not enable/disable RLS or change any policies.

-- 1) Show every ordinary/partitioned table in the public schema and its RLS status.
SELECT
    n.nspname AS schema_name,
    c.relname AS table_name,
    c.relrowsecurity AS rls_enabled,
    c.relforcerowsecurity AS rls_forced
FROM pg_class AS c
JOIN pg_namespace AS n
    ON n.oid = c.relnamespace
WHERE n.nspname = 'public'
  AND c.relkind IN ('r', 'p')
ORDER BY c.relname;

-- 2) Show every policy on application tables and Supabase Storage objects.
-- "qual" is the USING expression; "with_check" is the WITH CHECK expression.
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual AS using_expression,
    with_check AS check_expression
FROM pg_policies
WHERE schemaname IN ('public', 'storage')
ORDER BY schemaname, tablename, policyname;

-- 3) Show the configured Storage buckets used by the website.
-- The app currently references the chat-images and profile-images buckets.
SELECT
    id,
    name,
    public
FROM storage.buckets
WHERE id IN ('chat-images', 'profile-images')
ORDER BY id;
