class BirdCompare implements Comparator<Bird>{
public int compare(Bird a,Bird b) {
    if(a.s<b.s){
        return 1;
    }
    else if(a.s>b.s){
        return -1;
    }
    else if(a.s==b.s)  {
        if(a.dead && !b.dead)return 1;
        else  if(!a.dead && b.dead)return -1;
        else return 0;
    }
    else return 0;
    }
}
