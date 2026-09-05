# CFnew 订阅使用指南 · Subscription Guide

[中文](#中文) · [English](#english)

---

<a id="chinese"></a>
## 中文

### 你的订阅信息

| 项目 | 地址 |
| :--- | :--- |
| 管理面板 | `https://alvinsun.cc.cd/0bac62fa-fc2c-457d-91a5-d9ee6ce4587a` |
| 订阅地址 | `https://alvinsun.cc.cd/0bac62fa-fc2c-457d-91a5-d9ee6ce4587a/sub` |


### 各客户端导入方法

订阅地址会自动识别客户端（User-Agent），**同一个地址**导入即可；如需强制指定格式，可在末尾加 `?target=clash` / `?target=v2ray` / `?target=singbox` 等。

| 客户端 | 平台 | 步骤 |
| :--- | :--- | :--- |
| **Clash Verge / Clash Meta** | Win / Mac / Linux | 配置(Profiles) → 新建 → 粘贴订阅地址 → 下载，然后选节点开启 |
| **Stash** | iOS / Mac | 设置 → 配置 → 添加 → 粘贴订阅地址 → 保存 |
| **Shadowrocket（小火箭）** | iOS | 右上角 `+` → 类型选 `Subscribe` → 粘贴订阅地址 → 保存 |
| **Surge** | iOS / Mac | 首页 → 从 URL 下载配置 → 粘贴订阅地址 |
| **Loon** | iOS | 配置 → 订阅 → 添加 → 粘贴订阅地址 |
| **Quantumult X** | iOS | 右下角 → 节点 → 右上角 → 订阅 → 添加 → 粘贴订阅地址 |
| **v2rayN** | Windows | 订阅分组 → 订阅分组设置 → 添加订阅地址 → 更新订阅 |
| **v2rayNG** | Android | 菜单 → 订阅设置 → 添加订阅地址 → 更新 |
| **NekoRay** | Win / Linux | 程序 → 添加配置 → 订阅 → 粘贴订阅地址 |
| **sing-box** | 全平台 | 导入 Profile（URL）→ 粘贴订阅地址 |

> 建议勾选「更新订阅时自动测速」或手动对节点测一次延迟，选最快的用。

### 管理面板怎么用

打开「管理面板」地址，可以图形化调整，改完点右下角**保存**（或 `Ctrl+S` / `Cmd+S`），立即生效，无需重新部署：

- **协议开关**：VLESS（默认开）、Trojan、xhttp，可同时开多个。
- **优选设置**：优选 IP 来源 URL、地区筛选、只留最快的 N 个。
- **延迟测试**：面板内置测速，手动输入 IP / 批量从 URL 拉取 / 随机 CF IP。
- **出站代理**：可填你自己的 SOCKS5 / HTTP(S) 落地代理，控制出口 IP。
- **ECH**：加密 Client Hello，默认关；需要抗 SNI 阻断再开。
- **自定义路径**：不用 UUID 当路径时，可在这里改成自己的路径。

### 自动升级

- 本仓库的 GitHub Actions 每 6 小时检查 cfnew 新版本，**有新版本就自动部署**到你的 Worker（保留配置和 UUID）。
- 手动触发：仓库 **Actions → "Sync & Deploy CFnew" → Run workflow**。
- 不想用 GitHub，本地也能跑：`cp .env.example .env`（填好）→ `./deploy.sh`。

---

<a id="english"></a>
## English

### Your subscription

| Item | URL |
| :--- | :--- |
| Panel | `https://alvinsun.cc.cd/0bac62fa-fc2c-457d-91a5-d9ee6ce4587a` |
| Subscription | `https://alvinsun.cc.cd/0bac62fa-fc2c-457d-91a5-d9ee6ce4587a/sub` |


### Import into clients

The subscription URL auto-detects the client via User-Agent — the **same URL** works everywhere. To force a format, append `?target=clash` / `?target=v2ray` / `?target=singbox`, etc.

| Client | Platform | Steps |
| :--- | :--- | :--- |
| **Clash Verge / Clash Meta** | Win / Mac / Linux | Profiles → New → paste subscription URL → download, then pick a node |
| **Stash** | iOS / Mac | Settings → Profiles → Add → paste URL → save |
| **Shadowrocket** | iOS | `+` (top-right) → type `Subscribe` → paste URL → save |
| **Surge** | iOS / Mac | Home → Download config from URL → paste URL |
| **Loon** | iOS | Config → Subscription → Add → paste URL |
| **Quantumult X** | iOS | Bottom-right → Nodes → top-right → Subscription → Add → paste URL |
| **v2rayN** | Windows | Subscription group → settings → add URL → update |
| **v2rayNG** | Android | Menu → Subscription settings → add URL → update |
| **NekoRay** | Win / Linux | Program → Add config → Subscription → paste URL |
| **sing-box** | All | Import profile (URL) → paste URL |

> Run a latency test after updating (or enable auto-test) and pick the fastest node.

### Using the panel

Open the panel URL to adjust settings graphically. Hit **Save** (or `Ctrl+S` / `Cmd+S`) — changes apply instantly, no redeploy needed:

- **Protocols**: VLESS (on by default), Trojan, xhttp — can enable several at once.
- **Preferred IPs**: source URL, region filter, keep-only-fastest-N.
- **Latency test**: built-in — manual IPs, fetch from a URL, or random CF IPs.
- **Outbound proxy**: set your own SOCKS5 / HTTP(S) proxy to fix the exit IP.
- **ECH**: encrypted Client Hello (off by default; enable only if you need to resist SNI blocking).
- **Custom path**: replace the UUID path with your own.

### Auto-upgrade

- This repo's GitHub Actions checks for new cfnew releases every 6 hours and **auto-deploys on new versions** (config & UUID preserved).
- Manual trigger: **Actions → "Sync & Deploy CFnew" → Run workflow**.
- Local alternative: `cp .env.example .env` (fill it in) → `./deploy.sh`.
