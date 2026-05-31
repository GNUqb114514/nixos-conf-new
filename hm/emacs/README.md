# `hm/emacs/` — My home-manager modules
This is my Emacs configurations live, and it is also the biggest part of my Home Manager configuration.

I am going to publicate it separately as it contains a lot of convenient features.

## Roadmap
Here are things I'm going to include in this module:

- [ ] Fundamental configurations. Something that I will not use Emacs without.
  - [ ] Font configuration
  - [ ] Miscellaneous configurations I'm sure to copy from my old configuration.
  - [ ] Split threshold
- [ ] Operation enhancements. Something that make using Emacs easier and faster.
  - [ ] Keymappings
	- [ ] `keyfreq`, so I can tweak my configurations based on real statistics instead of make up one.
	- [ ] `mwim` to enhance `C-a` and `C-e`
	- [ ] `helpful` to enhance `C-h`s.
  - [ ] Operations on texts
	- [ ] `separedit.el`
	- [ ] `query-replace` enhancement
  - [ ] Minibuffer-related plugins
- [ ] Coding tools
  - [ ] Project and environment management
	- [ ] `envrc` support. It is an emacs tool to load direnv  `.envrc` files buffer-locally, which is important for my workflow which heavily uses direnv to manage per-project environment.
	- [ ] `project` configurations.
  - [ ] Completion support.
	- [ ] Yasnippet *without* yasnippet-snippets. The latter is too heavy for me.
	  - [ ] As well as some curated snippets.
	- [ ] CAPF configuration with Cape enhancement. I'm going to use manual `C-M-i` key instead of letting something pops up when I type, which will be more efficient and costs less mappings.
  - [ ] Treesitter and LSP configuration. The state-of-the-art way to configure completion and diagnosis support at present, editor-agnostic.
  - [ ] Per-language configuration. Mostly minor-mode packages.
- [ ] Org-mode
  - [ ] Org-agenda and org-todo for todo managing
  - [ ] Org-mode document prettification
