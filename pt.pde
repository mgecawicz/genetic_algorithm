class pt{
  float x; 
  float y;
  pt(float _x, float _y){
    x = _x; 
    y = _y;
  }
  void show(){
    stroke(255,0,0);
    strokeWeight(2);
    point(x,y);
  }
  
}
