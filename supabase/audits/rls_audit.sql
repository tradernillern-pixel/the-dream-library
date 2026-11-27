-- The Dream Library: read-only Supabase security audit
-- Run each SELECT separately in Supabase SQL Editor so every result is visible.
-- These statements inspect configuration only; they do not change data or policies.

-- 1) Check RLS on every public application table AND storage.objects.
-- A row marked REVIEW means RLS is disabled and the table needs investigation.
WITH audited_relations AS (
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

    UNION ALL

    SELECT
        n.nspname AS schema_name,
        c.relname AS table_name,
        c.relrowsecurity AS rls_enabled,
        c.relforcerowsecurity AS rls_forced
    FROM pg_class AS c
    JOIN pg_namespace AS n
        ON n.oid = c.relnamespace
    WHERE n.nspname = 'storage'
      AND c.relname = 'objects'
      AND c.relkind IN ('r', 'p')
)
SELECT
    schema_name,
    table_name,
    rls_enabled,
    rls_forced,
    CASE
        WHEN rls_enabled THEN 'RLS enabled — inspect policies'
        ELSE 'REVIEW — RLS is disabled'
    END AS review_status
FROM audited_relations
ORDER BY schema_name, table_name;

-- 2) Inspect every policy on application tables and Supabase Storage.
-- using_expression is the USING condition.
-- check_expression is the WITH CHECK condition.
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

-- 3) Check whether the two image buckets referenced by the website are public.
SELECT
    id,
    name,
    public
FROM storage.buckets
WHERE id IN ('chat-images', 'profile-images')
ORDER BY id;

-- IMPORTANT:
-- RLS being enabled does not prove that a table is secure.
-- Review each policy's roles, command, USING, and WITH CHECK expressions.
-- Do not blindly enable/force RLS or replace policies before reviewing
-- the real query results and the app's required access patterns.
