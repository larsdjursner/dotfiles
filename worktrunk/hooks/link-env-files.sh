#!/usr/bin/env bash
# Global worktrunk hook (pre-start / pre-switch, see ~/.config/worktrunk/config.toml): symlinks
# every gitignored, env-like file from the main checkout into the target worktree, for any repo.
# `git worktree add` only populates tracked files, so a per-machine .env/.envrc/etc. is otherwise
# missing in a fresh worktree until copied by hand -- this keeps one source of truth per repo
# instead of drifting copies. Idempotent and safe to re-run.
#
# A real file where the link belongs (typically a symlink an editor replaced on save) is swapped
# for the link silently when identical to the source, and after a y/N prompt when it differs;
# without a terminal (e.g. run by an agent) it is kept, with a warning naming the command to re-run.
# Runs as a pre-* hook because post-* hooks are detached and cannot reach the terminal.
#
# Invoked by worktrunk (or by hand) as:
#   link-env-files.sh <repo_path> <worktree_path>
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

# Asks y/N on /dev/tty; exit 0 = yes, 1 = no, 2 = no terminal (e.g. run by an agent).
# worktrunk starts each hook in its own process group, so the hook is not the terminal's foreground
# group and a plain tty read stops it with SIGTTIN (the hang). The helper makes its group the
# foreground for the prompt and hands the terminal back afterwards, also on Ctrl-C.
ask_tty() {
	perl -MPOSIX -e '
		open(my $tty, "+<", "/dev/tty") or exit 2;
		my $fd = fileno($tty);
		$SIG{TTOU} = "IGNORE";
		my $orig = POSIX::tcgetpgrp($fd);
		my $restore = sub { POSIX::tcsetpgrp($fd, $orig) if $orig > 0 };
		$SIG{INT} = sub { $restore->(); print $tty "\n"; exit 1 };
		POSIX::tcsetpgrp($fd, getpgrp());
		$tty->autoflush(1);
		print $tty $ARGV[0];
		my $answer = <$tty>;
		$restore->();
		exit((defined $answer && $answer =~ /^\s*y(es)?\s*$/i) ? 0 : 1);
	' "$1"
}

# Asks whether to replace the real file at `rel`; returns 0 = yes, 1 = no, 2 = no terminal.
confirm_replace() {
	local rel="$1"
	ask_tty "link-env-files: ${rel} in ${worktree_path} is a real file that differs from the main checkout.
Remove it and symlink to ${repo_path}/${rel}? [y/N] "
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
		if cmp -s "${src}" "${dst}"; then
			echo "link-env-files: ${rel} was an identical copy, replacing with symlink"
		else
			answer=0
			confirm_replace "${rel}" || answer=$?
			if [ "${answer}" -ne 0 ]; then
				echo "link-env-files: WARNING ${rel} in ${worktree_path} is a real file that differs from the main checkout, not linked." >&2
				[ "${answer}" -eq 2 ] && echo "  To replace it with the symlink, run: $0 '${repo_path}' '${worktree_path}'" >&2
				continue
			fi
			echo "link-env-files: removing ${rel} (confirmed)"
		fi
		rm -f "${dst}"
	fi
	mkdir -p "$(dirname "${dst}")"
	ln -sf "${src}" "${dst}"
	echo "link-env-files: linked ${rel}"
done
