#!/usr/bin/env bash
# Global worktrunk hook (post-start / post-switch, see ~/.config/worktrunk/config.toml): symlinks
# every gitignored, env-like file from the main checkout into the target worktree, for any repo.
# `git worktree add` only populates tracked files, so a per-machine .env/.envrc/etc. is otherwise
# missing in a fresh worktree until copied by hand -- this keeps one source of truth per repo
# instead of drifting copies. Idempotent and safe to re-run; never overwrites a real file.
#
# Invoked by worktrunk as: link-env-files.sh <repo_path> <worktree_path>
set -euo pipefail

repo_path="${1:?missing repo_path}"
worktree_path="${2:?missing worktree_path}"

[ "${repo_path}" = "${worktree_path}" ] && exit 0
[ -d "${repo_path}/.git" ] || exit 0    # repo_path isn't a main checkout (e.g. bare or unexpected layout) - skip quietly
[ -d "${worktree_path}" ] || exit 0

# True if `rel` (relative to repo_path) sits inside another checkout -- a linked worktree,
# submodule or vendored repo, each with its own .git file/dir at its root. Those own their own
# env files (and their own hook run); recreating their internal layout here would be nonsense
# (e.g. a repo's gitignored .claude/worktrees/*).
is_nested_checkout() {
	local dir="$1"
	while [ "${dir}" != "." ] && [ "${dir}" != "/" ]; do
		[ -e "${repo_path}/${dir}/.git" ] && return 0
		dir="$(dirname "${dir}")"
	done
	return 1
}

cd "${repo_path}"

# Gitignored + untracked files matching common env/secret naming, at any depth (glob pathspec
# magic enables **). git prunes whole ignored directories (node_modules/, build/, ...) itself,
# so this stays cheap even on a large repo.
git ls-files --others --ignored --exclude-standard -- \
	':(glob)**/.env' ':(glob)**/.env.*' ':(glob)**/*.env' ':(glob)**/.envrc' \
	2>/dev/null | while IFS= read -r rel; do
	src="${repo_path}/${rel}"
	# A wholly-ignored directory (e.g. .claude/worktrees/*) is reported as "dirname/" itself,
	# not descended into -- skip anything that isn't actually a file/symlink match.
	[ -f "${src}" ] || [ -L "${src}" ] || continue
	if is_nested_checkout "$(dirname "${rel}")"; then
		continue
	fi
	dst="${worktree_path}/${rel}"
	if [ -e "${dst}" ] && [ ! -L "${dst}" ]; then
		echo "link-env-files: skip ${rel} (real file already exists in worktree)" >&2
		continue
	fi
	mkdir -p "$(dirname "${dst}")"
	ln -sf "${src}" "${dst}"
	echo "link-env-files: linked ${rel}"
done
