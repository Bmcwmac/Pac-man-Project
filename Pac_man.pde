//Variables
float y = height/2;
float pX = 0;
float pSpeed = 2.5;
float pBody = 40;

float mSpeed = 0.05;
float bLip = QUARTER_PI;
float tLip = PI+QUARTER_PI+HALF_PI;
boolean pacMouth = true;
boolean direction = false;

float gX = random(800);
float gSpeed = 3;
float gChange = 1;
float gBody = 20;
int gEyes = 2;

float fX = random(800);
boolean vulnerable = true;
int start = 0;

float pellets[]= new float[19];
int array = 4; // so the pellets are centered
int stomach = 0;

int score = 0;

boolean gameEnd = false; //gameEnd variable

void setup() {
  size(800, 200);
  pX = width/2;
  y = height/2;

  //Pellet Setup
  for (int i = 0; i < pellets.length; i++) {
    pellets[i] = array;
    array = array + (width/18);
  }
}


void draw() {
  background(0);

  //Border lines
  rectMode(CORNER);
  fill(0, 0, 255);
  rect(0, 30, 800, 10);
  rect(0, 160, 800, 10);

  //Pellets
  fill(255);
  for (int i = 0; i < pellets.length; i++) {
    textAlign(CORNER, CORNER);
    textSize(13);
    text("Score: "+score, 10, 20);
    if (abs(pX-pellets[i])<=7) {
      pellets[i] = 6000;
      stomach += 1;
      score += 1;
    }
    if (stomach==pellets.length) {
      pelletReset(pellets);
    }
    circle(pellets[i], y, 5);
  }
  fruit();

  //Pacman body
  pX=pX+pSpeed;
  fill(255, 255, 0);
  arc(pX, y, pBody, pBody, bLip, tLip, PIE);

  //Mouth movement
  if (pacMouth==true) {
    bLip = bLip-mSpeed;
    tLip = tLip+mSpeed;
    if (direction == false) {
      if (bLip<=0 && tLip>= TWO_PI) {
        pacMouth = false;
      }
    }
    if (direction == true) {
      if (bLip<=PI && tLip>= TWO_PI+PI) {
        pacMouth = false;
      }
    }
  }

  if (pacMouth == false) {
    bLip = bLip+mSpeed;
    tLip = tLip-mSpeed;
    if (direction == false) {
      if (bLip==QUARTER_PI && tLip==PI+QUARTER_PI+HALF_PI) {
        pacMouth = true;
      }
    }
    if (direction == true) {
      if (bLip==PI+QUARTER_PI && tLip==TWO_PI+HALF_PI+QUARTER_PI) {
        pacMouth = true;
      }
    }
  }

  ghost();
  borders();
  End();
}
//Changing directions
void keyPressed () {
  if (key == ' ') {
    if (gameEnd==false) {
      //Turns left
      if (direction==false) {
        pSpeed = -pSpeed;
        bLip = PI+QUARTER_PI;
        tLip = TWO_PI+HALF_PI+QUARTER_PI;
        direction = true;
        pacMouth = true;
      }
      //Turns right
      else {
        pSpeed = -pSpeed;
        bLip = QUARTER_PI;
        tLip = PI+QUARTER_PI+HALF_PI;
        direction = false;
        pacMouth = true;
      }
      voicelines();
    }
  }
  if (key == 'r') {
    //click r to reset game and play again without restarting the program
    gameReset();
  }
}


//Functions
//Pellet Reset
void pelletReset(float a[]) {
  array = 4;
  for (int i = 0; i < a.length; i++) {
    a[i] = array;
    array = array + (width/18);
  }
  stomach=0;
}

//Ghost
void ghost() {
  gChange = random(250);
  gX = gX + gSpeed;
  ghostBody();
  if (gChange < 3) {
    gSpeed = -gSpeed;
    gEyes = -gEyes;
  }
}

//Fruit
void fruit() {
  fill(255,0,0);
  circle(fX, y, 10);
  if (dist(pX, y, fX, y)<5) {
    fX=random(800);
    start=millis();
  }
  if (start!=0) {
    if (millis()-start<=3000) {
      vulnerable=false;
    }
    if (millis()-start>=3000) {
      vulnerable=true;
    }
  }
}

//Game End
void End() {
  if (dist(pX, y, gX, y)<20 && vulnerable==true) {
    pSpeed=0;
    gSpeed=0;
    mSpeed=0;
    gEyes=0;
    gameEnd = true;
  }
  if (gameEnd==true) {
    gameOverText();
  }
}

void gameOverText() {
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(255, 0, 0);
  text("GAME OVER", 400, 100);
  fill(255);
  textSize(13);
}

//Border Detection
void borders() {
  //Pacman
  if (pX>width+pBody/2) {
    pX = 0-pBody/2;
  }
  if (pX<0-pBody/2) {
    pX = width+pBody/2;
  }
  //Ghost
  if (gX>width+gBody/2) {
    gX = 0-gBody/2;
  }
  if (gX<0-gBody/2) {
    gX = width+gBody/2;
  }
}



//Unnecesary code that I thought was funky
void ghostBody(){
  noStroke();
  if(vulnerable==true){
  fill(3,255,253);
  } else if(vulnerable==false) {
    fill(1,9,80);
  }
  rectMode(CENTER);
  circle(gX, y-5, gBody);
  rect(gX, y, gBody,10);
  triangle(gX-10,y+5,gX-5,y+5,gX-7.5,y+10);
  triangle(gX-5,y+5,gX,y+5,gX-2.5,y+10);
  triangle(gX,y+5,gX+5,y+5,gX+2.5,y+10);
  triangle(gX+5,y+5,gX+10,y+5,gX+7.5,y+10);
  fill(255);
  ellipse(gX-4,y-5,6,10);
  ellipse(gX+4,y-5,6,10);
  fill(0);
  ellipse(gX-4+gEyes,y-5,3,5);
  ellipse(gX+4+gEyes,y-5,3,5);
}
void gameReset() {
  background(0);
  gameEnd = false;
  pSpeed=2.5;
  gSpeed=3;
  mSpeed=0.05;
  gX=random(800);
  pX=400;
  fX=random(800);
  pelletReset(pellets);
  score=0;
  bLip = QUARTER_PI;
  tLip = PI+QUARTER_PI+HALF_PI;
  pacMouth = true;
  direction = false;
  gEyes = 2;
  start = 0;
  vulnerable = true;
}

void voicelines() {
  int r = (int)random(1, 6);
  if (r==1) {
    println("Pacu Pacu!");
  }
  if (r==2) {
    println("Waka Waka!");
  } else {
  }
}
