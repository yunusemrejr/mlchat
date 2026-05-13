# 🤖 ML Chat — Local AI Assistant

**ML Chat** is a fully client-side, browser-based AI chat assistant powered by [Transformers.js](https://huggingface.co/docs/transformers.js). All inference happens locally on your machine — no API keys, no cloud services, no data leaves your browser.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Transformers.js](https://img.shields.io/badge/Powered%20by-Transformers.js-6c63ff)](https://huggingface.co/docs/transformers.js)

---

## ✨ Features

- 🏠 **100% Local** — Runs entirely in your browser. Zero backend required.
- 🧠 **ML-Powered Pipeline** — 3-stage inference:
  - **Sentiment Analysis** — Detects emotional tone (DistilBERT)
  - **Intent Classification** — Zero-shot classification of user intent (BART-MNLI)
  - **Response Generation** — Generates replies with DistilGPT-2
- 🎨 **Polished Dark UI** — Inspired by Linear × Claude design systems
- 📱 **Responsive** — Works on desktop, tablet, and mobile
- 💾 **Persistent** — Conversations saved to LocalStorage
- 🔌 **Offline Capable** — Service Worker caches assets for offline use
- ⚡ **Web Worker** — ML inference offloaded to a background thread (no UI blocking)
- 🗂️ **Conversation History** — Sidebar with grouped history (Today / Earlier)

---

## 🚀 Quick Start

No build step. No dependencies to install.

### Option 1: Python Flask Server (Recommended)

```bash
git clone https://github.com/yunusemrejr/mlchat.git
cd mlchat
pip install flask    # First time only
python run.py        # Start the server
```

Then open **http://localhost:5000** in your browser.

### Option 2: Simple HTTP Server

```bash
git clone https://github.com/yunusemrejr/mlchat.git
cd mlchat

# Python
python -m http.server 8000

# Node.js
npx serve .
```

Then open **http://localhost:8000** in your browser.

### Option 3: VS Code Live Server

Right-click `index.html` → "Open with Live Server".

---

> **Note:** Due to browser security restrictions on ES modules, the app requires a local HTTP server. It cannot be opened directly via `file://`.

---

## 🧰 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Vanilla HTML/CSS/JS** | Zero framework overhead |
| **Transformers.js** | Browser ML inference (ONNX Runtime) |
| **Web Workers** | Non-blocking background inference |
| **IndexedDB** | Automatic model caching |
| **Service Worker** | Offline asset caching |
| **LocalStorage** | Conversation persistence |

---

## 🧠 Models Used

All models are downloaded automatically on first load and cached for future sessions:

| Model | Size (quantized) | Purpose |
|-------|------------------|---------|
| `Xenova/distilbert-base-uncased-finetuned-sst-2-english` | ~66 MB | Sentiment analysis |
| `Xenova/bart-base-mnli` | ~150 MB | Zero-shot intent classification |
| `Xenova/distilgpt2` | ~350 MB | Text generation |

**Total first-time download:** ~200–300 MB (cached after initial load).

---

## 📁 Project Structure

```
mlchat/
├── index.html          # Complete application (single file)
├── README.md           # This file
└── LICENSE             # MIT License
```

The entire app is intentionally a **single HTML file** — no bundler, no package manager, no deployment pipeline. Open it and it works.

---

## 🖥️ Browser Support

| Browser | Status |
|---------|--------|
| Chrome / Edge | ✅ Full support |
| Firefox | ✅ Full support |
| Safari | ⚠️ Limited (WebGL fallback) |

> **Note:** WebGPU accelerates inference where available; otherwise falls back to WASM/CPU.

---

## 🛡️ Privacy

- **No data is sent to any server.**
- **No analytics or telemetry.**
- **No cookies.**
- All models run locally in your browser via ONNX Runtime.

---

## 📝 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🙏 Credits

- [Hugging Face](https://huggingface.co) for Transformers.js and the pre-trained models
- [Xenova](https://github.com/xenova) for the optimized ONNX model ports

---

<p align="center">
  Built with 💜 for private, local AI.
</p>
