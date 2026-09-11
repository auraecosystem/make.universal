(() => {
  'use strict';

  const root = document.documentElement;
  const themeToggle = document.getElementById('theme-toggle');
  const storedTheme = localStorage.getItem('make-universe-theme');
  if (storedTheme === 'light' || storedTheme === 'dark') root.dataset.theme = storedTheme;

  themeToggle?.addEventListener('click', () => {
    const next = root.dataset.theme === 'light' ? 'dark' : 'light';
    root.dataset.theme = next;
    localStorage.setItem('make-universe-theme', next);
  });

  const output = document.getElementById('command-output');
  const copy = document.getElementById('copy-command');
  document.querySelectorAll('[data-command]').forEach((button) => {
    button.addEventListener('click', () => {
      output.textContent = button.dataset.command;
      copy?.focus();
    });
  });

  copy?.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(output.textContent);
      copy.textContent = 'Copied';
      setTimeout(() => { copy.textContent = 'Copy'; }, 1200);
    } catch (_) { copy.textContent = 'Select + copy'; }
  });

  document.querySelectorAll('a[href^="#"]').forEach((link) => {
    link.addEventListener('click', (event) => {
      const target = document.querySelector(link.getAttribute('href'));
      if (!target) return;
      event.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      history.pushState(null, '', link.getAttribute('href'));
    });
  });

  const status = document.getElementById('repo-status');
  const meta = document.getElementById('repo-meta');
  async function loadRepositorySignal() {
    try {
      const response = await fetch('https://api.github.com/repos/auraecosystem/make.universe/actions/runs?per_page=1', { headers: { Accept: 'application/vnd.github+json' } });
      if (!response.ok) throw new Error('GitHub API unavailable');
      const data = await response.json();
      const run = data.workflow_runs?.[0];
      if (!run) throw new Error('No workflow run found');
      const state = run.conclusion || run.status;
      status.textContent = state === 'success' ? 'Pipeline healthy' : `Pipeline ${state}`;
      meta.textContent = `${run.name} · ${new Date(run.updated_at).toLocaleString()} · ${run.head_branch}`;
    } catch (_) {
      status.textContent = 'Repository online';
      meta.textContent = 'Live Actions signal is unavailable from this browser session. Use GitHub Actions for the authoritative status.';
    }
  }
  loadRepositorySignal();
})();
