class Button {
    float x, y, w, h;
    String s;
    color fill;
    color pressedFill;
    color border;
    boolean noStroke=false;
    boolean pressed=false;
    public Button(float x, float y, float w, float h, String s, color fill, color border) {
        this.x=x;
        this.y=y;
        this.w=w;
        this.h=h;
        this.s=s;
        this.fill=fill;
        this.pressedFill=color(255-(red(fill)+green(fill)+blue(fill))/3);
        this.border=border;
    }
    public Button(float x, float y, float w, float h, String s, color fill) {
        this.x=x;
        this.y=y;
        this.w=w;
        this.h=h;
        this.s=s;
        this.fill=fill;
        this.pressedFill=color(255-(red(fill)+green(fill)+blue(fill))/3);
        noStroke =true;
    }
    public Button(float x, float y, float w, float h, color fill) {
        this.x=x;
        this.y=y;
        this.w=w;
        this.h=h;
        this.s="";
        this.fill=fill;
        this.pressedFill=color(255-(red(fill)+green(fill)+blue(fill))/3);
        noStroke =true;
    }
    void show() {
        if(pressed)fill(pressedFill);
        else fill(fill);
        if (noStroke)noStroke();
        else stroke(border);
        rect(x, y, w, h);
        if(pressed)fill(fill);
        else fill(255-(red(fill)+green(fill)+blue(fill))/3);
        textSize(h-10);
        text(s, x+5, y+h-h/5);
    }
    void printInfo() {
        println("buttonDim: ", x, " ", y, " ", x+w, " ", y+h);
    }
    boolean isPressed() {
        if (mouseX>x &&mouseX<x+w && mouseY >y &&mouseY<y+h) {
            pressed=!pressed;
            String ss=pressed==true?"on":"off";
            println(s," was clicked and is now: "+ss);
            return true;
        }
        else return false;
    }
}
