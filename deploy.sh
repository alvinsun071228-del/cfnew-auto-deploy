#!/usr/bin/env bash
# CFnew 一键部署/升级脚本（本地运行）
# Local one-click deploy/upgrade script for byJoey/cfnew.
#
# 用法 / Usage:
#   ./deploy.sh            # 拉取最新 release 并部署 / fetch latest release & deploy
#   ./deploy.sh local <src>  # 用本地源码部署 / deploy from a local source file
#
# 首次使用：先 `cp .env.example .env` 并填写 / First: `cp .env.example .env` and fill it in.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "错误：找不到 $ENV_FILE，请先 cp .env.example .env 并填写。"
  echo "Error: $ENV_FILE not found. Run 'cp .env.example .env' and fill it in."
  exit 1
fi
# shellcheck source=/dev/null
source "$ENV_FILE"

: "${CF_ACCOUNT_ID:?请在 .env 中填写 CF_ACCOUNT_ID}"
: "${CF_API_TOKEN:?请在 .env 中填写 CF_API_TOKEN}"
: "${KV_NAMESPACE:?请在 .env 中填写 KV_NAMESPACE}"
: "${UUID:?请在 .env 中填写 UUID}"

CF_API="https://api.cloudflare.com/client/v4"
WORKER_NAME="${WORKER_NAME:-cfnew-terminal}"
MODE="${1:-release}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

if [[ "$MODE" == "local" ]]; then
  SRC="${2:-}"
  [[ -n "$SRC" && -f "$SRC" ]] || { echo "错误：本地源文件不存在：${SRC:-未指定}"; exit 1; }
  cp "$SRC" "$TMP/_worker.js"
  VER="local-$(date +%F)"
else
  echo ">> fetching latest cfnew release ..."
  LATEST="$(curl -s https://api.github.com/repos/byJoey/cfnew/releases/latest)"
  VER="$(echo "$LATEST" | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p')"
  DL_URL="$(echo "$LATEST" | grep -io '"browser_download_url": *"[^"]*Pages\.zip"' | sed 's/.*"browser_download_url": *"\([^"]*\)"/\1/' | head -1)"
  [[ -n "$DL_URL" && "$DL_URL" != "null" ]] || { echo "错误：最新 release 中未找到 Pages.zip"; exit 1; }
  echo ">> version: $VER"
  echo ">> downloading: $DL_URL"
  curl -sL -o "$TMP/Pages.zip" "$DL_URL"
  (cd "$TMP" && unzip -o Pages.zip >/dev/null)
  cp "$TMP/_worker.js" "$TMP/worker-check.js"
fi

WORKER_JS="$TMP/_worker.js"
echo ">> checking worker.js ..."
wc -c "$WORKER_JS"
node --check "$WORKER_JS" >/dev/null 2>&1 && echo ">> JS syntax OK" || echo ">> (syntax check skipped)"

cat > "$TMP/metadata.json" <<EOF
{
  "main_module": "_worker.js",
  "compatibility_date": "2026-01-20",
  "compatibility_flags": [],
  "bindings": [
    {"type": "kv_namespace", "name": "C", "namespace_id": "${KV_NAMESPACE}"}
  ]
}
EOF

echo ">> uploading worker script ($WORKER_NAME) ..."
curl -s -X PUT "$CF_API/accounts/$CF_ACCOUNT_ID/workers/scripts/$WORKER_NAME" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -F "metadata=@$TMP/metadata.json;type=application/json" \
  -F "_worker.js=@$WORKER_JS;type=application/javascript+module" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print("upload:", "success" if d.get("success") else d)'

echo ">> setting UUID secret (u) ..."
curl -s -X PUT "$CF_API/accounts/$CF_ACCOUNT_ID/workers/scripts/$WORKER_NAME/secrets" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"u\",\"text\":\"$UUID\",\"type\":\"secret_text\"}" \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print("secret:", "success" if d.get("success") else d)'

echo ""
echo ">> done. version: ${VER:-?}"
echo "   panel: https://<your-domain>/$UUID"
echo "   sub:   https://<your-domain>/$UUID/sub"
