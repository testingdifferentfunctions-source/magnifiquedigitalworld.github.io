
ALTER TABLE public.articles
  ADD COLUMN IF NOT EXISTS title_uk TEXT,
  ADD COLUMN IF NOT EXISTS title_en TEXT,
  ADD COLUMN IF NOT EXISTS description_uk TEXT,
  ADD COLUMN IF NOT EXISTS description_en TEXT,
  ADD COLUMN IF NOT EXISTS content_uk TEXT,
  ADD COLUMN IF NOT EXISTS content_en TEXT;

-- Backfill from legacy single-language columns (Ukrainian is the base language)
UPDATE public.articles SET title_uk = COALESCE(title_uk, title) WHERE title_uk IS NULL;
UPDATE public.articles SET description_uk = COALESCE(description_uk, description) WHERE description_uk IS NULL;
UPDATE public.articles SET content_uk = COALESCE(content_uk, content) WHERE content_uk IS NULL;

-- Pull any existing English translations from article_translations into the new columns
UPDATE public.articles a
SET
  title_en = COALESCE(a.title_en, t.title),
  description_en = COALESCE(a.description_en, t.description),
  content_en = COALESCE(a.content_en, t.content)
FROM public.article_translations t
WHERE t.article_id = a.id AND t.language = 'en';
