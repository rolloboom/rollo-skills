#!/bin/bash
# Ставить набір скілів у ~/.claude/skills (доступні в усіх сесіях/репо).
set -u
DEST="${HOME}/.claude/skills"; TMP="$(mktemp -d)"; mkdir -p "$DEST"
clone() {  # клон із 3 спробами
  for i in 1 2 3; do
    git clone --depth 1 "https://github.com/$1.git" "$TMP/$2" >/dev/null 2>&1 && return 0
    echo "retry $i: $1"; sleep 3
  done
  echo "WARN: clone failed $1"
}
clone coreyhaines31/marketingskills mk
clone hardikpandya/stop-slop ss
clone wshuyi/remotion-video-skill rv
clone muratcankoylan/agent-skills-for-context-engineering ce
clone nextlevelbuilder/ui-ux-pro-max-skill ui
cp -r "$TMP"/mk/skills/*/ "$DEST"/ 2>/dev/null
cp -r "$TMP"/ui/.claude/skills/*/ "$DEST"/ 2>/dev/null
for s in context-compression context-degradation context-fundamentals context-optimization; do
  cp -r "$TMP/ce/skills/$s" "$DEST"/ 2>/dev/null; done
mkdir -p "$DEST/stop-slop"; cp "$TMP"/ss/SKILL.md "$DEST/stop-slop/" 2>/dev/null; cp -r "$TMP"/ss/references "$DEST/stop-slop/" 2>/dev/null
mkdir -p "$DEST/remotion-video"; cp "$TMP"/rv/SKILL.md "$DEST/remotion-video/" 2>/dev/null; cp -r "$TMP"/rv/scripts "$TMP"/rv/templates "$DEST/remotion-video/" 2>/dev/null
rm -rf "$TMP"
echo "Installed $(find "$DEST" -name SKILL.md | wc -l) skills into $DEST"
# Перевірка ключових дизайн-скілів
for s in ui-ux-pro-max design brand design-system slides banner-design ui-styling; do
  [ -f "$DEST/$s/SKILL.md" ] && echo "OK  $s" || echo "MISSING $s — перезапустіть скрипт"
done
