# AGENTS.md

## Project Shape
- This is a small Bash CLI, not a package-managed app. There are no npm/Python/Rust manifests or configured test runners.
- `md2pdf.sh` is both the executable entrypoint and sourceable library. When sourced it defines `md2pdf`, `md2pdf_light`, and `md2pdf_dark`; when executed directly it calls `md2pdf "$@"`.
- `install.sh` is the installer/uninstaller. It downloads `md2pdf.sh` from `SmilingBytes/md2pdf` `main`, installs to `$HOME/.local/share/md2pdf`, and symlinks `$HOME/.local/bin/md2pdf`.

## Commands
- Syntax-check scripts with `bash -n md2pdf.sh install.sh generate_changelog.sh`.
- Check runtime dependencies with `./md2pdf.sh --check-deps` or installer-only with `./install.sh --check`.
- Focused conversion smoke test: create a temporary Markdown file outside the repo or with an ignored `test*.md`/`sample*.md` name, then run `./md2pdf.sh test.md -o test.pdf`; generated PDFs are ignored by git.
- Debug the CLI path with `bash -x ./md2pdf.sh <input.md>`.

## Runtime Dependencies
- Real conversion requires `pandoc` and `weasyprint`; watch mode optionally uses `inotifywait` and otherwise falls back to polling.
- `md2pdf.sh` pipes Pandoc stderr through `grep -v "WARNING:"` but preserves Pandoc's exit code via `PIPESTATUS[0]`; be careful when editing that pipeline.

## Release Notes
- Releases are tag-driven: `.github/workflows/release.yml` runs on `v*` tags and uploads `md2pdf.sh` plus `install.sh`.
- `generate_changelog.sh <tag>` groups commits by subject prefixes `feat`, `fix`, `refactor`, `docs`, and `ci`; keep release-facing commit subjects compatible if changelog output matters.

## Repo Hygiene
- Do not commit generated `*.pdf` files or temporary Markdown fixtures matching `test*.md`/`sample*.md`; `.gitignore` intentionally excludes them.
- If changing the CLI version, note that `md2pdf.sh` has its own `VERSION` and `install.sh` has a separate installer `VERSION`.
