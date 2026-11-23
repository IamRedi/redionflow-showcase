#!/usr/bin/env bash
# Passive, read-only checks: one GET per URL, TLS handshake, DNS TXT lookups.
# No scanning, no logins, no load. Exit 1 when a CRITICAL item is found.
set -uo pipefail
dir="$(cd "$(dirname "$0")" && pwd)"
crit=0; out="${GITHUB_STEP_SUMMARY:-/dev/stdout}"
echo "## Security watch $(date -u +%F)" >> "$out"
echo "| URL | HTTP | TLS days | HSTS | CSP | Frame | nosniff | Powered-By |" >> "$out"
echo "|---|---|---|---|---|---|---|---|" >> "$out"
grep -vE '^\s*(#|$)' "$dir/targets.txt" | while read -r url; do
  host="${url#https://}"; host="${host%%/*}"
  h="$(curl -sS -o /dev/null -D - --max-time 20 -A 'security-watch' "$url" 2>/dev/null | tr -d '\r')"
  code="$(printf '%s\n' "$h" | awk 'toupper($1) ~ /^HTTP/ {c=$2} END{print c+0}')"
  has() { printf '%s\n' "$h" | grep -qiE "^$1:" && echo ok || echo "**missing**"; }
  hsts=$(has strict-transport-security); csp=$(has content-security-policy)
  frame=$( { printf '%s\n' "$h" | grep -qiE '^x-frame-options:|frame-ancestors'; } && echo ok || echo "**missing**")
  nos=$(has x-content-type-options)
  pb=$(printf '%s\n' "$h" | grep -iE '^x-powered-by:' | cut -d' ' -f2- ); pb=${pb:-none}
  end="$(echo | timeout 15 openssl s_client -servername "$host" -connect "$host:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)"
  days="?"; [ -n "$end" ] && days=$(( ( $(date -d "$end" +%s) - $(date +%s) ) / 86400 ))
  echo "| $url | $code | $days | $hsts | $csp | $frame | $nos | $pb |" >> "$out"
  if [ "$code" -lt 200 ] || [ "$code" -ge 500 ]; then echo "CRITICAL down: $url ($code)"; echo x >> /tmp/crit; fi
  if [ "$days" != "?" ] && [ "$days" -lt 14 ]; then echo "CRITICAL cert expires in $days days: $host"; echo x >> /tmp/crit; fi
done
echo "" >> "$out"; echo "| Mail domain | SPF | DMARC |" >> "$out"; echo "|---|---|---|" >> "$out"
grep -vE '^\s*(#|$)' "$dir/mail-domains.txt" | while read -r d; do
  spf=$(dig +short TXT "$d" | grep -i 'v=spf1' | head -1); dm=$(dig +short TXT "_dmarc.$d" | grep -i 'v=DMARC1' | head -1)
  echo "| $d | ${spf:-**missing**} | ${dm:-**missing**} |" >> "$out"
done
[ -f /tmp/crit ] && exit 1 || exit 0
