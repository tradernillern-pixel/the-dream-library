-- Threaded dream comments: one reply level beneath each original comment.
-- Safe to run on an existing dream_comments table; existing comments are preserved.

ALTER TABLE public.dream_comments
ADD COLUMN IF NOT EXISTS parent_comment_id uuid
REFERENCES public.dream_comments(id)
ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS dream_comments_parent_id_idx
ON public.dream_comments (parent_comment_id);

CREATE OR REPLACE FUNCTION public.validate_dream_comment_parent()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
    parent_dream_id uuid;
    parent_parent_id uuid;
BEGIN
    IF NEW.parent_comment_id IS NULL THEN
        RETURN NEW;
    END IF;

    SELECT dream_id, parent_comment_id
    INTO parent_dream_id, parent_parent_id
    FROM public.dream_comments
    WHERE id = NEW.parent_comment_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Parent comment not found.';
    END IF;

    IF parent_dream_id <> NEW.dream_id THEN
        RAISE EXCEPTION 'Reply must belong to the same dream.';
    END IF;

    IF parent_parent_id IS NOT NULL THEN
        RAISE EXCEPTION 'Replies can only be made to original comments.';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS dream_comment_parent_validation
ON public.dream_comments;

CREATE TRIGGER dream_comment_parent_validation
BEFORE INSERT OR UPDATE OF parent_comment_id, dream_id
ON public.dream_comments
FOR EACH ROW
EXECUTE FUNCTION public.validate_dream_comment_parent();
