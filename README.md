# omarchy-dtp-glass-popups

The bar's flyouts (audio, Bluetooth, Wi-Fi, display, agents and the rest) take the bar's look: see-through and blurred when the bar is glassy, solid when it is opaque or clear.

A theme can set the flyouts' colors once, but the bar's look is picked at run time in `shell.json`, so a theme cannot follow it. This service plugin watches that choice and sets the flyouts' `background-alpha` to match (0.35 glassy, 1 otherwise, the same as the dtp cards). It also gives the flyouts' layer the blur rule the bar already has, while the bar is glassy.

Pairs with `omarchy-dtp-theme`, which removes the flyouts' border.

## Install

`omarchy-dtp-install` runs this. From GitHub:

```bash
omarchy plugin add https://github.com/dtpietrzak/omarchy-dtp-glass-popups.git --enable
```

It sets the alpha in memory only. Nothing is written to your config files.
