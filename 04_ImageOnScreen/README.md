### Image on screen

We are going to show this smile tile on screen.

![Smile!](images/smile.png)

The GameBoy way of defining a tile is [not very intuitive](https://www.huderlem.com/demos/gameboy2bpp.html).
Our smile image is defined by:

```
    db $3C, $3C, $5E, $62
    db $BF, $D5, $FF, $81
    db $FF, $A5, $BF, $D9
    db $9F, $E1, $7E, $7E
```

After loading it into the left most tile, address `$9800`, we get an image on screen!

| | |
| --- | --- |
| ![Image on VRAM](images/palette_0_vram.png) | ![Image on screen](images/palette_0_screen.png) |

Well, it was not the smile I was hoping...  
This happened because we are using the background palette (BGP) already set:

![Palette 0](images/palette_0.png)

To correctly print the colors, we should set a new BGP.

*Note: the previous palette had the value of `%11111100`.*


### Setting a palette

The address `$FF47` holds the BGP register. We set it to `%11100100` to get our desired palette:

![Palette 1](images/palette_1.png)

Then, we get the intended results:

| | |
| --- | --- |
| ![Palette 1 VRAM](images/palette_1_vram.png) | ![Palette 1 screen](images/palette_1_screen.png) |

Now, we could just play with the palettes and see the results we get.


### Setting a different palette

I changed the palette only to show a different result.

![Palette 2](images/palette_2.png)

With this palette, we get:

| | |
| --- | --- |
| ![Palette 2 VRAM](images/palette_2_vram.png) | ![Palette 2 screen](images/palette_2_screen.png) |
