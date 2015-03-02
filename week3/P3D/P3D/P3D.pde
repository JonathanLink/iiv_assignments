import ddf.minim.*;
float depth = 2000;
final int FRAME_RATE = 24;

float time = 0.0;
int frameCounter = 0;
float previousTime = 0.0;
float rotate = 0.0;
int timeBox = 0;
int nextBoxX = 0;
int nextBoxY = 0;

void setup() {
  size(500, 500, P3D);
  noStroke();
  frameRate(FRAME_RATE);
  
  
  /*Minim minim = new Minim(this);
  AudioPlayer song = minim.loadFile("hip_hop.mp3");
  song.play();
  song.loop();*/
  
}


void draw() {
  
  time += 1.0/FRAME_RATE;
  frameCounter++;
  
  float deltaTime = time - previousTime;
  
  camera(width/2, height/2, depth, 250, 250, 0, 0, 1, 0);
  directionalLight(50, 100, 125, 0, -1, 0);
  ambientLight(102, 102, 102);

  background(200);

  translate(width/2, height/2, 0);

  float rz = map(mouseY, 0, height, 0, PI);
  float ry = map(mouseX, 0, width, 0, PI);
  rotateZ(ry);
  rotateY(rz);

  rotate = rotate + (2*PI)/5000 % 2*PI;
  rotateX(rotate);
  

  if (frameCounter % 3 == 0) {
    nextBoxX = (nextBoxX + 1) % 5;
    //set the range, we want a value between -2 and 2.
    nextBoxX = (nextBoxX > 2)? nextBoxX - 5 : nextBoxX;     
  }
  
  for (int x = -2; x <= 2; x++) {
    for (int y = -2; y <= 2; y++) {
      for (int z = -2; z <= 2; z++) {
        pushMatrix();
        translate(100 * x, 100 * y, 100 * z);
        stroke(255, 255, 255);
        if (x == nextBoxX) {
          fill(225,0,0);
        } else {
          fill(225,225,225);
        }
        box(50);
        popMatrix();
      }
    }
  }
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      depth -= 50;
    } else if (keyCode == DOWN) {
      depth += 50;
    } 
  }  
  println(depth);
}

