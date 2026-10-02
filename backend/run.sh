#!/usr/bin/env bash
# Run Backend A (default) or B: ./run.sh A | ./run.sh B
set -euo pipefail
cd "$(dirname "$0")"
ID="${1:-A}"
ID="$(echo "$ID" | tr '[:lower:]' '[:upper:]')"
if [[ "$ID" == "A" ]]; then
  export BACKEND_ID=A PORT=3001
elif [[ "$ID" == "B" ]]; then
  export BACKEND_ID=B PORT=3002
else
  echo "Usage: $0 [A|B]" >&2
  exit 1
fi
python3 -m venv .venv 2>/dev/null || true
# shellcheck disable=SC1091
source .venv/bin/activate
pip -q install -r requirements.txt
echo "Starting Backend ${BACKEND_ID} on 0.0.0.0:${PORT}"
exec python app.py
