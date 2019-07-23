
import controlP5.*;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.content.res.AssetFileDescriptor;
import android.content.Context;
import android.app.Activity;
import android.media.AudioManager;
import ketai.sensors.*;
ArrayList<Enemy> e;
User user;
float theta=0.0;
float rotationX=0, rotationY=0, rotationZ=0;
int gs, ds, ds2, ud, uw;
int[] stage={6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
PShape p1, p2, p3, p4, p5;
KetaiSensor sensor;
MediaPlayer mp1;
Context context1;
Activity act1;
AssetFileDescriptor afd1;

SoundPool soundpool;
Context context2;
Activity act2;
AssetFileDescriptor afd2;

KetaiCamera cam;
ControlP5 cp5;
Bang hpB;

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
void setup() {
  background(125, 100, 200);
  fullScreen(P3D);
  user = new User();
  orientation(LANDSCAPE);
  imageMode(CENTER);
  cam = new KetaiCamera(this, width, height, 24);
  cp5 = new ControlP5(this);
  e=new ArrayList<Enemy>();
  p1 = loadShape("Guard.obj");
  p2 = loadShape("Guard.obj");
  p3 = loadShape("Guard.obj");
  p4 = loadShape("Guard.obj");
  p5 = loadShape("Guard.obj");
  e.add(new Enemy(p1, 50, 100));
  e.add(new Enemy(p2, 50, 100));
  e.add(new Enemy(p3, 50, 100));
  e.add(new Enemy(p4, 50, 100));
  e.add(new Enemy(p5, 50, 100));
  sensor = new KetaiSensor(this);
  sensor.start();


  act1 = this.getActivity();
  context1 = act1.getApplicationContext();
  try {
    mp1 = new MediaPlayer();
    afd1 = context1.getAssets().openFd("BGM.mp3");//which is in the data folder
    mp1.setDataSource(afd1.getFileDescriptor());
    mp1.setAudioStreamType (AudioManager.STREAM_MUSIC);
    mp1.prepare();
  } 
  catch(IOException e) {
    println("file did not load");
  }

  act2 = this.getActivity();
  context2 = act2.getApplicationContext();
  soundpool = new SoundPool(20, AudioManager.STREAM_MUSIC, 0);
  try {
    afd2 = context2.getAssets().openFd("basic.mp3");//which is in the data folder
    gs = soundpool.load(afd2, 1);
    afd2 = context2.getAssets().openFd("DieSound.mp3");//which is in the data folder
    ds = soundpool.load(afd2, 2);
    afd2 = context2.getAssets().openFd("UserAttack.mp3");//which is in the data folder
    ds2 = soundpool.load(afd2, 3);
    afd2 = context2.getAssets().openFd("UserDie.mp3");//which is in the data folder
    ud = soundpool.load(afd2, 4);
    afd2 = context2.getAssets().openFd("UserWin.mp3");//which is in the data folder
    uw = soundpool.load(afd2, 5);
    for (int i=0; i<stage.length; i++)
    {
      String s = "stage"+(i+1)+".mp3";
      afd2 = context2.getAssets().openFd(s);//which is in the data folder
      soundpool.load(afd2, stage[i]);
    }
  }
  catch(IOException e) {
    println("file did not load");
  }

  mp1.setLooping(true);

  drawMainUI();
}
void keyPressed()
{
  if (keyCode==BACK || keyCode==MENU)
  {
    mp1.stop();
    System.exit(0);
  }
}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
void draw() {
  if (cam.isStarted())
  {
    background(cam, 0,0, width, height);
    if (frameCount%100==0)
    {
      thread ("enemyatk");
    }
    drawMap ();
    strokeWeight(1);
    for (int i=0; i<e.size(); i++)
    {
      e.get(i).drawEnemy(rotationX, rotationY, rotationZ);
    }

    rectMode(CENTER);
    fill(255, 255-(100-user.HP)*4, 255-(100+user.HP)*4, (100-user.HP));
    rect(width/2, height/2, width, height);
    drawAim();
  }
}
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

void enemyatk ()
{
  try {
    for (int i=0; i<e.size(); i++)
    {
      if (e.get(i).HP>0 && user.HP>0)
      {

        user.damage(e.get(i).attack(user.stage));
        hpB.setSize(int(user.HP*4), 40);
        hpB.setLabel(""+user.HP);
        soundpool.play(ds2, 0.6f, 0.6f, 2, 0, 1.0);
        if (user.HP<0)
        {
          soundpool.play(ud, 0.9f, 0.9f, 2, 0, 1.0);
        }
        Thread.sleep(int(random(400, 2000)));
      }
    }
  }
  catch(InterruptedException e) {
    e.printStackTrace ();
  }
}
void onGyroscopeEvent(float x, float y, float z)
{
  rotationX = x;
  rotationY = y;
  rotationZ = z;
}
void mousePressed()
{
  if (user.HP>0)
  {
    soundpool.play(gs, 0.5f, 0.5f, 2, 0, 1.0);
    for (int i=0; i<e.size(); i++)
    {
      if (e.get (i).damage(user.attack()))
      {
        soundpool.play(ds, 0.9f, 0.9f, 2, 0, 1.0);
        if (e.get (i).HP<=0)
        {
          e.remove(i);
        }
      }
      if (e.size()==0 && user.stage<11)
      {
        theta=0.0;
        user.stage++;
        soundpool.play(stage[user.stage-1], 0.9f, 0.9f, 2, 0, 1.0);
        user.HP=100;
        hpB.setSize(int(user.HP*4), 40);
        hpB.setLabel (""+user.HP);
        e.add(new Enemy(p1, 1, 100+user.stage*10));
        e.add(new Enemy(p2, 1, 100+user.stage*10));
        e.add(new Enemy(p3, 1, 100+user.stage*10));
        e.add(new Enemy(p4, 1, 100+user.stage*10));
        e.add(new Enemy(p5, 1, 100+user.stage*10));
      } else if (user.stage>10)
      {
        soundpool.play(uw, 0.9f, 0.9f, 2, 0, 1.0);
        e.clear ();
        cam.stop();
      }
    }
  } else
  {
    soundpool.play(ud, 0.9f, 0.9f, 2, 0, 1.0);
  }
}
void drawMap()
{
  ellipse(width-300, 100, 200, 200);
  pushMatrix();

  translate(width-300, 100);
  fill (255, 50);
  arc(0, 0, 200, 200, (-PI/2-0.1)-((PI*width)/4000)/2, (-PI/2+0.1)+((PI*width)/4000)/2);
  for (int i=0; i<e.size(); i++)
  {
    if (e.get(i).HP>0)
    {
      float posX = e.get(i).getLocation().x;
      if (posX<0)
      {
        posX = 8000+posX;
      }
      float theta=2*PI*posX/8000;
      fill(255, 0, 0);
      pushMatrix();
      rotateZ(theta);
      ellipse(0, PI*(e.get(i).getLocation().z)/40, 3, 3);
      popMatrix();
    }
  }
  popMatrix();
}
void drawMainUI()
{
  cp5.addTextlabel("label1")
    .setText("ID : ")
    .setPosition(width/2-width/7, height/3)
    .setColorValue(0xffffff00)
    .setFont(createFont("Georgia", 20))
    ;
  cp5.addTextfield("Input Your ID")
    .setPosition(width/2-width/10, height/3)
    .setSize(200, 40)
    .setFont(createFont("arial", 20))
    ;
  fill (230, 200, 0);
  cp5.addButton("Start")
    .setPosition(width/2-width/6, height/1.5)
    .setSize(width/3, height/5);

  textSize(50);
  text("WelCome!!!", width/3+100, height/7, 50);


  pushMatrix();
  translate(width/1.7, 0);
  drawOtter();
  popMatrix();

  pushMatrix();
  translate(width/2.5, 0);
  rotateY(radians(180));
  drawOtter();
  popMatrix();
}
void drawAim()
{
  noFill ();
  strokeWeight (4);
  ellipse(mouseX, mouseY, 80, 80);
  line(mouseX-40, mouseY, mouseX+40, mouseY);
  line(mouseX, mouseY-40, mouseX, mouseY+40);
}

///////////////////////////////////////////////////////////////////

public void Start(int theValue) {
  if (!cam.isStarted())
  {
    cam.start();
  }
  cp5.addButton("Menu")
    .setPosition(width-width/7, 0)
    .setSize(width/7, height/10);
  cp5.addButton("Shop")
    .setPosition(width-width/7, height/10+10)
    .setSize(width/7, height/10);
  cp5.addButton("ReSet")
    .setPosition(width-width/7, (height/10)*2+20)
    .setSize(width/7, height/10);
  cp5.remove("Start");
  cp5.remove("Input Your ID");
  cp5.remove("label1");
  hpB = cp5.addBang("bang")
    .setPosition(width/2-200, height-100)
    .setSize(400, 40)
    .setLabel(""+user.HP).setColorForeground(color(255, 0, 0, 127))
    ;
  mp1.start();
  soundpool.play(stage[0], 0.9f, 0.9f, 2, 0, 1.0);
}
///////////////////////////////////////////////////////////////////
public void Menu(int theValue) {
  println("MENU!!!!!!!!!!!!!!!!!!!!!!");
}
///////////////////////////////////////////////////////////////////
public void Shop(int theValue) {
  println("SHOP!!!!!!!!!!!!!!!!!!!!!!");
}
///////////////////////////////////////////////////////////////////
public void ReSet(int theValue) {
  if (cam.isStarted ()==false)
  {
    cam.start ();
  }
  user.HP=100;
  user.stage=1;
  e.clear();
  soundpool.play(stage[0], 0.9f, 0.9f, 2, 0, 1.0);
  e.add(new Enemy(p1, 1, 100+user.stage*10));
  e.add(new Enemy(p2, 1, 100+user.stage*10));
  e.add(new Enemy(p3, 1, 100+user.stage*10));
  e.add(new Enemy(p4, 1, 100+user.stage*10));
  e.add(new Enemy(p5, 1, 100+user.stage*10));
}
void onCameraPreviewEvent()
{
  cam.read();
}

void drawOtter()
{
  fill(127);
  noStroke();
  rect(200, 400, 110, 150);
  rect(200, 340, 80, 150);
  rect(175, 380, 80, 170);
  rect(152, 493, 45, 100);
  rect(143, 570, 10, 10);
  rect(268, 530, 45, 80);
  rect(285, 600, 20, 25);
  rect(310, 385, 25, 20);


  stroke(1);
  strokeWeight(3);
  arc(215, 335, 130, 150, radians(240), radians(380));
  arc(250, 279, 20, 30, radians(240), radians(360));

  fill(245, 217, 175);
  noStroke();
  ellipse(215, 310, 100, 70);
  stroke(2);
  strokeWeight(3);
  arc(215, 310, 100, 70, radians(110), radians(210));
  strokeWeight(1);
  arc(215, 310, 100, 70, radians(267), radians(292));

  fill(245, 217, 175);
  strokeWeight(1);
  arc(195, 290, 50, 42, radians(170), radians(317));
  noFill();
  strokeWeight(3);
  arc(240, 303, 30, 50, radians(240), radians(320));

  fill(72, 34, 2);
  noStroke();
  ellipse(190, 270, 15, 13);

  fill(242, 150, 73);
  ellipse(190, 268, 8, 3);

  noFill();
  stroke(1);
  strokeWeight(0.5);
  arc(175, 300, 80, 50, radians(240), radians(280));
  arc(175, 305, 60, 50, radians(220), radians(280));
  arc(175, 310, 30, 50, radians(200), radians(280));
  strokeWeight(0.8);
  arc(254, 306, 80, 50, radians(240), radians(280));
  arc(254, 317, 90, 60, radians(250), radians(290));
  arc(248, 315, 40, 45, radians(250), radians(330));

  fill(0);
  arc(206, 300, 45, 75, radians(0), radians(180));

  strokeWeight(2);
  fill(245, 217, 175);
  arc(190, 280, 30, 45, radians(60), radians(150));
  arc(220, 286, 50, 45, radians(60), radians(160));

  fill(250, 58, 70);
  arc(212, 309, 30, 55, radians(0), radians(200));

  strokeWeight(3);
  noFill();
  arc(208, 305, 45, 75, radians(65), radians(120));
  fill(125, 100, 200);
  arc(172, 382, 60, 150, radians(330), radians(444));

  fill(127);
  arc(175, 515, 60, 90, radians(120), radians(240));

  arc(175, 505, 30, 100, radians(200), radians(270));

  arc(179, 570, 100, 50, radians(170), radians(240));

  arc(153, 580, 50, 20, radians(90), radians(240));

  arc(170, 585, 60, 20, radians(-30), radians(240));

  arc(173, 548, 80, 80, radians(0), radians(60));

  arc(245, 520, 100, 80, radians(90), radians(140));

  arc(245, 520, 100, 80, radians(90), radians(140));

  arc(285, 557, 40, 150, radians(60), radians(150));

  arc(290, 500, 120, 200, radians(100), radians(150));

  arc(300, 618, 20, 20, radians(-50), radians(130));

  arc(337, 500, 160, 160, radians(-70), radians(110));

  arc(310, 580, 20, 70, radians(-10), radians(95));

  arc(295, 555, 50, 70, radians(-70), radians(40));

  fill(127);
  noStroke();
  rect(140, 392, 60, 25);

  stroke(1);
  strokeWeight(3);
  fill(125, 100, 200);
  arc(340, 490, 130, 110, radians(-75), radians(110));

  fill(127);
  arc(280, 490, 70, 100, radians(-30), radians(40));

  arc(273, 435, 80, 150, radians(270), radians(400));

  arc(160, 410, 100, 10, radians(40), radians(110));

  arc(142, 404, 10, 20, radians(70), radians(288));

  fill(125, 100, 200);
  arc(163, 380, 100, 30, radians(40), radians(110));

  noStroke();
  fill(245, 217, 175);
  ellipse(240, 440, 70, 150);
  rect(103, 386, 23, 30);
  rect(125, 393, 13, 10);
  rect(340, 376, 32, 33);


  stroke(1);
  strokeWeight(3);
  fill(245, 217, 175);
  arc(123, 398, 50, 10, radians(280), radians(310));
  arc(120, 393, 10, 30, radians(210), radians(360));
  arc(110, 390, 40, 10, radians(90), radians(280));
  arc(110, 400, 40, 10, radians(90), radians(280));
  arc(110, 410, 40, 10, radians(90), radians(280));
  arc(118, 407, 40, 20, radians(-50), radians(110));


  fill(125, 100, 200);
  arc(305, 346, 100, 100, radians(35), radians(85));
  fill(127);
  arc(280, 390, 130, 100, radians(20), radians(60));

  fill(245, 217, 175);
  arc(340, 395, 10, 25, radians(70), radians(280));
  arc(355, 379, 30, 10, radians(170), radians(300));
  arc(365, 380, 10, 30, radians(210), radians(360));
  arc(370, 387, 40, 10, radians(-90), radians(90));
  arc(370, 397, 40, 10, radians(-90), radians(90));
  arc(370, 406, 40, 10, radians(-90), radians(90));
  arc(362, 407, 40, 10, radians(72), radians(180));

  fill(39, 242, 237);
  ellipse(350, 430, 30, 30);
}
