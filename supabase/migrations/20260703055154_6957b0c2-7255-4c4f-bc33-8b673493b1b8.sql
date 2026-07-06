
DROP POLICY IF EXISTS "Published articles are viewable by everyone" ON public.articles;

CREATE POLICY "Anyone can view published articles"
  ON public.articles FOR SELECT
  TO anon, authenticated
  USING (published = true);

CREATE POLICY "Admins can view all articles"
  ON public.articles FOR SELECT
  TO authenticated
  USING (has_role(auth.uid(), 'admin'::app_role));

GRANT SELECT ON public.articles TO anon;
