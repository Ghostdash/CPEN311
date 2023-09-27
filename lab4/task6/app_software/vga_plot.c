inline static void vga_plot(unsigned x, unsigned y, unsigned colour){
    volatile unsigned *vga = (volatile unsigned *) 0x00004000; /* VGA adapter base address */
    volatile unsigned data;
    unsigned int buffer = 0x00000000;

    data = ((unsigned int) y << 24 | (unsigned int) x << 16 | buffer << 8 |(unsigned int) colour);
    *vga = data;
}