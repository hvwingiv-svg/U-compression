# U compression

**Every pixel. Untouched.** A gaming screenshot community built around sharing and downloading original captures.

## What's in this starter

- Responsive dark landing page and screenshot gallery.
- Search and game filters.
- Sign-up and login UI powered by Supabase Auth when configured.
- Screenshot uploads that store the original file bytes without resizing or re-encoding.
- Public browsing and direct original-file links after storage is configured.
- Sample gallery cards are illustrative placeholders, not real uploads.

## 1. Create the backend (free tier may be enough for testing)

1. Create a project at [Supabase](https://supabase.com/).
2. In the Supabase dashboard, open **SQL Editor** and run all of `supabase/schema.sql`.
3. Open **Project Settings → API** (or **Connect**) and copy the Project URL and publishable/anon key. Never put a service-role key in browser code.
4. Edit `config.js` and replace the two placeholder values with your project URL and publishable/anon key.
5. Commit the change to GitHub.

The browser key is not a secret. The database and storage Row Level Security policies in `supabase/schema.sql` are the security boundary. Review them before accepting real user uploads.

## 2. Preview and deploy

- Open `index.html` locally or use GitHub Pages.
- To enable GitHub Pages: repository **Settings → Pages → Deploy from a branch → main → /(root) → Save**. Wait for the published URL shown there.
- In Supabase **Authentication → URL Configuration**, add your deployed site URL to **Site URL** and **Redirect URLs**.
- Test account sign-up, email confirmation, login, upload, public browsing, and original download.

## 3. Original quality and file limits

Uploads are sent directly to Supabase Storage with no browser-side resize or canvas conversion. The original file is stored under a unique path; the gallery displays the stored image and links to the stored original. The configured bucket limit is 25 MB per image. Actual available storage, bandwidth, and quotas depend on your Supabase plan.

## Important before public launch

- This is a starter, not a fully hardened production service. Add moderation/reporting, abuse controls, rate limits, account deletion, and a clear copyright/privacy policy before opening it widely.
- The screenshot bucket is public so visitors can browse and download originals. Anyone with a file URL can access that file; do not upload private screenshots.
- Keep the Supabase service-role key private. It must never be placed in `config.js` or other frontend code.
- Sample cards are explicitly marked “Sample” and are not database content.
