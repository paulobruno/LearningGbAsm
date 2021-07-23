### Sprite as a tile

When we use background tiles to show a sprite on the screen, there is no transparency.

![Screen](images/tiles_screen.png)

| VRAM | OAM | Background Map | Palette |
| :---: | :---: | :---: | :---: |
| ![VRAM](images/tiles_vram.png) | ![OAM](images/tiles_oam.png) | ![Background Map](images/tiles_bgmap.png) | ![Palette](images/tiles_palette.png) |


### Sprite on screen

To solve this problem, the sprite should be in the OAM (Object Attribute Memory a.k.a [Sprite Attribute Memory](https://gbdev.io/pandocs/Accessing_VRAM_and_OAM.html)).
In this case, one of the colors will be treated as a transparent value.

![Screen](images/sprite_screen.png)

| VRAM | OAM | Background Map | Palette |
| :---: | :---: | :---: | :---: |
| ![VRAM](images/sprite_vram.png) | ![OAM](images/sprite_oam.png) | ![Background Map](images/sprite_bgmap.png) | ![Palette](images/sprite_palette.png) |


### Clear OAM

However, when using the OAM some garbage can appear on the screen.
Therefore, we should clear the OAM before drawing the sprites.

![Screen](images/clear_screen.png)

| VRAM | OAM | Background Map |
| :---: | :---: | :---: |
| ![VRAM](images/clear_vram.png) | ![OAM](images/clear_oam.png) | ![Background Map](images/clear_bgmap.png) |
