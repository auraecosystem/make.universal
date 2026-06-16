---
name: docs/video.md
---
```markdown
# Quick demo video

Below is a short demo video that highlights running the server and the Playground demo.

Replace the `src` value with your project's hosted video (YouTube/Vimeo).

<iframe width="100%" height="480" src="https://www.youtube.com/embed/VIDEO_ID" title="makeuniversal demo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
```
Notes:
- For GitHub Pages the iframe will work for YouTube/Vimeo URLs.
- If you prefer a self-hosted MP4, add the file to `assets/media/` and use:
```html
  <video controls width="100%"><source src="/assets/media/demo.mp4" type="video/mp4">Your browser does not support the video tag.</video>
  
Suggested nav enhancement for index.html
- Add links for API, Install, Video in the header nav (optional). Replace the <nav> block inside index.html with the following (or add links as you prefer):
```
```html
<nav class="nav">
  <a href="#quickstart">Quickstart</a>
  <a href="#features">Features</a>
  <a href="docs/index.md">Docs</a>
  <a href="docs/api.md">API</a>
  <a href="docs/install.md">Install</a>
  <a href="docs/video.md">Video</a>
  <a href="#contribute">Contribute</a>
</nav>
