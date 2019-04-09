import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
Arduino arduino;

//set analog pins for servos ~
int servo1 = 5, servo2 = 3; //3 is taped;
int led1 = 13, led2 = 12;
int servo1CurrentPos, servo1MinPos = 10, servo1MaxPos = 30;
boolean servo1true, servo2true;
int servo2CurrentPos, servo2MinPos = 0, servo2MaxPos = 30;

import KinectPV2.*;
KinectPV2 kinect;

int leftCheck = 173, rightCheck = 328;  //Set these on the mid point of hands/playertokens

void setup() {   
  size(1024, 425);
  
  arduino = new Arduino(this, Arduino.list() [0], 57600);
  arduino.pinMode(servo1, Arduino.SERVO);
  arduino.pinMode(servo2, Arduino.SERVO);
  arduino.pinMode(led1, Arduino.OUTPUT);
  arduino.pinMode(led2, Arduino.OUTPUT);
  
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.init();
  
  println(arduino.analogRead(servo1));
  println(arduino.analogRead(servo2));
  arduino.servoWrite(servo2, servo2MinPos);
  arduino.servoWrite(servo1, servo1MaxPos);
}  
void draw() {
  background(0);   
  image(kinect.getDepthMaskImage(), 0, 0);
  textSize(32);

  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  if(skeletonArray.size() == 0){ 
    //Player text
    fill(100, 100, 100);
    text("Player 1:", 550, 30); 
    fill(100, 100, 100);
    text("Player 2:", 550, 150); 
    arduino.servoWrite(servo2, servo2MinPos);
    arduino.servoWrite(servo1, servo1MaxPos);
  }
  else if(skeletonArray.size() == 1){
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
    arduino.servoWrite(servo2, servo2MinPos);
    arduino.servoWrite(servo1, servo1MaxPos);
  }
}
  
void getHand(KJoint left1, KJoint right1, KJoint left2, KJoint right2, boolean multi){
    
    //multiplayer--------------------------------------------------------------------------------------------------
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
      
      //move servo
      //get left and right
      float left, right;
      float player1pos = (right1.getX()/2)+(left1.getX()/2), player2pos = (right2.getX()/2)+(left2.getX()/2);
      if(player1pos < player2pos){ //check if > or < is correct
        left = player1pos;
        right = player2pos;
      }
      else{
        left = player2pos;
        right = player1pos;
      }
      
      //left servo
      if(left > leftCheck && !servo2true){
        servo2true = true;
        arduino.servoWrite(servo2, servo2MaxPos);
        arduino.digitalWrite(led1, Arduino.HIGH);
      }
      else if (left < leftCheck && servo2true){
        servo2true = false;
        arduino.servoWrite(servo2, servo2MinPos);
        arduino.digitalWrite(led1, Arduino.LOW);
      }
      //right servo
      if(right < rightCheck && !servo1true){
        servo1true = true;
        arduino.servoWrite(servo1, servo1MinPos);
        arduino.digitalWrite(led2, Arduino.HIGH);
      }
      else if(right > rightCheck && servo1true){
        servo1true = false;
        arduino.servoWrite(servo1, servo1MaxPos);
        arduino.digitalWrite(led2, Arduino.LOW);
      }
    }
    //singleplayer------------------------------------------------------------------------------------------
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
      //move servos--------------------------------------------------------------------------------------------
      //left servo
      if(left1.getX() > leftCheck && !servo2true){
        servo2true = true;
        arduino.servoWrite(servo2, servo2MaxPos);
        arduino.digitalWrite(led1, Arduino.HIGH);
      }
      else if (left1.getX() < leftCheck && servo2true){
        servo2true = false;
        arduino.servoWrite(servo2, servo2MinPos);
        arduino.digitalWrite(led1, Arduino.LOW);
      }
      //right servo
      if(right1.getX() < rightCheck && !servo1true){
        servo1true = true;
        arduino.servoWrite(servo1, servo1MinPos);
        arduino.digitalWrite(led2, Arduino.HIGH);
      }
      else if(right1.getX() > rightCheck && servo1true){
        servo1true = false;
        arduino.servoWrite(servo1, servo1MaxPos);
        arduino.digitalWrite(led2, Arduino.LOW);
      }
    }
      
  }
