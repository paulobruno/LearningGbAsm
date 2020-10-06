### Gargabe values on VRAM

In all previous examples, Nintendo's logo remained on screen. This is because we changed only specific VRAM values. When we just print the tiles in the positions we want, the rest of VRAM remains with the previous _garbage_ values.

This can be seen easily if we print the text on the same addresses than Nintendo's logo. The ones that weren't modified remained with the symbol.

![Screen not cleared](images/not_cleared.png)

### Clearing VRAM

We can solve this problem by setting all VRAM values to zero, effectively clearing the screen before copying the values onto it. In fact, clearing the VRAM at the start of the game is a very good practice. With this change, we can see that Nintendo's logo is gone.

![Clear screen](images/clear_screen.png)