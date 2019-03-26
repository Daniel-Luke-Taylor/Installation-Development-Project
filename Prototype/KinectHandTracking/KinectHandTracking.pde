import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
Arduino arduino;
import KinectPV2.*;
KinectPV2 kinect;

void setup() {   
  size(1024, 425);
  arduino = new Arduino(this, Arduino.list() [0], 57600);
  arduino.pinMode(13, Arduino.OUTPUT);
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.init();
}  
void draw() {   
  background(0);   
  image(kinect.getDepthMaskImage(), 0, 0);
  textSize(32);

  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  if(skeletonArray.size() == 0){ 
    arduino.digitalWrite(13, Arduino.LOW);
    //Player text
    fill(100, 100, 100);
    text("Player 1:", 550, 30); 
    fill(100, 100, 100);
    text("Player 2:", 550, 150); 
  }
  else if(skeletonArray.size() == 1){
    arduino.digitalWrite(13, Arduino.HIGH);
    //Player text
    fill(255, 0, 0);
    text("Player 1:", 550, 30);
    fill(100, 100, 100);
    text("Player 2:", 550, 150);
    
    //Get Player 1 Hands
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    KJoint[] joints1 = skeleton.getJoints();

    getHand(joints1[KinectPV2.JointType_HandLeft], joints1[KinectPV2.JointType_HandRight], null, null, false);
  }
  else if(skeletonArray.size() == 2){
    arduino.digitalWrite(13, Arduino.HIGH);
    //Player text
    fill(255, 0, 0);
    text("Player 1:", 550, 30);
    fill(0, 0, 255);
    text("Player 2:", 550, 150);
    
    //Get Players Hands
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(0);
    KJoint[] joints1 = skeleton.getJoints();
    skeleton = (KSkeleton) skeletonArray.get(1);
    KJoint[] joints2 = skeleton.getJoints();

    getHand(joints1[KinectPV2.JointType_HandLeft], joints1[KinectPV2.JointType_HandRight], joints2[KinectPV2.JointType_HandLeft], joints2[KinectPV2.JointType_HandRight], true);
  }
  else{
    fill(255, 255, 255);
    text("Spooky Scary Skeleton Overload", 550, 30);
  }
}
  
void getHand(KJoint left1, KJoint right1, KJoint left2, KJoint right2, boolean multi){
    
    //multiplayer
    if(multi){
      //player 1
      //Print Hand pos
      //Left
      fill(0, 255, 0);
      text(str(left1.getX()), 550, 60); 
      fill(100, 100, 100);
      text(str(left1.getY()), 550, 90);
      //Right
      fill(255, 255, 0);
      text(str(right1.getX()), 800, 60); 
      fill(100, 100, 100);
      text(str(right1.getY()), 800, 90);
      //draw hands token
      fill(0, 255, 0);
      circle(left1.getX(),left1.getY(),15);
      fill(255, 255, 0);
      circle(right1.getX(),right1.getY(),15);
      //Draw player Token
      fill(255, 0, 0);
      circle((right1.getX()/2)+(left1.getX()/2),(right1.getY()/2)+(left1.getY()/2),50);
      
      //player 2
      //Print Hand pos
      //Left
      fill(0, 255, 0);
      text(str(left2.getX()), 550, 180);
      fill(100, 100, 100);
      text(str(left2.getY()), 550, 210);
      //Right
      fill(255, 255, 0);
      text(str(right2.getX()), 800, 180);
      fill(100, 100, 100);
      text(str(right2.getY()), 800, 210);
      //draw hands token
      fill(0, 255, 0);
      circle(left2.getX(),left2.getY(),15);
      fill(255, 255, 0);
      circle(right2.getX(),right2.getY(),15);
      //Draw player Token
      fill(0, 0, 255);
      circle((right2.getX()/2)+(left2.getX()/2),(right2.getY()/2)+(left2.getY()/2),50);
    }
    //singleplayer
    else{
      //Print Hand pos
      //Left
      fill(0, 255, 0);
      text(str(left1.getX()), 550, 60); 
      fill(100, 100, 100);
      text(str(left1.getY()), 550, 90);
      //Right
      fill(255, 255, 0);
      text(str(right1.getX()), 800, 60); 
      fill(100, 100, 100);
      text(str(right1.getY()), 800, 90);
      //draw hands token
      fill(0, 255, 0);
      circle(left1.getX(),left1.getY(),15);
      fill(255, 255, 0);
      circle(right1.getX(),right1.getY(),15);
      //Draw player Token
      fill(255, 0, 0);
      circle((right1.getX()/2)+(left1.getX()/2),(right1.getY()/2)+(left1.getY()/2),50);
      
    }
      
  }
