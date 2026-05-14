# ML Chat — Shared Context & Architecture

## Project Overview

**ML Chat** is a fully offline, browser-based AI assistant powered by a pure JavaScript NLP engine. All processing happens locally — no data leaves the device, no external APIs are called, and no CDN dependencies are required.

---

## Architecture

### File Structure

```
mlchat/
├── index.html                          # Main application shell
├── css/                                # Modular stylesheets
│   ├── variables.css                   # Design tokens
│   ├── base.css                        # Reset & base styles
│   ├── layout.css                      # App shell, sidebar, header
│   ├── components.css                  # Shared components (toasts, badges)
│   ├── chat.css                        # Messages, bubbles, input
│   ├── animations.css                  # Keyframes & transitions
│   └── responsive.css                  # Mobile breakpoints
├── js/
│   ├── ml/                             # ML Engine (pure JS NLP)
│   │   ├── tokenizer.js                # Text tokenization & stemming
│   │   ├── sentiment.js                # AFINN-based sentiment with negation & intensifiers
│   │   ├── intent.js                   # Hierarchical intent classification
│   │   ├── ner.js                      # Named entity recognition
│   │   ├── tfidf.js                    # TF-IDF for keywords & summarization
│   │   ├── context.js                  # Conversation memory & topic tracking
│   │   ├── response-generator.js       # Context-aware response generation
│   │   └── engine.js                   # ML orchestrator
│   ├── app/                            # Application layer
│   │   ├── state.js                    # App state management
│   │   ├── storage.js                  # localStorage persistence
│   │   ├── dom.js                      # DOM references
│   │   ├── renderer.js                 # UI rendering functions
│   │   ├── events.js                   # Event handlers
│   │   └── main.js                     # App bootstrap
│   └── shared/
│       └── utils.js                    # Shared utilities
├── transformers.js                     # Local Transformers.js (optional)
├── transformers.min.js                 # Minified version
├── ort-wasm*.wasm                      # ONNX Runtime WASM binaries
└── shared-context.md                   # This file
```

---

## ML Pipeline

### 1. Tokenization (`tokenizer.js`)
- Whitespace + regex tokenization
- Basic stemming (removes common suffixes)
- Stopword filtering
- N-gram generation (bigrams, trigrams)

### 2. Sentiment Analysis (`sentiment.js`)
- **AFINN lexicon** with ~1,500+ words covering emotional, social, and domain-specific vocabulary
- **Negation handling** — flips sentiment when negators (not, never, no, etc.) precede sentiment words
- **Intensifier handling** — boosts/dampens scores (very, extremely, barely, etc.)
- Returns: label (POSITIVE/NEGATIVE/NEUTRAL), score, confidence

### 3. Intent Classification (`intent.js`)
- **Multi-layer hierarchical classification**
- Primary intents: `greeting`, `farewell`, `question`, `request`, `emotional`, `creative`, `technical`, `statement`
- Sub-intents for emotional: `stress`, `sadness`, `anger`, `fear`, `happiness`, `love`
- Scoring based on: regex patterns, keyword matching, bigram matching
- Confidence score for each classification

### 4. Named Entity Recognition (`ner.js`)
- Pattern-based extraction: emails, URLs, dates, times, phone numbers, money
- Title-based person detection ("Dr. Smith")
- Common name recognition
- Organization & location detection via keyword indicators

### 5. TF-IDF (`tfidf.js`)
- Term frequency-inverse document frequency engine
- Keyword extraction from any text
- Extractive summarization (sentence scoring)
- Cosine similarity between texts

### 6. Context & Memory (`context.js`)
- **Sliding window conversation history** (last 20 turns)
- **Entity memory** — remembers people, places, topics across conversation
- **Topic chain tracking** — maintains conversation flow
- **User name detection** — personalizes greetings
- **Mood tracking** — follows sentiment trends
- Serializable for persistence

### 7. Response Generation (`response-generator.js`)
- **Intent-specific template system** with variable substitution
- **Knowledge base** — embedded facts on quantum computing, JavaScript, Python, AI/ML, space, philosophy, health, history, art
- **Creative generation** — haikus, poems, jokes, short stories
- **Emotional intelligence** — tailored responses for stress, sadness, anger, fear, happiness, love
- **Context awareness** — uses conversation history, detected entities, and user name

---

## Design System

- **Color palette**: Dark navy/charcoal base (`#0b0c0f`) with teal accent (`#2dd4bf`)
- **Typography**: System font stack with Inter as preferred
- **Spacing**: 4px base grid
- **No "AI slop"**: No pulsing green dots, no generic purple gradients, no buzzword badges
- **Professional feel**: Inspired by Claude.ai and ChatGPT but with refined uniqueness

---

## How to Use

1. Open `index.html` in any modern browser (Chrome, Firefox, Edge, Safari)
2. The NLP engine initializes instantly (no model downloads)
3. Start chatting — all processing is 100% local
4. Conversations are persisted to localStorage

---

## Technical Decisions

| Decision | Rationale |
|----------|-----------|
| Pure JS NLP engine | Zero external dependencies, works offline, instant load |
| Modular ES modules | Clean separation of concerns, maintainable, testable |
| Separate CSS files | Design system isolation, easier theming |
| AFINN + rules sentiment | Fast, interpretable, works without training data |
| Template-based generation | Controllable, consistent, no hallucination risk |
| localStorage persistence | Simple, offline-first, no server needed |

---

## Optional: Transformers.js Integration

The project includes `transformers.js` and ONNX WASM files locally for optional advanced NLP capabilities. To enable:
1. Download model weights to a `models/` directory
2. Update `engine.js` to load Transformers.js pipelines
3. The pure JS engine remains as a fallback

---

## Known Limitations

- First-generation responses are template-based, not generative like GPT-4
- NER is pattern-based, not learned
- Intent classification uses English keyword lists
- No image or voice input support

## Future Enhancements

- Add more knowledge base topics
- Implement conversation summarization with TF-IDF
- Add typing speed adaptation
- Expand sentiment dictionary for more languages
- Add WebLLM integration for true generative responses
