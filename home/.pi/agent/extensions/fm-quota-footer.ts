// fm-quota-footer.ts - custom Pi footer: project · model · effort | ctx% | 5h% | 7d%
//
// Reads provider quota from the local `quota-axi --json` tool (cached 60s).
// The provider shown matches the active model's provider prefix; falls back
// to the first provider that reports quota windows.
//
// The agy (Antigravity) provider is excluded: quota-axi probes it by spawning
// `agy -p /quota`, and a signed-out agy answers every probe by opening an
// interactive OAuth tab in the default browser - one spam tab per pane per
// refresh. --no-credential-refresh keeps this passive footer read-only for
// the providers that support delegated credential renewal.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import path from "node:path";

const QUOTA_CACHE_MS = 60_000;
// Every quota-axi provider except agy (see header). Keep in sync with
// `quota-axi --help`'s provider list when quota-axi adds providers.
const QUOTA_PROVIDERS =
  "claude,codex,cursor,copilot,grok,kimi,zai,alibaba,opencode-go,commandcode,minimax,mimo,deepseek,openrouter,elevenlabs";
let quotaCache: { at: number; data: unknown } | null = null;

interface Window {
  id: string;
  percentRemaining?: number;
}

function refreshQuota(): void {
  const now = Date.now();
  if (quotaCache && now - quotaCache.at < QUOTA_CACHE_MS) return;
  quotaCache = { at: now, data: quotaCache?.data ?? null };
  execFile(
    "quota-axi",
    ["--json", "--no-credential-refresh", "--provider", QUOTA_PROVIDERS],
    { timeout: 10_000 },
    (err, stdout) => {
      if (err) return;
      try {
        quotaCache = { at: Date.now(), data: JSON.parse(stdout) };
      } catch {
        // keep previous cache
      }
    },
  );
}

function windowsFor(modelId: string): Window[] | null {
  const data = quotaCache?.data as {
    providers?: { provider: string; windows?: Window[] }[];
  } | null;
  if (!data?.providers) return null;
  const want = modelId.split("/")[0];
  const match =
    data.providers.find((p) => p.provider === want && p.windows?.length) ||
    data.providers.find((p) => p.windows?.length);
  return match?.windows ?? null;
}

function pct(windows: Window[] | null, id: string): string {
  const w = windows?.find((x) => x.id === id);
  return w && typeof w.percentRemaining === "number" ? `${w.percentRemaining}%` : "-";
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    refreshQuota();
    let tuiRef: { requestRender: () => void } | null = null;
    const timer = setInterval(() => {
      refreshQuota();
      tuiRef?.requestRender();
    }, QUOTA_CACHE_MS);

    ctx.ui.setFooter((tui, theme) => {
      tuiRef = tui;
      const render = (width: number): string[] => {
        refreshQuota();
        const dir = path.basename(ctx.cwd) || ctx.cwd;
        const model = ctx.model?.id || "no-model";
        const effort = process.env.PI_REASONING_LEVEL || "";

        const usage = ctx.getContextUsage?.();
        const win =
          (ctx.model as { context_window?: number } | undefined)?.context_window ?? 0;
        const ctxPct =
          usage && win > 0
            ? `${Math.min(100, Math.round((usage.tokens / win) * 100))}%`
            : "-";

        const windows = windowsFor(model);
        const right = theme.fg(
          "dim",
          `ctx ${ctxPct} · 5h ${pct(windows, "five_hour")} · 7d ${pct(windows, "weekly")}`,
        );
        const left = theme.fg(
          "accent",
          `${dir} · ${model.split("/").pop()}${effort ? ` · ${effort}` : ""}`,
        );
        const pad = " ".repeat(Math.max(1, width - visibleWidth(left) - visibleWidth(right)));
        return [truncateToWidth(left + pad + right, width)];
      };
      return {
        invalidate() {},
        render,
        dispose() {
          clearInterval(timer);
        },
      };
    });
  });
}
