# ML Chat — Shared Context & Project Report

## Updated Architecture (May 13, 2026)

### Files
- `index.html` — Single-file web app (inline CSS + JS, ~47KB)
- `transformers.js` — Transformers.js v2.17.2 ESM library (~1.7MB)
- `transformers.min.js` — Minified version (~900KB)
- `ort-wasm*.wasm` — ONNX Runtime WASM binaries (~38MB total)

### ML Pipeline
- **Model**: `Xenova/TinyLlama-1.1B-Chat-v1.0` (instruction-tuned, quantized)
- **Task**: `text-generation` with chat template (`apply_chat_template`)
- **Context**: System prompt + last 10 messages of conversation history
- **Streaming**: Token-by-token via `callback_function` in generation config
- **Max tokens**: 1024 (long, detailed responses)
- **Temperature**: 0.7
- **Offline**: All library files and WASM binaries are local; models cache in IndexedDB after first download

### Architecture Fixes from Original
1. **CDN → Local**: All imports use `./transformers.js` instead of remote CDN
2. **DistilGPT-2 → TinyLlama Chat**: Proper instruction-tuned model with chat templates
3. **No history → Full history**: Conversation context passed to model via `apply_chat_template`
4. **No streaming → Real-time streaming**: Tokens appear as they're generated
5. **120 tokens → 1024 tokens**: Long, detailed responses possible
6. **3 parallel models → Single focused pipeline**: Removed sentiment/intent overhead
7. **Weak fallbacks → Model-generated responses**: Actual ML inference, not rule-based
8. **Worker Blob + CDN → Worker Blob + local import**: With main-thread fallback for `file://` protocol

### Web Worker Strategy
- Primary: Module Worker (Blob URL) importing local `transformers.js`
- Fallback: Main-thread inference if Worker fails (e.g., on `file://` protocol)
- Stop button: Signals worker to stop streaming; saves partial response

### Known Limitations
- First load downloads ~600MB of model weights (cached in IndexedDB afterward)
- `file://` protocol may require a local HTTP server for full functionality (warning shown)
- TinyLlama 1.1B is a small model — responses are decent but not GPT-4 quality
- ONNX inference may briefly block UI on slower machines (mitigated by Worker)

### How to Run
```bash
# Recommended: serve via local HTTP server
python3 -m http.server 8080
# Then open http://localhost:8080

# Or open index.html directly (some features may be limited on file://)
```
