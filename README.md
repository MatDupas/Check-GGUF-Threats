## Presentation

Check-GGUF-Threats is a set of tools designed to analyze and identify potential threats within GGUF Large Language Models (LLMs). These tools help ensure the security and integrity of LLMs by detecting vulnerabilities or malicious components.

## Features

- Analyze GGUF LLM models for potential threats.
- Generate detailed reports on findings.
- Support for multiple platforms with both PowerShell and Shell scripts.

## Requirements

- **PowerShell** (for Windows users)
- **Bash** (for Unix/Linux users)
- Appropriate permissions to execute scripts on your system.

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/MatDupas/Check-GGUF-Threats.git

2. **usage**:
   In Bash
```bash
chmod +x ./check-gguf-threat.sh; ./check-gguf-threat.sh model.gguf
```

In Powershell:
```bash
.\check-gguf-threat.ps1 model.gguf
