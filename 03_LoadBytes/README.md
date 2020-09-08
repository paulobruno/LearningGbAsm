In the codes from [Image on VRAM](../02_ImageOnVram) we loaded the sprite bytes line by line. We are now gonna see a most elegant way to load sequential bytes using the `db` instruction.

*Note: `db` may not be recognized by all assemblers. I'm using [RGBDS](github.com/rednex/rgbds).*

![Loading bytes using db](define_bytes.png)

As we can see, we get the same result as before, but with a much cleaner code.