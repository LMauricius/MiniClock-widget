# Mini Analog Clock

A KDE Plasma 6 analog clock widget for tiny, system-tray-sized panels. It is based on
the built-in Analog Clock (`plasma-workspace` v6.8.1, `applets/analog-clock`) and keeps
its tooltip, calendar popup, time zone label and hand animation. The themed SVG face is
replaced with flat, vector-drawn hands.

## Layout

| Path                         | Contents                                                                                                                   |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `widget/`                    | The plasmoid source (`metadata.json`, `contents/`)                                                                         |
| `upstream/plasma-workspace/` | Sparse checkout of upstream `plasma-workspace` at `v6.8.1`, limited to `applets/analog-clock` (git-ignored, for reference) |

To recreate the upstream checkout:

```sh
git clone --depth 1 --branch v6.8.1 --filter=blob:none --sparse \
    https://invent.kde.org/plasma/plasma-workspace.git upstream/plasma-workspace
git -C upstream/plasma-workspace sparse-checkout set applets/analog-clock
```

## Scripts

| Script                     | Purpose                                                                   |
| -------------------------- | ------------------------------------------------------------------------- |
| `./install.sh [--restart]` | Install or upgrade for the current user (`--restart` reloads plasmashell) |
| `./uninstall.sh`           | Remove it                                                                 |
| `./test.sh [w h]`          | Install, then run it in a standalone window (`plasmawindowed`)            |
| `./package.sh`             | Build a `.plasmoid` archive                                               |

## Sizing rules

- Thickness settings are a percentage of the clock's diameter. A computed width is never
  below its minimum: hour hand 2.5 pt, minute hand 1 pt, seconds hand 0.5 pt, border 0.5 pt.
  A slider at 0 always uses the minimum.
- The minute and seconds hands are 40% and 20% as wide as the hour hand.
- The seconds dot is 3x the border thickness (at least 2.5 pt) and touches the border.
- Hand lengths are a percentage of the radius inside the border. At 100% a hand reaches the border.
- With the border on, the clock leaves a gap on each side (the Spacing setting, a percentage of
  the widget's thickness), since thin panels give widgets no margins of their own.
