#include <Servo.h>

//It’s important to calibrate how far the servo can go before it reaches a stressed state, as to avoid breaking the servo. Please test and set both the minimal and the maximum values of the servos.
int servo1CurrentPosition = 0, servo1MinPos = 10, servo1MaxPos = 170, servo1TurnAngle = 45;
int servo2CurrentPosition = 10, servo2MixPos = 10, servo2MaxPos = 180, servo2TurnAngle = 45;
int servo1Pin = 2; // The pin where the first servo is attached to.
int servo2Pin = 3; // The pin where the second servo is attached to.

bool turnServo1 = true, turnServo2 = false;

Servo Servo1;
Servo Servo2;

void setup() {

Serial.begin(9600);
Servo1.attach(servo1Pin);
Servo2.attach(servo2Pin);

}

void loop() {

//Servo1.write(servo1CurrentPosition);
//Servo2.write(servo2CurrentPosition);

if (turnServo1 == true && servo1CurrentPosition <= servo1TurnAngle){ 
servo1CurrentPosition += servo1TurnAngle;
Servo1.write(servo1CurrentPosition);
}

if (turnServo1 == false && servo1CurrentPosition >= servo1TurnAngle){ 
servo1CurrentPosition -= servo1TurnAngle;
Servo1.write(servo1CurrentPosition);
}

}

