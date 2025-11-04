#!/usr/bin/env bash
set -euo pipefail

mkdir -p frue_sync/logs
echo "Running flutter analyzer..." | tee frue_sync/logs/PHASE1_analyze.txt
flutter analyze | tee -a frue_sync/logs/PHASE1_analyze.txt

if ls -1 test 2>/dev/null | grep -q .; then
  echo -e "\nRunning flutter tests..." | tee -a frue_sync/logs/PHASE1_analyze.txt
  flutter test | tee -a frue_sync/logs/PHASE1_analyze.txt
else
  echo -e "\nNo tests/ folder found — skipping tests." | tee -a frue_sync/logs/PHASE1_analyze.txt
fi

echo -e "\nAnalyzer finished ✔" | tee -a frue_sync/logs/PHASE1_analyze.txt
