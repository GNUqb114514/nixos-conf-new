# `hm/` — My home-manager modules
This is where my home-manager modules live, and is also the biggest part of my configuration.

I am going to make it a subflake to help caching.

## Roadmap
Here are things I'm going to include in this module:

- [ ] GUI stuff
  - [ ] Window manager. I'm going to choose [niri](https://github.com/niri-wm/niri)
  - [ ] [Noctalia](https://github.com/noctalia-dev/noctalia-shell) shell. I'm currently not sure whether I should choose v4 or v5 so I'm going to make it an option.
	I was using a lot of independent GUI applications but the all-in-one solution, Noctalia, is going to replace all of them. All I need is to reconfigure my Niri keymap so the shortcuts call Noctalia instead of legacy programs. 
- [ ] Miscellaneous stuff
  - [ ] Browser. I'm going to use Chromium or something similar.
- [ ] Emacs. I'm going to use the server-client mode so the startup time is not very important. I'm still going to make something lazy so they are not going to affect my startup time.
  - [ ] A library to make life easier. I want to publicate it independently in the future.
  - [ ] Fundamental configurations. Something that I will not use Emacs without.
  - [ ] Operation enhancements. Something that make using Emacs easier and faster.
  - [ ] Coding tools. Including:
	- [ ] Treesitter and LSP configuration. The state-of-the-art way to configure completion and diagnosis support at present, editor-agnostic.
	- [ ] Per-language configuration. Mostly minor-mode packages.

Note that this list is not final version; I may change this list whenever I found it necessary. This is also not the same as my previous config; the biggest modification is the absence of Neovim (being replaced by Emacs).
