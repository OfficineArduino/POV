// Code for the Arduino Bike POV project


// Arduino Bike POV
//
// by Scott Mitchell
// www.openobject.org
// Open Source Urbanism
//
// Copyright (C) 2008 Scott Mitchell 12-10-2008
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//

//============================================================
// 6/2011 heavily modified by c. Dubois for my POV project
// Hall sensor is a switch so I  used different code for it
// also used a font.h that I found
// ------------------------------------------------------------




// defining the alphabet
#include "font.h"

// define the Arduino LED pins in use
const int LEDpins[] = {
  5,6,7,8,9,10,11,12,};

const unsigned char CONTROL_LED = 13;

const boolean REVERSE = false;
const boolean FLIP = false;

// number of LEDs
const int charHeight = sizeof(LEDpins);
const int charWidth = 5;



// sensor setup
const int sensorPIN = 1;  // define the Arduino sensor pin

//  boolean sensorFlag = false;  // stores sensor state
int sensVal;  // variable to store the value coming from the sensor

int lastLapTime = -1;
int period = -1;

int interColumnSpace = 900;
int interLetterSpace = 2500;

const char textString[] = "BIKE PRIDE!";

void setup()
{
  for (unsigned char i = 0; i < charHeight; i++) {
    pinMode(LEDpins[i], OUTPUT);
    digitalWrite(LEDpins[i], HIGH);
  }
  pinMode(CONTROL_LED, OUTPUT);

  Serial.begin(9600);
}

void loop()
{
  // turn on Led for a circle in middle and proof that arduino is powered
  //digitalWrite(CONTROL_LED, HIGH);   // set the LED on  


  sensVal = analogRead(sensorPIN);  // read the Hall Effect Sensor  


  Serial.println(period);
  // delay(500 );  
  // had difficulty here
  // since it is a switch hall switch probably shoiuld just do digital read

  if (abs(sensVal-512)>5) {
    
    // printing every letter of the textString
    // NOTE (EG): this code must run long enough to let the
    // sensor go far
    for (unsigned char n=0; n < 2; n++) {
      for (int k=0; k<sizeof(textString); k++){
        unsigned char z = REVERSE ? (sizeof(textString)-k-1) : k;
        printLetter(textString[z]);
      }
    }

    if (lastLapTime != -1) {
      period = millis() - lastLapTime;
      interColumnSpace = period / 555;
      interLetterSpace = period / 200;
    }
    lastLapTime = millis();
  }
}




void printLetter(char ch)
{
  // make sure the character is within the alphabet bounds (defined by the font.h file)
  // if it's not, make it a blank character



  if (ch < 32 || ch > 126){
    ch = 32;
  }
  // subtract the space character (converts the ASCII number to the font index number)
  ch -= 32;
  // step through each byte of the character array
  for (int i=0; i<charWidth; i++) {
    byte b = REVERSE ? font[ch][charWidth-i-1] : font[ch][i];
    //byte b = 0xff;


    // bit shift through the byte and output it to the pin
    for (unsigned char j=0; j<charHeight; j++) {
      digitalWrite(LEDpins[j], !!(b & (1 << j)));

    }
    // space between columns

    delayMicroseconds(interColumnSpace);
  }
  //clear the LEDs
  for (unsigned char i = 0; i < charHeight; i++) {
    digitalWrite(LEDpins[i], LOW);   // set the LED off
  }

  // space between letters
  delayMicroseconds(interLetterSpace);

}



