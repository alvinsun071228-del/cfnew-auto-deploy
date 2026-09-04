# CFnew Auto-Deploy

[English](#english) · [中文](#chinese)

Automatically sync the latest [byJoey/cfnew](https://github.com/byJoey/cfnew) release and deploy it to your **Cloudflare Workers** — via GitHub Actions or a local one-click script. Bindings (KV namespace + UUID secret) are preserved across upgrades.

自动同步 [byJoey/cfnew](https://github.com/byJoey/cfnew) 最新版本并部署到你的 **Cloudflare Workers** —— 支持 GitHub Actions 自动升级或本地一键脚本，升级时保留 KV 绑定与 UUID 密钥。

---

<a id="english"></a>
## English

### What is this

[cfnew](https://github.com/byJoey/cfnew) ("终端 v3.0") is a multi-protocol proxy (VLESS / Trojan / xhttp) that runs on Cloudflare Workers, built on top of `cloudflare:sockets`. This repository automates the boring part: keeping your Worker always up to date with the latest release.

### Features

- ⏰ **Auto-upgrade** — checks `byJoey/cfnew` for a new release every 6 hours, downloads `Pages.zip`, and deploys `_worker.js` to your Worker automatically.
- 🔒 **Preserves config** — the KV namespace binding (`C`) and the `u` UUID secret are kept intact on every deploy.
- 🖥️ **Local script** — `deploy.sh` does the same thing from your own machine, no GitHub needed.
- 🧭 **Version tracking** — `VERSION.txt` records the deployed version, so no redundant deploys.

### Requirements

- A Cloudflare account with a Worker already created (or create one).
- A KV namespace bound to the Worker as variable `C` (optional but recommended for the graphical panel).
- A scoped API Token with at least:
  - `Workers Scripts: Write`
  - `Workers KV Storage: Write`
  (Account scope. Or use your Global API Key.)

### Setup — GitHub Actions (auto-upgrade)

1. **Use this template** (or fork) and clone it.
2. In your repo, go to **Settings → Secrets and variables → Actions → New repository secret**, and add:

   | Secret | Required | Description |
   | :--- | :--- | :--- |
   | `CF_ACCOUNT_ID` | ✅ | Your Cloudflare Account ID (dashboard right sidebar). |
   | `CF_API_TOKEN` | ✅ | A scoped API token (see Requirements) or Global API Key. |
   | `KV_NAMESPACE` | ✅ | The KV namespace ID bound to the Worker as `C`. |
   | `UUID` | ✅ | Your subscription UUID (used as the panel path and secret `u`). |
   | `WORKER_NAME` | ⬜ | Worker script name. Defaults to `cfnew-terminal`. |

3. Enable workflow write permission: **Settings → Actions → General → Workflow permissions → Read and write permissions**. (For forks this defaults to read-only.)
4. Run the workflow once manually: **Actions → "Sync & Deploy CFnew" → Run workflow**.

From now on it checks every 6 hours and redeploys only when a new version appears.

### Setup — Local script

```bash
cp .env.example .env     # then fill in the values
chmod +x deploy.sh
./deploy.sh              # fetch latest release & deploy
./deploy.sh local <file> # deploy from a local source file instead
```

### How the workflow works

```
schedule (every 6h) / manual
        │
        ▼
GET cfnew latest release  ── version unchanged? ──▶ skip
        │ version changed
        ▼
download Pages.zip → extract _worker.js
        │
        ▼
upload to Worker (module, keeps KV binding "C")
        │
        ▼
set secret "u" = UUID
        │
        ▼
commit VERSION.txt + _worker.js
```

### Security notes

- Never commit `.env` or any token to a public repo — it's already in `.gitignore`.
- Prefer a scoped API token over your Global API Key, and restrict it to your account.
- The auto-commit needs `contents: write`; it's declared in the workflow and must be enabled in repo settings.

---

<a id="chinese"></a>
## 中文

### 这是什么

[cfnew](https://github.com/byJoey/cfnew)（「终端 v3.0」）是一个跑在 Cloudflare Workers 上的多协议代理（VLESS / Trojan / xhttp），基于 `cloudflare:sockets` 实现。这个仓库把最繁琐的部分自动化：让你的 Worker 始终跟进最新版本。

### 功能

- ⏰ **自动升级** — 每 6 小时检查 `byJoey/cfnew` 是否有新版本，自动下载 `Pages.zip` 并把 `_worker.js` 部署到你的 Worker。
- 🔒 **保留配置** — 每次部署都会保留 KV 命名空间绑定（`C`）和 `u` UUID 密钥。
- 🖥️ **本地脚本** — `deploy.sh` 可以在你自己机器上完成同样的事，不需要 GitHub。
- 🧭 **版本记录** — `VERSION.txt` 记录已部署版本，避免重复部署。

### 前提条件

- 一个 Cloudflare 账号，且已创建（或准备创建）一个 Worker。
- 一个绑定到该 Worker、变量名为 `C` 的 KV 命名空间（可选，但图形化面板需要它）。
- 一个受限的 API Token，至少需要：
  - `Workers Scripts: Write`
  - `Workers KV Storage: Write`
  （账号级。也可以用 Global API Key。）

### 配置 —— GitHub Actions（自动升级）

1. **Use this template**（或 fork）并克隆。
2. 在仓库的 **Settings → Secrets and variables → Actions → New repository secret** 里添加：

   | 密钥 | 必填 | 说明 |
   | :--- | :--- | :--- |
   | `CF_ACCOUNT_ID` | ✅ | Cloudflare 账号 ID（面板右侧栏可见）。 |
   | `CF_API_TOKEN` | ✅ | 受限 API Token（见前提条件）或 Global API Key。 |
   | `KV_NAMESPACE` | ✅ | 绑定到 Worker、变量名为 `C` 的 KV 命名空间 ID。 |
   | `UUID` | ✅ | 你的订阅 UUID（既是面板路径，也是密钥 `u`）。 |
   | `WORKER_NAME` | ⬜ | Worker 脚本名，默认 `cfnew-terminal`。 |

3. 开启工作流写权限：**Settings → Actions → General → Workflow permissions → Read and write permissions**。（fork 默认是只读。）
4. 手动运行一次：**Actions → "Sync & Deploy CFnew" → Run workflow**。

之后每 6 小时自动检查，只有出现新版本时才重新部署。

### 配置 —— 本地脚本

```bash
cp .env.example .env     # 然后填入各项值
chmod +x deploy.sh
./deploy.sh              # 拉取最新 release 并部署
./deploy.sh local <文件>  # 改为用本地源码部署
```

### 工作流原理

```
定时（每 6 小时）/ 手动
        │
        ▼
获取 cfnew 最新 release ── 版本没变？──▶ 跳过
        │ 版本变了
        ▼
下载 Pages.zip → 解压 _worker.js
        │
        ▼
上传到 Worker（模块格式，保留 KV 绑定 "C"）
        │
        ▼
写入密钥 "u" = UUID
        │
        ▼
提交 VERSION.txt + _worker.js
```

### 安全提醒

- 永远不要把 `.env` 或任何 token 提交到公开仓库（已加入 `.gitignore`）。
- 优先使用受限 API Token 而不是 Global API Key，并限定到你的账号。
- 自动提交需要 `contents: write` 权限，已在工作流中声明，需在仓库设置里开启。
