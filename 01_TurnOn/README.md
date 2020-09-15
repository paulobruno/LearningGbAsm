To create a basic ROM who does nothing, we need three things:

1. An *entry point* section at `ROM0` address `$100`;
2. Empty *header* bytes from `$104` to `$150`;
3. And a *main* section with a label.

Meeting all of these conditions, we can see that the ROM is being loaded correctly:

![Turn-on the Screen](turn_on.png)