### No function

Up until this point, all codes were written in a single code block. Although this is fine for small codes, as soon as they start to grow, it becomes very hard to read. For instance, the code in a single block has **45 [logical lines of code](https://en.wikipedia.org/wiki/Source_lines_of_code)** (LLOC) from the `Start` flag until the `jr .lock`.

### Creating the first function

In real code, we would use functions to better organize it. We will do the same here. Z80 ASM has a `call` instruction to call functions defined in a global label. 

At first, we just create a single separate function to copy bytes into VRAM. With this change, the code between `Start` and `jr .lock` has now **32 LLOC**.

### More functions

When creating more functions, we can decrease even more the number of lines inside the main block. Now, the code from the `Start` label until `jr .lock` has only **20 LLOC**, which is much better for readability. This is a reduction of 55% from the single block code.

A good practice (that I'm not following yet, my bad) is to describe the parameters in a comment before the function definitions.