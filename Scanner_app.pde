import processing.video.*;
import java.util.Date;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.concurrent.TimeUnit;

Capture video;
String prev = "";
Float scale = 0.3;
int scroll = 0;
PImage frame1, frame2, icons, state1, state2, addnew;

//Main
Boolean detected = false;
Boolean onlist = true;
Boolean choose = false;

//tilføj ny
Boolean add = false;
String tEAN = "";
String tNavn = "";
String tbestby = "";
Byte selected = -1;

Byte state = 0; //0 er kamera, 1 er køleskab, 2 er barkoder

Table data, køleskab;

//Fridge/Køleskab

void setup() {
  //1080, 2400
  size(324, 720);
  setter();
}


void draw(){

     if(state==0){ //kamera
        main();
     } else if(state == 1){ // køleskab
       Køleskab();
     } else { //barkoder
       Barkoder();
     }
   if (add) {
    pushStyle();
    imageMode(CENTER);
    image(addnew, width/2, height/2);
    noStroke();
    fill(255);
    if (!tEAN.equals("")) {
      rect(width/2-109, height/2-97, 115, 15);
    }
    textAlign(LEFT, CENTER);
    fill(0);
    text(tEAN, 53, 271-4);
    text(tNavn, 92, 301-4);
    text(tbestby, 62, 332-4);
    popStyle();
  }

}
