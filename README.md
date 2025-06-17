

# Path Traversal Scanner

A fast Bash-based directory traversal scanner with parallelism, URL encoding, and null byte bypass support.
Traverser is a lightweight, high-speed command-line scanner designed to detect path traversal vulnerabilities in web applications. Built in Bash for maximum portability, it features parallel execution, URL encoding, null byte injection, and file extension evasion.

## 🔥 Features

- Parallel execution with thread limit
- URL and payload encoding
- Null byte bypass support (`%00` + file extension)
- Auto-detects successful traversal via pattern matching (e.g., `root:`)

## 📦 Requirements

- Bash
- `curl`

## 🚀 Usage

```bash
chmod +x traversal_scanner.sh
./traversal_scanner.sh "http://example.com/page?file="
