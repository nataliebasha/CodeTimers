
// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;


int switchValue = 0;
int potValue = 0;
int ldrValue=0;
color [] colorarray= {#ED1616, #CD5C5C, #EDD516, #A5621F, #F66140};
int backgroundColor= 2;

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;
//int minSpeed = 0;
//int maxSpeed = 50;

//timer for the background color
Timer displayTimer;
Timer anotherTimer; 
float timePerColor=0;
float minTimePerColor= 100;
float maxTimePerColor= 1000;
int defaultTimePerColor=1500;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

PImage naruto;
PFont displayFont;
float narutoX;
float narutoY;


void setup  () {
  size (1000,  600);    

  // List all the available serial ports
  printArray(Serial.list());
    
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  
  // Allocate the timer
  displayTimer = new Timer(defaultTimePerColor);
  anotherTimer = new Timer(1000); 

  
  // start the timer. Every 1/2 second, it will do something
  displayTimer.start();
  anotherTimer.start(); 
  
  naruto = loadImage("naruto.jpg"); 
  
  textAlign(CENTER); 
  displayFont = createFont("Georgia", 80); 
  
  
} 

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
      
      // change the display timer
      timePerColor= map(potValue, maxPotValue, minPotValue, minTimePerColor, maxTimePerColor);
      displayTimer.setTimer(int(timePerColor));
   }
  }
} 


void draw(){
  checkSerial(); 
  drawBackground();
  checkTimer(); 
 // Naruto(); 
  drawNaruto();
 // drawSlideshow();
  //startSlideshow();
}
void drawBackground() {
  background(colorarray[backgroundColor]);
  text("Press 'N' to See Naruto!", width/2, 90);
}

/*void Naruto() {
      narutoX = random(width);
      narutoY = random(height);
}*/

void drawNaruto() {
  if (keyPressed) {
    if (key == 'n' || key == 'N') {
      
       image(naruto, width/2,height/2-100); 
    }
  }
}



void checkTimer() {
  
 // check to see if timer is expired, do something and then restart timer
  if( displayTimer.expired() ) {
     backgroundColor++;
    
   if (backgroundColor == colorarray.length ) {
     backgroundColor = 0; 
    
    
     displayTimer.start();
  }
  
  if ( anotherTimer.expired() ) {
    

  //  naruto = img; 
    
    anotherTimer.start();   
  }
  }
}
