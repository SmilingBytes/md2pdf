#!/bin/bash

# md2pdf - Markdown to PDF converter with beautiful styling
# https://github.com/SmilingBytes/md2pdf
# License: MIT

VERSION="0.1.2"

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# CSS Themes
# ============================================================================

CSS_LIGHT='
@page {
    size: A4;
    margin: 2cm;
}
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    font-size: 9.5pt;
    line-height: 1.6;
    color: #24292f;
    max-width: 100%;
    margin: 0;
    padding: 0;
}
h1, h2, h3, h4, h5, h6 {
    color: #1f2328;
    margin-top: 1.3em;
    margin-bottom: 0.4em;
    font-weight: 600;
}
h1 { font-size: 1.7em; border-bottom: 1px solid #d8dee4; padding-bottom: 0.25em; }
h1:first-of-type:empty, .title { display: none; }
h2 { font-size: 1.35em; border-bottom: 1px solid #d8dee4; padding-bottom: 0.2em; }
h3 { font-size: 1.15em; }
h4 { font-size: 1em; }
a { color: #0969da; text-decoration: none; }
code {
    font-family: "SF Mono", "Fira Code", Consolas, monospace;
    font-size: 0.88em;
    background: #f6f8fa;
    padding: 2px 5px;
    border-radius: 4px;
    color: #0550ae;
}
pre {
    background: #f6f8fa;
    border: 1px solid #d0d7de;
    border-radius: 6px;
    padding: 12px;
    overflow-x: auto;
    margin: 0.8em 0;
}
pre code {
    background: none;
    padding: 0;
    font-size: 0.82em;
    line-height: 1.45;
    color: #24292f;
}
.kw, .keyword { color: #cf222e; }
.dt, .type { color: #8250df; }
.st, .string { color: #0a3069; }
.co, .comment { color: #6e7781; font-style: italic; }
.fu, .function { color: #8250df; }
.op { color: #cf222e; }
.cn, .constant { color: #0550ae; }
.dv, .number { color: #0550ae; }
blockquote {
    border-left: 3px solid #d0d7de;
    margin: 0.8em 0;
    padding: 0.4em 1em;
    background: #f6f8fa;
    color: #57606a;
}
table {
    border-collapse: separate;
    border-spacing: 0;
    width: 100%;
    margin: 0.8em 0;
    font-size: 0.92em;
}
thead {
    display: table-header-group;
}
tr {
    break-inside: avoid-page;
    page-break-inside: avoid;
}
th, td {
    border-color: #d0d7de;
    border-style: solid;
    border-width: 0 1px 1px 0;
    break-inside: avoid-page;
    page-break-inside: avoid;
    padding: 7px 11px;
    text-align: left;
}
tr:first-child > th,
tr:first-child > td {
    border-top-width: 1px;
}
tr > th:first-child,
tr > td:first-child {
    border-left-width: 1px;
}
th {
    background: #f6f8fa;
    color: #24292f;
    font-weight: 600;
}
tr:nth-child(even) { background: #f6f8fa; }
ul, ol { padding-left: 1.6em; }
li { margin: 0.2em 0; }
hr { border: none; border-top: 1px solid #d8dee4; margin: 1.2em 0; }
p { margin: 0.6em 0; }
'

CSS_DARK='
@page {
    size: A4;
    margin: 0;
    background: #0d1117;
}
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    font-size: 9.5pt;
    line-height: 1.6;
    color: #c9d1d9;
    background: #0d1117;
    margin: 0;
    padding: 45px 55px;
}
h1, h2, h3, h4, h5, h6 {
    color: #e6edf3;
    margin-top: 1.2em;
    margin-bottom: 0.4em;
    font-weight: 600;
}
h1:first-child, h2:first-child, h3:first-child { margin-top: 0; }
h1 { font-size: 1.7em; border-bottom: 1px solid #30363d; padding-bottom: 0.25em; }
h1:first-of-type:empty, .title { display: none; }
h2 { font-size: 1.35em; border-bottom: 1px solid #30363d; padding-bottom: 0.2em; }
h3 { font-size: 1.15em; }
h4 { font-size: 1em; }
a { color: #58a6ff; text-decoration: none; }
code {
    font-family: "SF Mono", "Fira Code", Consolas, monospace;
    font-size: 0.88em;
    background: #161b22;
    padding: 2px 5px;
    border-radius: 4px;
    color: #e6edf3;
}
pre {
    background: #0d1117;
    border: 1px solid #30363d;
    border-radius: 6px;
    padding: 14px;
    overflow-x: auto;
    margin: 0.8em 0;
}
pre code {
    background: none;
    padding: 0;
    font-size: 0.85em;
    line-height: 1.5;
    color: #c9d1d9;
}
.kw, .keyword { color: #ff7b72; font-weight: 500; }
.dt, .type { color: #79c0ff; }
.st, .string { color: #a5d6ff; }
.co, .comment { color: #8b949e; font-style: italic; }
.fu, .function { color: #d2a8ff; }
.op { color: #ff7b72; }
.cn, .constant { color: #79c0ff; }
.dv, .number { color: #79c0ff; }
.at { color: #ffa657; }
.va { color: #ffa657; }
.cf { color: #ff7b72; }
.bu { color: #ffa657; }
blockquote {
    border-left: 3px solid #30363d;
    margin: 0.8em 0;
    padding: 0.4em 1em;
    background: #161b22;
    color: #8b949e;
}
table {
    border-collapse: separate;
    border-spacing: 0;
    width: 100%;
    margin: 0.8em 0;
    font-size: 0.92em;
}
thead {
    display: table-header-group;
}
tr {
    break-inside: avoid-page;
    page-break-inside: avoid;
}
th, td {
    border-color: #30363d;
    border-style: solid;
    border-width: 0 1px 1px 0;
    break-inside: avoid-page;
    page-break-inside: avoid;
    padding: 7px 11px;
    text-align: left;
}
tr:first-child > th,
tr:first-child > td {
    border-top-width: 1px;
}
tr > th:first-child,
tr > td:first-child {
    border-left-width: 1px;
}
th {
    background: #161b22;
    color: #c9d1d9;
    font-weight: 600;
}
tr:nth-child(even) { background: #0d1117; }
tr:nth-child(odd) { background: #161b22; }
ul, ol { padding-left: 1.6em; }
li { margin: 0.2em 0; }
hr { border: none; border-top: 1px solid #30363d; margin: 1.2em 0; }
p { margin: 0.6em 0; }
'

# ============================================================================
# Helper Functions
# ============================================================================

show_help() {
    cat << 'EOF'
md2pdf - Convert Markdown to beautifully styled PDF

USAGE:
    md2pdf [OPTIONS] <input.md> [output.pdf]

OPTIONS:
    -t, --theme <THEME>    Theme: light (default) or dark
    -T, --toc              Include table of contents
    -d, --toc-depth <N>    TOC depth level (default: 3)
    -o, --output <FILE>    Output PDF file path
    -w, --watch            Watch file for changes and regenerate
    -q, --quiet            Suppress informational output
    -h, --help             Show this help message
    -v, --version          Show version information
    --check-deps           Check if dependencies are installed

EXAMPLES:
    md2pdf document.md                    # Light theme, same directory
    md2pdf document.md -t dark            # Dark theme
    md2pdf document.md -T                 # With table of contents
    md2pdf document.md -o output.pdf      # Custom output path
    md2pdf document.md -t dark -T         # Dark theme with TOC
    md2pdf README.md -w                   # Watch mode

THEMES:
    light    GitHub-style light theme (default)
    dark     One Dark-style dark theme with full-page background

For more information, visit: https://github.com/SmilingBytes/md2pdf
EOF
}

show_version() {
    echo "md2pdf version $VERSION"
    echo "https://github.com/SmilingBytes/md2pdf"
}

check_dependencies() {
    local missing=()
    
    if ! command -v pandoc &>/dev/null; then
        missing+=("pandoc")
    fi
    
    if ! command -v weasyprint &>/dev/null; then
        missing+=("weasyprint")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}Error: Missing required dependencies: ${missing[*]}${NC}" >&2
        echo "" >&2
        echo "Install them using:" >&2
        echo "  Arch Linux:    sudo pacman -S pandoc python-weasyprint" >&2
        echo "  Ubuntu/Debian: sudo apt install pandoc weasyprint" >&2
        echo "  macOS:         brew install pandoc weasyprint" >&2
        echo "" >&2
        echo "Or run the installer: curl -fsSL https://raw.githubusercontent.com/SmilingBytes/md2pdf/main/install.sh | bash" >&2
        return 1
    fi
    
    if [[ "$1" == "--verbose" ]]; then
        echo -e "${GREEN}All dependencies are installed${NC}"
        echo "  pandoc:     $(pandoc --version | head -1)"
        echo "  weasyprint: $(weasyprint --version 2>&1 | head -1)"
    fi
    
    return 0
}

# ============================================================================
# Main Conversion Function
# ============================================================================

md2pdf() {
    local input_file=""
    local output_file=""
    local theme="light"
    local toc=false
    local toc_depth=3
    local watch=false
    local quiet=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                return 0
                ;;
            -v|--version)
                show_version
                return 0
                ;;
            --check-deps)
                check_dependencies --verbose
                return $?
                ;;
            -t|--theme)
                theme="$2"
                shift 2
                ;;
            -T|--toc)
                toc=true
                shift
                ;;
            -d|--toc-depth)
                toc_depth="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -w|--watch)
                watch=true
                shift
                ;;
            -q|--quiet)
                quiet=true
                shift
                ;;
            -*)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                echo "Run 'md2pdf --help' for usage information" >&2
                return 1
                ;;
            *)
                if [[ -z "$input_file" ]]; then
                    input_file="$1"
                elif [[ -z "$output_file" ]]; then
                    output_file="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Validate input
    if [[ -z "$input_file" ]]; then
        echo -e "${RED}Error: No input file specified${NC}" >&2
        echo "Run 'md2pdf --help' for usage information" >&2
        return 1
    fi
    
    if [[ ! -f "$input_file" ]]; then
        echo -e "${RED}Error: File not found: $input_file${NC}" >&2
        return 1
    fi
    
    # Check dependencies
    if ! check_dependencies; then
        return 1
    fi
    
    # Validate theme
    if [[ "$theme" != "light" && "$theme" != "dark" ]]; then
        echo -e "${RED}Error: Invalid theme '$theme'. Use 'light' or 'dark'${NC}" >&2
        return 1
    fi
    
    # Determine output file
    if [[ -z "$output_file" ]]; then
        local dir=$(dirname "$input_file")
        local basename=$(basename "$input_file" .md)
        basename=$(basename "$basename" .markdown)
        output_file="${dir}/${basename}.pdf"
    fi
    
    # Select CSS
    local css
    if [[ "$theme" == "dark" ]]; then
        css="$CSS_DARK"
    else
        css="$CSS_LIGHT"
    fi
    
    # Create temporary CSS file
    local css_file=$(mktemp --suffix=.css)
    echo "$css" > "$css_file"
    trap "rm -f '$css_file'" EXIT
    
    # Build pandoc options
    local toc_opts=""
    if [[ "$toc" == true ]]; then
        toc_opts="--toc --toc-depth=$toc_depth"
    fi
    
    # Convert function
    do_convert() {
        if [[ "$quiet" != true ]]; then
            echo -e "${BLUE}Converting:${NC} $input_file"
            echo -e "${BLUE}Theme:${NC} $theme | ${BLUE}TOC:${NC} $toc"
        fi
        
        # Run pandoc and filter warnings, but capture the exit status of pandoc
        pandoc "$input_file" \
            -f markdown+hard_line_breaks \
            -o "$output_file" \
            --pdf-engine=weasyprint \
            --css="$css_file" \
            --highlight-style=pygments \
            --metadata title=" " \
            $toc_opts \
            -s 2>&1 | (grep -v "WARNING:" || true) >&2
        
        local status=${PIPESTATUS[0]}
        
        if [[ $status -eq 0 && -f "$output_file" ]]; then
            if [[ "$quiet" != true ]]; then
                echo -e "${GREEN}Success:${NC} $output_file"
            fi
            return 0
        fi
        
        echo -e "${RED}Error: Conversion failed (Exit code: $status)${NC}" >&2
        return 1
    }
    
    # Watch mode
    if [[ "$watch" == true ]]; then
        if ! command -v inotifywait &>/dev/null; then
            echo -e "${YELLOW}Warning: inotifywait not found. Install inotify-tools for watch mode.${NC}" >&2
            echo "Falling back to polling every 2 seconds..." >&2
            
            local last_mod=""
            while true; do
                local current_mod=$(stat -c %Y "$input_file" 2>/dev/null)
                if [[ "$current_mod" != "$last_mod" ]]; then
                    last_mod="$current_mod"
                    do_convert
                fi
                sleep 2
            done
        else
            echo -e "${BLUE}Watching for changes:${NC} $input_file"
            echo "Press Ctrl+C to stop"
            do_convert
            while inotifywait -q -e modify "$input_file"; do
                do_convert
            done
        fi
    else
        do_convert
    fi
}

# ============================================================================
# Convenience Aliases
# ============================================================================

md2pdf_light() {
    md2pdf --theme light "$@"
}

md2pdf_dark() {
    md2pdf --theme dark "$@"
}

# ============================================================================
# Script Execution
# ============================================================================

# If script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    md2pdf "$@"
fi
