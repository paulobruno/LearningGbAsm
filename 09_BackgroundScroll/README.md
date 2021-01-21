This is the first code with animation. 
On the previous codes, I just had to copy the desired sprites to memory and start an infinite loop.

Unlike them, now I had to make something inside the main loop.
In this case, I increased the background X position after a small delay, which is enough to create a scrolling animation.

# TODO
Background scroll is saved on address lalala and when it goes through the limit of the screen, it warps to the other side.

![Background Scroll](bg_scroll.gif)