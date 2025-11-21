# Tokyo Night Tmux

> forked from [janoamaral](https://github.com/janoamaral)/[tmux-status-line](https://github.com/janoamaral/tmux-status-line)

## Requirements

> ![IMPORTANT]
> I'm doing a full rewrite of this project to fix a few performance concerns and make the script a regular `sh` script so that it can run with fewer dependencies. It will strive to use tools specified by the POSIX standard so there will be no need to install gnu coreutils in the future.

This theme has the following hard requirements:

- Any patched [Nerd Fonts] (v3 or higher)
- Bash 4.2 or newer

The following are recommended for full support of all widgets and features:

- [GNU coreutils](https://www.gnu.org/s/coreutils/)
- netspeed-widget
    - [bc](https://www.gnu.org/software/bc/)
- git web widget
    - [jq](https://github.com/jqlang/jq)
    - [gh](https://cli.github.com)
    - [glab](https://docs.gitlab.com/cli/)
- music-widget
    - [playerctl](https://github.com/altdesktop/playerctl) _(Linux)_
    - [nowplaying-cli](https://github.com/kirtan-shah/nowplaying-cli) _(macOS)_

Check documentation for installing on other operating systems.

## Installation using TPM

In your `tmux.conf`:

```bash
set -g @plugin "janoamaral/tmux-status-line"
```

## Configuration

**_coming soon..._**

## Styles

- `hide`: hide number
- `none`: no style, default font
- `fsquare`: filled square (󰎡...󰎼) _(requires nerdfont)_
- `hsquare`: hollow square (󰎣...󰎾) _(requires nerdfont)_
- `dsquare`: hollow double square (󰎡...󰎼) _(requires nerdfont)_

## Highlights

**_coming soon..._**

## Contributing

> [!IMPORTANT]
> Please read the [contribution guide first](CONTRIBUTING.md).

Feel free to open an issue or pull request with any suggestions or improvements.

Ensure your editor follows the style guide provided by `.editorconfig`.
[pre-commit] hooks are also provided to ensure code consistency, and will be
run against any raised PRs.

[pre-commit]: https://pre-commit.com/
[Noto Sans]: https://fonts.google.com/noto/specimen/Noto+Sans
[Nerd Fonts]: https://www.nerdfonts.com/
[coreutils]: https://www.gnu.org/software/coreutils/
[bc]: https://www.gnu.org/software/bc/
[jq]: https://jqlang.github.io/jq/
[playerctl]: https://github.com/altdesktop/playerctl
[nowplaying-cli]: https://github.com/kirtan-shah/nowplaying-cli
[Homebrew]: https://brew.sh/
