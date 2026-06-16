# API Reference & generation

This project includes some scripts to generate API reference docs for Python-based modules and C++ components. Below are recommended steps and tips.

Quick notes
- There are multiple doc-generation helpers in the repo:
  - `build_model_maker_api_docs.mk` — contains a Python docgen script (MediaPipe example).
  - Templates and mdBook/Pages workflows under `.github/workflows`.

Generate Python API docs (example)
1. Create a virtualenv and install prerequisites:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -U pip setuptools wheel
   pip install -U git+https://github.com/tensorflow/docs
