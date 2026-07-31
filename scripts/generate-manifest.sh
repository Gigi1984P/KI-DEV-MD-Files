#!/bin/bash
# generate-manifest.sh — Erstellt ein aktuelles MANIFEST.md für AI-EKOS

cd "$(dirname "$0")/.."

EKOS_ROOT="workspace/AI-EKOS"
OUTPUT="$EKOS_ROOT/MANIFEST.md"

total_files=$(find "$EKOS_ROOT" -name '*.md' | wc -l)
total_dirs=$(find "$EKOS_ROOT" -type d | wc -l)
last_update=$(date +%Y-%m-%d)

echo "# AI-EKOS Manifest" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## Repository Statistics" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Metric | Value |" >> "$OUTPUT"
echo "|--------|-------|" >> "$OUTPUT"
echo "| Total Files | $total_files |" >> "$OUTPUT"
echo "| Total Directories | $total_dirs |" >> "$OUTPUT"
echo "| Last Updated | $last_update |" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## Files by Category" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Category | Count |" >> "$OUTPUT"
echo "|----------|-------|" >> "$OUTPUT"

for dir in "$EKOS_ROOT"/0*; do
    if [ -d "$dir" ]; then
        category=$(basename "$dir")
        count=$(find "$dir" -name '*.md' | wc -l)
        echo "| $category | $count |" >> "$OUTPUT"
    fi
done

echo "" >> "$OUTPUT"
echo "## Top-Level Files" >> "$OUTPUT"
echo "" >> "$OUTPUT"
for f in "$EKOS_ROOT"/*.md; do
    if [ -f "$f" ]; then
        echo "- $(basename "$f")" >> "$OUTPUT"
    fi
done

echo "" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "*Generiert von scripts/generate-manifest.sh am $last_update*" >> "$OUTPUT"

echo "MANIFEST.md aktualisiert: $total_files Dateien, $total_dirs Verzeichnisse"
