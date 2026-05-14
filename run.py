#!/usr/bin/env python3
"""Flask server for running ML Chat locally.
   
   Usage: python run.py
   Then open http://localhost:5000 in your browser.
"""
from flask import Flask, send_from_directory
import os

app = Flask(__name__, static_folder='.')

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory('.', path)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5931))
    print(f"🚀 ML Chat running at http://localhost:{port}")
    print("   Press Ctrl+C to stop.")
    app.run(host='0.0.0.0', port=port, debug=False)
