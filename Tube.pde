class Tube {
    float y, gap, x;
    float w;
    float maxX, maxY;

    public Tube(float gap_) {
        gap=gap_;
        maxX=1000;
        maxY=500;
        y=random(maxY-maxY/7*2);

        w=maxX/20;
        x=maxX-w;
    }
    void  show() {
        fill(0, 250, 50);
        rect(x, 0, w, y);
        rect(x, y+gap, w, maxY-y-gap);
    }
    void move(float speed) {
        x-=speed;
    }
}
