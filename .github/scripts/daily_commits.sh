#!/usr/bin/env bash
set -euo pipefail

# Determine number of commits: use $COMMITS if provided, otherwise random between 4 and 5
if [ -n "${COMMITS:-}" ]; then
  NUM_COMMITS="$COMMITS"
else
  NUM_COMMITS=$((RANDOM % 2 + 4))
fi

# Sleep jitter range in seconds
SLEEP_MIN=${SLEEP_MIN:-30}
SLEEP_MAX=${SLEEP_MAX:-900}

mkdir -p .github/scripts
for i in $(seq 1 "$NUM_COMMITS"); do
  TIMESTAMP=$(date -u +"%Y%m%d_%H%M%S")
  FILE="activity_${TIMESTAMP}_$i.log"
  echo "Automated commit $i at $(date -u +"%Y-%m-%dT%H:%M:%SZ")" > "$FILE"
  echo "Random note: run=${GITHUB_RUN_ID:-local}, job=${GITHUB_JOB:-local}, index=$i" >> "$FILE" || true

  git add "$FILE"
  if git diff --staged --quiet; then
    echo "No staged changes for $FILE"
  else
      git commit -m "chore: automated commit #$i ($TIMESTAMP)"
      if [ "${DRY_RUN:-0}" = "1" ]; then
        echo "DRY_RUN=1: skipping git push for $FILE"
      else
        git push origin HEAD || echo "Push failed"
      fi
  fi

  if [ "$i" -lt "$NUM_COMMITS" ]; then
    RANGE=$((SLEEP_MAX - SLEEP_MIN + 1))
    if [ "${DRY_RUN:-0}" = "1" ]; then
      SLEEP_SECONDS=0
    else
      SLEEP_SECONDS=$((RANDOM % RANGE + SLEEP_MIN))
    fi
    if [ "$SLEEP_SECONDS" -gt 0 ]; then
      sleep "$SLEEP_SECONDS"
    fi
  fi
done

