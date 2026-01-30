# Markdown to PDF Converter

A shell script function that converts Markdown files into beautiful, polished PDFs with syntax highlighting and professional styling (inspired by GitHub and One Dark themes).

## Features

- **Beautiful Themes**: Support for professional Light (GitHub-style) and Dark (One Dark-style) modes.
- **Syntax Highlighting**: Full color-coded code blocks.
- **Table Support**: Clean, bordered tables with alternating row colors.
- **Professional Typography**: Optimized font sizes (9.5pt) and line heights (1.6).
- **Table of Contents**: Optional TOC support.
- **Hard Line Breaks**: Preserves single newlines from Markdown in the PDF output.
- **Dark Mode Perfection**: Full-page dark background (no white margins).

## Prerequisites

The script requires **Pandoc** and **WeasyPrint**.

### Arch Linux
```bash
sudo pacman -S pandoc python-weasyprint
```

### Ubuntu / Debian
```bash
sudo apt update
sudo apt install pandoc weasyprint
```

---

## Installation & Setup

### Quick Install
Run this single command to install and immediately enable `md2pdf` in your current shell (supports both Bash and Zsh):

```bash
curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash && source ~/."${SHELL##*/}"rc
```

---

## Usage

Once installed or sourced, use the command:

### Basic Conversion (Light Mode)
```bash
md2pdf document.md
```

### Dark Mode
```bash
md2pdf document.md dark
```

### With Table of Contents
```bash
# md2pdf <file> <mode> <toc_enabled>
md2pdf document.md light true
md2pdf document.md dark true
```

### Convenience Aliases
The script also provides these shorter aliases:
```bash
md2pdf_light document.md
md2pdf_dark document.md
```
