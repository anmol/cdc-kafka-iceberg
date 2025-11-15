#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# 🧹 Reusable Reset Script for Iceberg Streaming Pipeline
# ------------------------------------------------------------
# Usage:
#   ./reset_streaming_job.sh \
#      --catalog glue_catalog \
#      [--delete-checkpoint --checkpoint s3://bucket/checkpoints/public_sales_agg_2min] \
#      [--drop-source --source-db cdc_apg --source-tables public_orders,public_products,public_countries] \
#      [--dry-run]
#
# ------------------------------------------------------------

DRY_RUN=false
DELETE_CHECKPOINT=false
DROP_SOURCE=false
SOURCE_DB=""
SOURCE_TABLES=""
SOURCE_WAREHOUSE_PREFIX=""   # auto-detected unless explicitly given

# ------------------------------------------------------------
# Argument parsing
# ------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case $1 in
    --catalog)           CATALOG="$2"; shift 2 ;;
    --delete-checkpoint) DELETE_CHECKPOINT=true; shift ;;
    --checkpoint)        CHECKPOINT_DIR="$2"; shift 2 ;;
    --drop-source)       DROP_SOURCE=true; shift ;;
    --source-db)         SOURCE_DB="$2"; shift 2 ;;
    --source-tables)     SOURCE_TABLES="$2"; shift 2 ;;
    --dry-run)           DRY_RUN=true; shift ;;
    *) echo "❌ Unknown argument: $1"; exit 1 ;;
  esac
done

[[ -z "${CATALOG:-}" ]] && {
  echo "Usage: $0 --catalog <catalog> [--delete-checkpoint --checkpoint <s3://...>][--drop-source --source-db <db> --source-tables t1,t2] [--dry-run]"
  exit 1
}

echo "🧹 Resetting streaming pipeline..."
echo "   Catalog:        $CATALOG"
[[ -n "${CHECKPOINT_DIR:-}" ]] && echo "   Checkpoint:     $CHECKPOINT_DIR"
echo "   Drop source:    $DROP_SOURCE"
[[ -n "$SOURCE_DB" ]] && echo "   Source DB:      $SOURCE_DB"
[[ -n "$SOURCE_TABLES" ]] && echo "   Source Tables:  $SOURCE_TABLES"
echo "   Dry run:        $DRY_RUN"
echo

# ------------------------------------------------------------
# Helper runner
# ------------------------------------------------------------
run_cmd() {
  if $DRY_RUN; then
    echo "[DRY RUN] $1"
  else
    echo "➡️  $1"
    eval "$1"
  fi
}

# ------------------------------------------------------------
# 2️⃣ Delete checkpoint directory
# ------------------------------------------------------------
if $DELETE_CHECKPOINT; then
    if [[ -z "$CHECKPOINT_DIR" ]]; then
      echo "! Checkpoint directory not provided; skipping checkpoint delete."
    else
      echo "🔥 Deleting checkpoint directory: $CHECKPOINT_DIR"
      run_cmd "aws s3 rm --recursive $CHECKPOINT_DIR || true"
    fi
fi

# ------------------------------------------------------------
# 4️⃣ Drop source tables + delete their S3 data (corrected order)
# ------------------------------------------------------------
if $DROP_SOURCE; then
  if [[ -z "$SOURCE_DB" || -z "$SOURCE_TABLES" ]]; then
    echo "⚠️  Source DB or tables not provided; skipping source cleanup."
  else
    echo "🔥 Dropping source tables and their S3 data..."

    IFS=',' read -ra TABLE_LIST <<< "$SOURCE_TABLES"

    for TBL in "${TABLE_LIST[@]}"; do
      CLEAN_TBL=$(echo "$TBL" | xargs)
      FULL_SRC_TABLE="${CATALOG}.${SOURCE_DB}.${CLEAN_TBL}"

      echo "   📦 Fetching S3 location for: $FULL_SRC_TABLE..."
      LOCATION=$(aws glue get-table \
                  --database-name "$SOURCE_DB" \
                  --name "$CLEAN_TBL" \
                  --query 'Table.StorageDescriptor.Location' \
                  --output text 2>/dev/null || echo "")

      if [[ "$LOCATION" == "None" || -z "$LOCATION" ]]; then
        echo "   ⚠️  No S3 location found (table might not exist)."
      else
        echo "   🗑️  Will delete S3 path: $LOCATION"
      fi

      echo "   🧨 Dropping Glue table: $FULL_SRC_TABLE"
      run_cmd "aws glue delete-table --database-name $SOURCE_DB --name $CLEAN_TBL || true"

      if [[ -n "$LOCATION" && "$LOCATION" != "None" ]]; then
        echo "   🪣 Removing S3 data for source table at: $LOCATION"
        run_cmd "aws s3 rm --recursive \"$LOCATION\" || true"
      fi

    done
  fi
else
  echo "ℹ️  Not dropping source tables (use --drop-source)."
fi

echo
echo "✅ Reset complete. Next job run will start in bootstrap mode."
