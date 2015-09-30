import org.firmata.*;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

PImage img;
float scrollY;
float scrollSpeed = 100;

float ghostTime = -13750;
float whenToWhite = -19000;

float bg = 255;

float blinkSpeed = 300;

void setup() {
  arduino = new Arduino(this, "/dev/tty.usbmodem1411", 57600);
  for (int i = 0; i <= 13; i++){
   arduino.pinMode(i, Arduino.OUTPUT);
  }
   
  size(displayWidth, displayHeight);
  smooth();
  
  img = loadImage("chat.png");
}

void draw() {
  background(bg);
  translate(0, scrollY);
  image(img, width/2-img.width/2, 0);
  
  println(scrollY);
  
  if(keyPressed) {
    if(keyCode == 40) scrollY -= scrollSpeed;
    else if(keyCode == 38) scrollY += scrollSpeed; 
  }
     
  if(scrollY < -19000) bg = map(scrollY, -19000, -20000, 0, 300);
  else bg = map(scrollY, 0, -500, 255, 0);
  
  if(scrollY < ghostTime){    
    if(frameCount % blinkSpeed < blinkSpeed/2) arduino.digitalWrite(8, Arduino.LOW);
    else arduino.digitalWrite(8, Arduino.HIGH);
   
    blinkSpeed -= 1;
    
    arduino.digitalWrite(13, Arduino.HIGH);
  } else {
    arduino.digitalWrite(8, Arduino.HIGH);  //light
    arduino.digitalWrite(13, Arduino.LOW);  //fan
  } 
}