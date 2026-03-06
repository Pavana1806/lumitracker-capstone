#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PYTHONPATH="${ROOT_DIR}/src:${PYTHONPATH:-}"

mkdir -p \
  "${ROOT_DIR}/outputs/ws2/figures" \
  "${ROOT_DIR}/outputs/ws2/logs" \
  "${ROOT_DIR}/outputs/ws2/tables"

TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"
LOG_FILE="${ROOT_DIR}/outputs/ws2/logs/ws2_run_${TIMESTAMP}.log"

python -m ws2.asset_prioritization \
  --input-lux "${ROOT_DIR}/data/processed/workstream1_clean_lux.csv" \
  --streetlights "${ROOT_DIR}/data/raw/gis/City of Sugar Land Streetlight locations.xlsx" \
  --traffic-lights "${ROOT_DIR}/data/raw/gis/City of Sugar Land Traffic Roadway Lights locations.xlsx" \
  --avalon-pdf "${ROOT_DIR}/data/raw/gis/Avalon private street lights map.pdf" \
  --output-dir "${ROOT_DIR}/outputs/ws2" \
  --max-distance-ft 100 \
  --min-observations 20 \
  --asset-flag-threshold 0.30 \
  2>&1 | tee "${LOG_FILE}"

# Copy HTML to docs/ for GitHub Pages
mkdir -p "${ROOT_DIR}/docs"
cp "${ROOT_DIR}/outputs/ws2/figures/flagged_assets_map.html" "${ROOT_DIR}/docs/"