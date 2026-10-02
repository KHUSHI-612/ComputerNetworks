#!/usr/bin/env python3
"""Minimal REST backend for CN Private Network Service Platform.

Bind to 0.0.0.0 so other Macs on the LAN can reach this process.
Backend A → port 3001, Backend B → port 3002 (set via BACKEND_ID / PORT).
"""

from __future__ import annotations

import hashlib
import os
from datetime import datetime, timezone

from flask import Flask, jsonify, make_response, request

BACKEND_ID = os.environ.get("BACKEND_ID", "A").upper()
PORT = int(os.environ.get("PORT", "3001" if BACKEND_ID == "A" else "3002"))

app = Flask(__name__)


def _etag_for(body: bytes) -> str:
    return '"' + hashlib.sha256(body).hexdigest()[:16] + '"'


@app.after_request
def add_backend_header(resp):
    resp.headers["X-Backend"] = BACKEND_ID
    resp.headers["Cache-Control"] = "public, max-age=30"
    return resp


@app.get("/")
def root():
    payload = {
        "service": "cn-private-network",
        "backend": BACKEND_ID,
        "path": "/",
        "ts": datetime.now(timezone.utc).isoformat(),
    }
    return jsonify(payload)


@app.get("/health")
def health():
    return jsonify({"ok": True, "backend": BACKEND_ID})


@app.get("/api/info")
def api_info():
    payload = {
        "backend": BACKEND_ID,
        "host_header": request.headers.get("Host"),
        "x_forwarded_for": request.headers.get("X-Forwarded-For"),
        "message": f"Hello from Backend {BACKEND_ID}",
    }
    body = jsonify(payload).get_data()
    etag = _etag_for(body)
    if request.headers.get("If-None-Match") == etag:
        resp = make_response("", 304)
        resp.headers["ETag"] = etag
        return resp
    resp = make_response(body)
    resp.headers["Content-Type"] = "application/json"
    resp.headers["ETag"] = etag
    return resp


if __name__ == "__main__":
    # LAN-accessible — do not bind 127.0.0.1 only
    app.run(host="0.0.0.0", port=PORT, debug=False)
