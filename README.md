# 🗑️ Claude Code Smart Uninstaller (Windows)

A smart, fully automated `.bat` script to completely remove **Claude Code CLI** from Windows — no manual steps required.

---

## ⚡ Features

- ✅ Auto-relaunches as Administrator
- ✅ Locates `claude.exe` wherever it's installed
- ✅ Tries npm, WinGet, and direct folder deletion
- ✅ Removes all known install locations
- ✅ Cleans leftover config/data folders
- ✅ Force-deletes if still found after all steps
- ✅ Confirms success at the end

---

## 🚀 Usage

1. Download [uninstall_claude_smart.bat](./uninstall_claude_smart.bat)
2. **Double-click** it — it will auto-request Admin rights
3. Done!

> No need to right-click → "Run as Administrator" — the script handles it automatically.

---

## 🧹 What It Removes

| Item | Path |
|------|------|
| Claude executable | `C:\Users\<you>\.local\bin\claude.exe` |
| npm global package | `%APPDATA%\npm\node_modules\@anthropic-ai\claude-code` |
| Config folder | `%USERPROFILE%\.claude` |
| Install folders | `%LOCALAPPDATA%\Programs\claude-code` |
| AppData folder | `%APPDATA%\claude-code` |

---

## 🖥️ Tested On

- Windows 11
- Claude Code installed via native installer (`.exe`)

---

## 📋 Requirements

- Windows 10 / 11
- Administrator access (auto-prompted)

---

## 🤝 Contributing

Found a new install location? Open an issue or PR!

---

## 📄 License

MIT — free to use, share, and modify.

---

> Made with ❤️ for the community. Inspired by a real uninstall struggle!
