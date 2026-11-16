-- Enable Supabase Realtime for new dream comments and threaded replies.
-- Run after 202611150001_threaded_dream_comments.sql.
-- Safe to run more than once.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_publication
        WHERE pubname = 'supabase_realtime'
    ) THEN
        RAISE EXCEPTION
            'The supabase_realtime publication does not exist in this project.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_publication_tables
        WHERE pubname = 'supabase_realtime'
          AND schemaname = 'public'
          AND tablename = 'dream_comments'
    ) THEN
        EXECUTE
            'ALTER PUBLICATION supabase_realtime ADD TABLE public.dream_comments';
    END IF;
END;
$$;
