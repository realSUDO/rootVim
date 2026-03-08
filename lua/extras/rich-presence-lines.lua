local M = {}

M.paired_texts = {
	-- Neovim supremacy
	{
		workspace = "Neovim. Mouse declined.",
		editing = {
			"VS Code is Neovim with training wheels and a safety helmet.",
			"My config predates your laptop's RAM.",
			"Modal editing isn't a feature. It's the only correct way.",
			"Mouse users still think pointing is faster. Adorable.",
			"50 extensions = 50 points of failure. I run 4 plugins. Flawless.",
			"Your IDE cosplays as an editor. Mine was born one.",
		}
	},

	-- Terminal life
	{
		workspace = "terminal life, rent-free in your GUI soul",
		editing = {
			"tmux sessions older than your distro still ping me.",
			"Alacritty: one window to rule them all.",
			"Six panes. Each one sacred. No overlap allowed.",
			"htop is my altar. I light incense with glances.",
			"Close laptop lid? SSH enters god mode.",
			"Uptime 47 days. Your reboot schedule is embarrassing.",
		}
	},

	-- Distro flex
	{
		workspace = "Arch BTW. You already lost.",
		editing = {
			"`pacman -Syu` is my morning espresso shot.",
			"Arch Wiki > your entire support team.",
			"Minimal base install. Maximal superiority complex.",
			"I compiled the kernel yesterday. For fun.",
			"Arch isn't a phase, mom. It's eternal.",
		}
	},

	-- Git game
	{
		workspace = "rebasing main in silence",
		editing = {
			"`git commit -m 'fixed'` — poetry in 8 bytes.",
			"Force push with --force-with-lease. Classy violence.",
			"My commit history is cleaner than your browser tabs.",
			"`git blame` always points back to glory.",
			"Linear history. Linear thoughts. Linear flex.",
		}
	},

	-- Tiling WM
	{
		workspace = "tiling WM, zero visual garbage",
		editing = {
			"Overlapping windows = instant panic attack.",
			"My i3/sway config has more LOC than your degree.",
			"Workspaces > virtual desktops. Non-negotiable.",
			"Mod4+Enter is now a biological reflex.",
			"GNOME users are either lost or masochists.",
		}
	},

	-- Dotfiles
	{
		workspace = "dotfiles > your whole personality",
		editing = {
			"Bare git repo in ~ since git was written in shell.",
			"My `.zshrc` belongs in a museum.",
			"Same config on laptop, server, VPS, toaster. No compromises.",
			"Dotfiles public. Fork at your own skill level.",
			"Version-controlling my life. Even the regrets.",
		}
	},

	-- Keyboard elitism
	{
		workspace = "40% gang. Layers > excuses",
		editing = {
			"Layers deeper than your imposter syndrome.",
			"Function row? For people who fear commitment.",
			"Caps Lock = Esc. Heresy otherwise.",
			"QMK/VIA is my love language.",
			"Arrows on home row or you're doing life wrong.",
		}
	},

	-- Vim keys everywhere
	{
		workspace = "hjkl supremacy, no escape",
		editing = {
			"hjkl in every textbox. Every browser. Every sin.",
			"Vimium turned Chrome into something tolerable.",
			"Esc is my emotional support key.",
			"`:wq` ends fights, meetings, and bad relationships.",
			"Tried `:wq` in real life. Still recovering.",
		}
	},

	-- Tmux life (merged a bit with earlier tmux one)
	{
		workspace = "tmux empire, long may it detach",
		editing = {
			"2023 sessions still send me DMs.",
			"Four panes, four personalities, zero therapy.",
			"`tmux attach -t deepwork` = religious experience.",
			"Mouse support? Only if I feel like being charitable.",
			"Detach = freedom. Attach = purpose.",
		}
	},

	-- Debugging flex
	{
		workspace = "debugging like a grandmaster",
		editing = {
			"Stack traces are novels. I speed-read them.",
			"Understood the segfault before ChatGPT loaded.",
			"Warnings? Cute suggestions. I override.",
			"Debugging is chess. Printf is my queen.",
			"Rubber duck? I talk to strace.",
		}
	},

	-- Refactoring
	{
		workspace = "refactoring = digital minimalism",
		editing = {
			"Deleting code is the ultimate dopamine hit.",
			"Refactor Sunday > therapy Monday.",
			"-780 LOC this week. Living my best life.",
			"Technical debt dies on my branch.",
			"The best line of code is the one you never wrote.",
		}
	},

	-- Flow state
	{
		workspace = "flow state. notifications fear me",
		editing = {
			"Focus mode: airplane + do-not-disturb + spite.",
			"Four hours. Zero blinks. Cursor respects me.",
			"World events? They can wait in the queue.",
			"Time ceased to exist thirty minutes ago.",
			"Do not disturb means do NOT disturb.",
		}
	},

	-- Open source
	{
		workspace = "OSS contributor. quiet carry",
		editing = {
			"My PR has more tests than your whole repo.",
			"Fixed your transitive dependency in 2022. Still uncredited.",
			"That one feature you love? Yeah, that was me.",
			"Open source: where I flex without saying a word.",
			"Star my repo or I'll haunt your dependency tree.",
		}
	},

	-- The quiet brag
	{
		workspace = "RTFM lifestyle, superior by default",
		editing = {
			"`man` pages > your Stack Overflow bookmarks.",
			"RTFM isn't gatekeeping. It's self-respect.",
			"I read the error. You screenshot it.",
			"Docs are poetry. Most people just skim.",
			"I contribute to man pages. Yes, seriously.",
		}
	},

	-- Performance flex
	{
		workspace = "optimizing for sport",
		editing = {
			"Premature optimization? I call it good taste.",
			"Every nanosecond is personal.",
			"Cache miss = spiritual wound.",
			"14 MiB → 400 KiB. You're welcome, battery.",
			"If it isn't profiled, it didn't happen.",
		}
	},

	-- Setup flex
	{
		workspace = "rice lord. RGB aura maxed",
		editing = {
			"Colorscheme isn't taste—it's identity.",
			"Ligatures so pretty I forget to code.",
			"Transparency on terminal, opacity on ego.",
			"My rice is versioned. Yours is a screenshot.",
		}
	},

	-- Just vibes
	{
		workspace = "it works, obviously",
		editing = {
			"Compiles first try. Suspect behavior.",
			"One take. Zero linter warnings. Divine.",
			"It works on my machine. And that's the only machine.",
			"This is fine.jpg but I'm actually winning.",
			"Bugs fear me. Tests respect me.",
		}
	},

	-- Commit messages (short & iconic edition)
	{
		workspace = "commit messages of legend",
		editing = {
			"'it works now'",
			"'fixed hopefully'",
			"'please'",
			"'¯\\_(ツ)_/¯'",
			"'magic'",
			"'forgive me'",
		}
	},
}

return M
