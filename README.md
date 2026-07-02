# md2pdf

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

A lightweight command-line tool that converts Markdown files into beautifully styled PDFs with syntax highlighting and professional typography.

## Features

- **Beautiful Themes** - GitHub-style light theme and One Dark-style dark theme
- **Syntax Highlighting** - Full color-coded code blocks for 100+ languages
- **Table of Contents** - Optional auto-generated TOC with configurable depth
- **Readable Tables** - Table rows are kept together across page breaks where possible
- **Watch Mode** - Auto-regenerate PDF on file changes
- **Professional Typography** - Optimized fonts, spacing, and page layout
- **Zero Configuration** - Works out of the box with sensible defaults
- **Cross-Platform** - Works on Linux, macOS, and WSL

## Quick Start

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash
```

Then restart your shell or run:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### Basic Usage

```bash
# Convert to PDF (light theme)
md2pdf document.md

# Dark theme
md2pdf document.md --theme dark

# With table of contents
md2pdf document.md --toc

# Custom output path
md2pdf document.md -o ~/Documents/output.pdf

# Watch mode (auto-regenerate on changes)
md2pdf document.md --watch
```

## Installation

### Prerequisites

md2pdf requires **pandoc** and **weasyprint**. The installer will check for these and offer to install them.

| OS | Command |
|---|---|
| Arch Linux | `sudo pacman -S pandoc python-weasyprint` |
| Ubuntu/Debian | `sudo apt install pandoc weasyprint` |
| Fedora | `sudo dnf install pandoc weasyprint` |
| macOS | `brew install pandoc weasyprint` |

### Install Options

**Quick install (recommended):**
```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash
```

**Install without dependency prompts:**
```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash -s -- --no-deps
```

**Check dependencies only:**
```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash -s -- --check
```

**Uninstall:**
```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash -s -- --uninstall
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/SmilingBytes/md2pdf.git
cd md2pdf

# Make executable and add to path
chmod +x md2pdf.sh
ln -s "$(pwd)/md2pdf.sh" ~/.local/bin/md2pdf

# Or source it for function aliases
echo 'source /path/to/md2pdf.sh' >> ~/.bashrc
```

## Usage

```
md2pdf [OPTIONS] <input.md> [output.pdf]

OPTIONS:
    -t, --theme <THEME>    Theme: light (default) or dark
    -T, --toc              Include table of contents
    -d, --toc-depth <N>    TOC depth level (default: 3)
    -o, --output <FILE>    Output PDF file path
    -w, --watch            Watch file for changes and regenerate
    -q, --quiet            Suppress informational output
    -h, --help             Show help message
    -v, --version          Show version information
    --check-deps           Check if dependencies are installed
```

### Examples

```bash
# Basic conversion
md2pdf README.md

# Dark theme with TOC
md2pdf documentation.md --theme dark --toc

# Custom output location
md2pdf notes.md -o ~/Desktop/notes.pdf

# Watch mode for live editing
md2pdf report.md -w

# Quiet mode (only errors)
md2pdf document.md -q
```

### Convenience Aliases

When sourced, the script provides shorthand functions:

```bash
md2pdf_light document.md  # Same as: md2pdf document.md --theme light
md2pdf_dark document.md   # Same as: md2pdf document.md --theme dark
```

## Themes

### Light Theme
GitHub-inspired styling with:
- Clean white background
- Professional blue links
- Subtle code block highlighting
- Standard A4 margins

### Dark Theme
One Dark-inspired styling with:
- Full-page dark background (no white margins)
- Vibrant syntax highlighting
- Easy on the eyes for reading
- Perfect for printing on dark paper or screens

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/md2pdf.git
cd md2pdf

# Test locally
./md2pdf.sh test.md --theme dark

# Run with debug output
bash -x ./md2pdf.sh test.md
```

### Ideas for Contributions

- [ ] Additional themes (sepia, solarized, etc.)
- [ ] Custom CSS file support
- [ ] Page numbering options
- [ ] Header/footer customization
- [ ] Multiple file batch conversion
- [ ] Config file support (~/.md2pdfrc)

## Troubleshooting

### "Command not found: md2pdf"

Make sure `~/.local/bin` is in your PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "Missing dependencies"

Run the dependency check:
```bash
md2pdf --check-deps
```

### WeasyPrint warnings

Some harmless warnings from WeasyPrint are normal and suppressed by default. If you see actual errors, ensure your system fonts are properly configured.

### Watch mode not working

Install `inotify-tools` for efficient file watching:
```bash
# Arch Linux
sudo pacman -S inotify-tools

# Ubuntu/Debian
sudo apt install inotify-tools
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Pandoc](https://pandoc.org/) - Universal document converter
- [WeasyPrint](https://weasyprint.org/) - Visual rendering engine for PDF
- GitHub's styling for light theme inspiration
- Atom's One Dark for dark theme inspiration
