void setup() {
 // setup code
}

void loop() {
    uint8_t blue = 255;
    uint8_t off = 0;

    Bean.setLedBlue(blue);
    Bean.sleep(500);
    Bean.setLedBlue(off);
    Bean.sleep(4000);
}
