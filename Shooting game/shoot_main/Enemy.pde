import ketai.camera.*;
import android.media.SoundPool;
public class Enemy
{
  float HP=100;
  PShape e;
  float x, posX, posY,posZ,theta=0.0,noiseX,noiseY;
  int thval=1;
  PVector p;
  Enemy(PShape ps, int scale,int HP)
  {
    this.HP = HP;
    e = ps;
    e.disableStyle();
    e.scale(scale);
    while(posX>-800 && posX<800)
    {
      posX=random(-3000, 3000);
    }
    posY = random(-height/2, height/2);
    posZ =random(-4000/(2*PI),-300);
    p = new PVector(posX,posY,posZ);
    
    noiseX = 0.0;
    noiseY = 0.0;
  }
  float attack(int stage)
  {
    return 4*stage;
  }
  boolean damage(float d)
  {
    
    if (mouseX>=width/2+posX+noiseX-50 && mouseY>=height/2+posY+noiseY-110 && mouseX<=width/2+posX+noiseX+50 && mouseY<=height/2+posY+noiseY+110)
    {
      HP-=d;
      return true;
    } else
    {
      return false;
    }
  }
  PVector getLocation()
  {
    return p;
  }
  void drawEnemy(float rotX,float rotY,float rotZ)
  {
    posX+=rotX*60;
    posY-=rotY*30+rotZ*10;
    //posZ+=rotZ*10;
    
    if(posX<-4000 || posX>4000)
    {
      posX*=-1;
      if(posX<0)
      {
        posX+=50;
      }
      if(posX>0)
      {
        posX-=50;
      }
    }
    if(posY<-3000 || posY>3000)
    {
      posY=height/2;
    }
    if(posZ<-3000 || posZ>3000)
    {
      posZ=0;
    }
    p.x = posX;
    p.y = posY;
    p.z = posZ;
    lights();
    pushMatrix();
    translate(width/2, height/2+posY+100, posZ);
    rotateX(radians(180));
    fill(255-HP*2, 98+HP-80, 7+HP-80);
    strokeWeight(1);
    pushMatrix();
    translate(posX,0,0);
    rotateY(radians (180));
    shape(e, 0, 0);
    popMatrix();
    popMatrix();
    
    
    rectMode(CENTER);
    noFill();
    
if(width/2+posX>-400 && width/2+posX<width+400)
    {
      noiseX=-posX*(posZ/2.5)/posZ;
    }
    else
    {
      noiseX=0;
    }
    if(height/2+posY>-300 && height/2+posY<height+300)
    {
      noiseY=-posY*(posZ/2.5)/posZ;
    }
    else
    {
      noiseY=0;
    }
    //rect(width/2+posX+noiseX,height/2+posY+noiseY, 100, 300);
  }
}

//PShape model;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("Guard/Guard.obj");
//  model.disableStyle();
//  model.scale(50);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+100, 0);
//  rotateX(radians(180));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateY(mouse_r);
//  stroke(0);
//  //fill(22,98,7);
//  shape(model);
//}

//PShape model;
//import java.io.FileOutputStream;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("Soldier_Mask04.obj");
//  model.disableStyle();
//  model.scale(5);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+200, 0);
//  rotateX(radians(180));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateY(mouse_r);
//  stroke(0);
//  //fill(22,98,7);
//  shape(model);
//}

//PShape model;
//import java.io.FileOutputStream;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("Guerilla.obj");
//  model.disableStyle();
//  model.scale(5);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+200, 0);
//  rotateX(radians(90));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateZ(mouse_r);
//  stroke(0);
//  //fill(22,98,7);
//  shape(model);
//}


//PShape model;
//import java.io.FileOutputStream;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("ArmyPilot.obj");
//  model.disableStyle();
//  //model.scale(5);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+200, 0);
//  rotateX(radians(180));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateY(mouse_r);
//  stroke(0);
//  //fill(22,98,7);
//  shape(model);
//}

//PShape model;
//import java.io.FileOutputStream;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("CtriadBoss.obj");
//  model.disableStyle();
//  model.scale(3);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+200, 0);
//  rotateX(radians(180));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateY(mouse_r);
//  stroke(0);
//  //fill(22,98,7);
//  shape(model);
//}

//PShape model;
//import java.io.FileOutputStream;

//public void setup() {
//  size(500, 500, P3D);

//  model = loadShape("EDF_trooper.obj");
//  model.disableStyle();
//  model.scale(50);
//}

//public void draw() {
//  background(0);
//  lights();

//  translate(width/2, height/2+200, 0);
//  rotateX(radians(180));

//  float mouse_r = map(mouseX, 0, width, 0, 2*PI);
//  rotateY(mouse_r);
//  stroke(0);
//  fill(22,98,7);
//  shape(model);
//}