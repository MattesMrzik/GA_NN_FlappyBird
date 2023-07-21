class Bird {
    /////////////////////////////////
    float y, v, a, x, s;

    float [] knotValues;
    float jum, notJum;
    float maxY, maxX;
    boolean dead=false;
    float [][] brain1;
    float [][] brain2;
    float []input;
    /////////////////////////////////
    public Bird(float x_, int inputSize_, int layerSize_) {
        maxY=500;
        maxX=1000;
        y=maxY/2f;
        v=0f;
        a=0.4f;
        x=x_;
        s=0;
        //                rows       collums
        brain1 = new float[layerSize][inputSize];
        brain2= new float [2][layerSize];
        knotValues=new float[layerSize];
        input = new float[inputSize];
        initBrain();
    }
    /////////////////////////////////
    void initBrain() {
        for (int i =0; i<brain1.length; i++) {
            for (int j =0; j<brain1[i].length; j++) {
                brain1[i][j]=random(1)-.5;
            }
        }
        for (int i =0; i<brain2.length; i++) {
            for (int j =0; j<brain2[i].length; j++) {
                brain2[i][j]=random(1)-.5;
            }
        }
    }
    /////////////////////////////////
    void mutate(Bird b, float mutateRate) {
        for (int i =0; i<brain1.length; i++) {
            for (int j =0; j<brain1[i].length; j++) {
                brain1[i][j]=b.brain1[i][j]+random(mutateRate)-mutateRate/2f;
            }
        }
        for (int i =0; i<brain2.length; i++) {
            for (int j =0; j<brain2[i].length; j++) {
                brain2[i][j]=b.brain2[i][j]+random(mutateRate)-mutateRate/2f;
            }
        }
    }
    /////////////////////////////////
    boolean die(Queue<Tube> tubes) {
        if (y<0 || y>maxY) {
            return true;
        }
        for (Tube t : tubes) {
            if (x>t.x && x<t.x+t.w && (y<t.y||y>t.y+t.gap) ) {
                return true;
            }
        }
        return false;
    }
    /////////////////////////////////
    void fall() {
        if (!dead) {
            y+=v;
            v+=a;
            s++;
        }
    }
    /////////////////////////////////
    void jump(Tube t) {
      if(dead)return;
      //d to top/bottum
      input[0]=map(y, 0, maxY, 0, 1);
      input[1]=map(y, 0, maxY, 1, 0);
      //d to tube
      input[2]=map(t.x-x, 0, maxX/2, 0, 1);
      //y
      input[3]=map(t.y+t.gap, 0, maxY, 1, 0);

      initVec(knotValues);
      for (int i =0; i<brain1.length; i++) {
          for (int j =0; j<brain1[i].length; j++) {
              knotValues[i]+=input[j]*brain1[i][j];
          }
      }
      jum=0;
      notJum=0;
      //i= 0 and 1
      for (int i =0; i<brain2.length; i++) {
          for (int j =0; j<brain2[i].length; j++) {
              if(i==0)jum+=knotValues[i]*brain2[i][j];
              else notJum+=knotValues[i]*brain2[i][j];
          }
      }
      if (jum>notJum) v=-8;
    }
    /////////////////////////////////
    void initVec(float [] vec){
        for(int i=0;i<vec.length;i++){
            vec[i]=0;
        }
    }
    /////////////////////////////////
    void show() {
        if (dead) return;
        ellipseMode(CENTER);
        fill(200, 100, 0);
        ellipse(x, y, 10, 10);
    }
    /////////////////////////////////
}
