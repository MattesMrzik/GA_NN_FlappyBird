import java.util.Queue;
import java.util.LinkedList;
import java.util.*;
///////////////////////////
float birdX=50;
float tubeGap;
float tubeSpeed;
boolean play=false;
int inputSize =4;
int layerSize=4;

final float gameW=1000;
final float gameH=500;

Button playB;
Button reviveB;
Button newTubesB;
Button resetB;
Button nextGenB;
Button nextGensB;

Queue <Tube> tubes = new LinkedList<Tube>();
LinkedList<Bird[]>generations=new LinkedList<Bird[]>();
Bird [] birds;
Bird selected;

///////////////////////////
void setup() {
    size(1200, 800);
    //fullScreen();
    orientation(LANDSCAPE);
    birds=new Bird[500];
    tubeSpeed=2;
    tubeGap=gameH/4;
    selected=new Bird(1, inputSize, layerSize);
    fillBirdsArray();

    menu(width/2, 10, width/2-20, height/3);
}
///////////////////////////
void menu(float x, float y, float w, float h) {
    int b=6;
    playB=new Button(x+10, y, w, h/b, "play", color(255), color(0));
    reviveB=new Button(x+10, y+h/b, w, h/b, "revive", color(255), color(0));
    newTubesB=new Button(x+10, y+h/b*2, w, h/b, "tubes", color(255), color(0));
    resetB=new Button(x+10, y+h/b*3, w, h/b, "reset", color(255), color(0));
    nextGenB=new Button(x+10, y+h/b*4, w, h/b, "nextGen", color(255), color(0));
    nextGensB=new Button(x+10, y+h/b*5, w, h/b, "nextGens", color(255), color(0));
    nextGensB.pressed=true;
}
///////////////////////////
void draw() {
    background(200);
    //TODO adjust map in mousePressed
    showGame(10, 10, width/2-10, height/2-10);

    if (play) {
        moveBirds();
        killBirds();
        if (percentAlive()<1f/4f && nextGensB.pressed) {
            nextGen();
        }
  }

    showIntel();

    playB.show();
    reviveB.show();
    newTubesB.show();
    resetB.show();
    nextGenB.show();
    nextGensB.show();
}
///////////////////////////
void showGame(float x, float y, float w, float h) {
    pushMatrix();
    noFill();
    translate(x, y);
    rect(0, 0, w, h);
    scale(w/gameW, h/gameH);


    tubeStuff();
    showBirds();
    popMatrix();
}
///////////////////////////
float percentAlive() {
    int count=0;
    for (Bird b : birds) {
        if (!b.dead)count++;
    }
    return count*1f/birds.length*1f;
}
///////////////////////////
void nextGen() {
    //vieleicht erste next gen wen knopf
    ArrayList<Bird> birdList= new ArrayList<Bird>(Arrays.asList(birds));
    //best first
    Collections.sort(birdList, new BirdCompare());
    //good birds closer to 0
    int quater=birdList.size()/4;

    //TODO affspring equivalant to score
    for (int i=0; i<quater; i++) {
        birdList.get(i+quater).mutate(birdList.get(i), 0.2);
        birdList.get(i+quater*2).mutate(birdList.get(i), 0.1);
        birdList.get(i+quater*3).mutate(birdList.get(i), 0.05);
    }
    play=true;
    reviveBirds();
    tubes = new LinkedList<Tube>();
}
///////////////////////////
void showIntel() {
    fill(255);
    stroke(0);
    showNet(10, height/2+10, width/2-10, height/2-20);
    showGraph(width/2+10, height/2+10, width/2-20, height/2-20);
}
///////////////////////////
void tubeStuff() {

    for (Tube t : tubes) {
        if (play)t.move(2);
      t.show();
    }
    if (lastInQueue().x<gameH)tubes.add(new Tube(tubeGap));
    if (tubes.size()>0 && tubes.peek().x<-50) {
        tubes.poll();
    }
}
///////////////////////////
void killBirds() {
    for (int i=0; i<birds.length; i++) {
        if (birds[i].die(tubes))birds[i].dead=true;
    }
}
///////////////////////////
void moveBirds() {
    for (Bird b : birds) {
        b.fall();
        b.jump(tubeInFrontOfBird());
    }
}
///////////////////////////
void showBirds() {
    noFill();
    for (Bird b : birds) b.show();

    if (selected.x==birdX && !selected.dead) {
        fill(0, 0, 255);
        ellipseMode(CENTER);
        ellipse(selected.x, selected.y, 2, 2);
        line(0, selected.y, birdX, selected.y);
    }
}
///////////////////////////
void mousePressed() {
    if (playB.isPressed())play=!play;
    if (reviveB.isPressed()) {
        reviveB.pressed=false;
        reviveBirds();
    }
    if (newTubesB.isPressed()) {
        tubes = new LinkedList<Tube>();
        newTubesB.pressed=false;
    }
    if (resetB.isPressed()) {
        selected=new Bird(1, inputSize, layerSize);
        play=false;
        resetB.pressed=false;
        tubes = new LinkedList<Tube>();
        fillBirdsArray();
    }
    if (nextGenB.isPressed()) {
        nextGenB.pressed=false;
        nextGen();
    }
    if (nextGensB.isPressed()&& allDead()) {
        nextGen();
    }

    Bird closest=new Bird(1, inputSize, layerSize);
    float d=100;

    //TODO mouseY map to canvas hight
    if (allDead())return;
    float adjustedHeight= map(mouseY, 10, height/2-10, 0, 500);
    for (Bird b : birds) {
        if (b.dead)continue;
        if (dist(b.x, b.y, mouseX, adjustedHeight)<d) {
            d=dist(b.x, b.y, mouseX, adjustedHeight);
            closest=b;
        }
    }
    if (closest.x!=1)selected=closest;
}
///////////////////////////
Tube tubeInFrontOfBird() {
    for (Tube t : tubes) {
        if (t.x+t.w>birdX)return t;
    }
    Tube farAway= new Tube(1);
    farAway.x=gameW;
    return farAway;
}
///////////////////////////
Tube lastInQueue() {
    Tube last = new Tube(1);
    last.x=0;
    for (Tube t : tubes) {
        last=t;
    }
    return last;
}
///////////////////////////
boolean allDead() {
    for (Bird b : birds)if (b.dead==false) return false;
    play=false;
    return true;
}
///////////////////////////
void fillBirdsArray() {
    for (int i=0; i<birds.length; i++) {
        birds[i]=new Bird(birdX, inputSize, layerSize);
    }
    generations.clear();
    generations.add(birds);
}
///////////////////////////
void reviveBirds() {
    for (int i=0; i<birds.length; i++) {
        birds[i].dead=false;
        birds[i].y=gameH/2;
        birds[i].s=0;
        birds[i].v=0;
    }
}
///////////////////////////
void showGraph(float x, float y, float w, float h) {
    noFill();
    stroke(0);
    rect(x, y, w, h);
    fill(0);
    float graphY=y;
    float step=h*1f/birds.length*1f;
    float maxDist=2*1f;
    ArrayList<Bird> BirdList= new ArrayList<Bird>(Arrays.asList(birds));
    //best first
    Collections.sort(BirdList, new BirdCompare());

    for (Bird b : birds) {
        if ( b.s!=0 &&maxDist<b.s) {
            maxDist=b.s;
        }
    }
    for (Bird b : BirdList) {
        ellipse(x+map(b.s, 0, maxDist, 0, w-10), graphY, 2, 2);
        graphY+=step;
    }
}
///////////////////////////
void showNet(float x, float y, float w, float h) {
    rect(x, y, w, h);
    ellipseMode(CENTER);
    noFill();
    stroke(0);

    for (int i=0; i<inputSize; i++) {
        ellipse(x+w/6, y+h/(inputSize*1f+(inputSize+1)/2f)*(i*1.5+1), h/(inputSize+1), h/(inputSize+1));
    }
    for (int i=0; i<layerSize; i++) {
        ellipse(x+w/2, y+h/(layerSize*1f+(layerSize+1)/2f)*(i*1.5+1), h/(inputSize+1), h/(inputSize+1));
    }
    for (int i=0; i<2; i++) {
        if (i==0&&selected.jum>selected.notJum)fill(200, 0, 0);
        if (i==1&&selected.jum<selected.notJum)fill(200, 0, 0);
        ellipse(x+w/6*5, y+h/(layerSize*1f+(layerSize+1)/2f)*(i*1.5+1), h/(inputSize+1), h/(inputSize+1));
        noFill();
    }

    strokeWeight(3);

    if (selected.x!=1) {
        //input to layer
        for (int i=0; i<layerSize; i++) {
            for (int j=0; j<inputSize; j++) {
                stroke(map(selected.brain1[i][j], -1, 1, 255, 0));
                line(x+w/6+h/(inputSize+1)/2, y+h/(inputSize*1f+(inputSize+1)/2f)*(j*1.5+1), x+w/2-h/(inputSize+1)/2, y+h/(inputSize*1f+(inputSize+1)/2f)*(i*1.5+1));
                if (i!=0)continue;
                fill(0);
                textSize(10);
                text(selected.input[j], x+w/6-h/(inputSize+1)/4, y+h/(inputSize*1f+(inputSize+1)/2f)*(j*1.5+1));
            }
        }

        //layer to output
        for (int i=0; i<2; i++) {
            for (int j=0; j<layerSize; j++) {
                stroke(map(selected.brain2[i][j], -1, 1, 255, 0));
                line(x+w/2+h/(inputSize+1)/2, y+h/(inputSize*1f+(inputSize+1)/2f)*(j*1.5+1), x+w/6*5-h/(inputSize+1)/2, y+h/(inputSize*1f+(inputSize+1)/2f)*(i*1.5+1));
                if (i!=0)continue;
                fill(0);
                textSize(10);
                text(selected.knotValues[j], x+w/2-h/(inputSize+1)/4, y+h/(inputSize*1f+(inputSize+1)/2f)*(j*1.5+1));
            }
        }
    }
    strokeWeight(1);
}
///////////////////////////
