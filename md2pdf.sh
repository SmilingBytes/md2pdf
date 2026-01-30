#!/bin/bash

# Markdown to PDF converter with beautiful styling
# Dependencies: pandoc, python-weasyprint
# Install: sudo pacman -S pandoc python-weasyprint

md2pdf() {
    local input_file="$1"
    local mode="${2:-light}"  # light or dark
    local toc="${3:-false}"   # true or false
    
    if [[ -z "$input_file" ]]; then
        echo "Usage: md2pdf <markdown_file> [light|dark] [true|false]"
        echo "Examples:"
        echo "  md2pdf doc.md              # light mode, no TOC"
        echo "  md2pdf doc.md dark         # dark mode, no TOC"
        echo "  md2pdf doc.md light true   # light mode with TOC"
        echo "  md2pdf doc.md dark true    # dark mode with TOC"
        return 1
    fi
    
    if [[ ! -f "$input_file" ]]; then
        echo "Error: File '$input_file' not found"
        return 1
    fi
    
    local dir=$(dirname "$input_file")
    local basename=$(basename "$input_file" .md)
    basename=$(basename "$basename" .markdown)
    local output_file="${dir}/${basename}.pdf"
    
    echo "Converting ($mode mode, TOC: $toc): $input_file -> $output_file"
    
    # CSS styling
    local css
    if [[ "$mode" == "dark" ]]; then
        css='
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
    border-collapse: collapse;
    width: 100%;
    margin: 0.8em 0;
    font-size: 0.92em;
}
th, td {
    border: 1px solid #30363d;
    padding: 7px 11px;
    text-align: left;
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
    else
        css='
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
    border-collapse: collapse;
    width: 100%;
    margin: 0.8em 0;
    font-size: 0.92em;
}
th, td {
    border: 1px solid #d0d7de;
    padding: 7px 11px;
    text-align: left;
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
    fi
    
    local css_file=$(mktemp --suffix=.css)
    echo "$css" > "$css_file"
    
    local toc_opts=""
    if [[ "$toc" == "true" ]]; then
        toc_opts="--toc --toc-depth=3"
    fi
    
    pandoc "$input_file" \
        -f markdown+hard_line_breaks \
        -o "$output_file" \
        --pdf-engine=weasyprint \
        --css="$css_file" \
        --highlight-style=pygments \
        --metadata title=" " \
        $toc_opts \
        -s 2>&1 | grep -v "WARNING:" >&2
    
    rm -f "$css_file"
    
    if [[ -f "$output_file" ]]; then
        echo "Success: Created $output_file"
    else
        echo "Error: Conversion failed"
        return 1
    fi
}

# Convenience aliases
md2pdf_light() { md2pdf "$1" light "${2:-false}"; }
md2pdf_dark() { md2pdf "$1" dark "${2:-false}"; }

# If script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    md2pdf "$@"
fi
