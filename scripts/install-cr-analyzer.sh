#!/usr/bin/env bash
set -euo pipefail

repo="${CR_ANALYZER_ROOT:-$HOME/cr-analyzer}"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
install_dir="${CR_ANALYZER_INSTALL_DIR:-$data_home/nvim/cr-analyzer}"
binary="$install_dir/cr-analyzer"
staged_binary="$binary.new.$$"

if [[ ! -f "$repo/shard.yml" || ! -f "$repo/src/bin/cra.cr" ]]; then
	printf 'cr-analyzer source not found at %s\n' "$repo" >&2
	printf 'Set CR_ANALYZER_ROOT to its checkout path.\n' >&2
	exit 1
fi

for tool in crystal shards; do
	if ! command -v "$tool" >/dev/null 2>&1; then
		printf 'Required command not found: %s\n' "$tool" >&2
		exit 1
	fi
done

mkdir -p "$install_dir"
trap 'rm -f "$staged_binary"' EXIT
(
	cd "$repo"
	shards install --frozen
	crystal build src/bin/cra.cr --release --no-debug --output "$staged_binary"
)

chmod +x "$staged_binary"
mv -f "$staged_binary" "$binary"
trap - EXIT
printf 'Installed cr-analyzer from %s to %s\n' "$repo" "$binary"
