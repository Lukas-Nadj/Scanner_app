void setter() {
  video = new Capture(this);
  video.start();
  zxing4p = new ZXING4P();

  // DISPLAY VERSION INFORMATION
  zxing4p.version();
  scanArea = new PImage(231-52, 397-198);
  // UPPER LEFT CORNER OF THE VIEW FINDER
  ul = new PVector((width - frameWidth) >> 1, (height - frameHeight) >> 1);
  // UPPER RIGHT CORNER OF THE VIEW FINDER
  ur = new PVector(ul.x + frameWidth, ul.y);
  // LOWER LEFT CORNER OF THE VIEW FINDER
  ll = new PVector(ul.x, ul.y + frameHeight);
  // LOWER RIGHT CORNER OF THE VIEW FINDER
  lr = new PVector(ur.x, ur.y + frameHeight);

  try {
    data = loadTable("data.csv", "header");
  }
  catch(Exception e) {
    data = new Table();
    data.addColumn("EAN");
    data.addColumn("ProduktNavn");
    data.addColumn("Varighed");
    data.addColumn("Købsdato");
    data.addColumn("Mængde");
  }
  if (data==null) {
    data = new Table();
    data.addColumn("EAN");
    data.addColumn("ProduktNavn");
    data.addColumn("Varighed");
    data.addColumn("Købsdato");
    data.addColumn("Mængde");
  }

  try {
    køleskab = loadTable("data.csv", "header");
  }
  catch(Exception e) {
    køleskab = new Table();
    køleskab.addColumn("EAN");
    køleskab.addColumn("ProduktNavn");
    køleskab.addColumn("Varighed");
    køleskab.addColumn("Købsdato");
    køleskab.addColumn("Mængde");
  }
  if (køleskab==null) {
    køleskab = new Table();
    køleskab.addColumn("EAN");
    køleskab.addColumn("ProduktNavn");
    køleskab.addColumn("Varighed");
    køleskab.addColumn("Købsdato");
    køleskab.addColumn("Mængde");
  }


  barcodeTypes.add("EAN_13");
  barcodeTypes.add("EAN_8");

  thread("scan");
  frame1 = loadImage("Frame 1.png");
  frame2 = loadImage("Frame 2.png");
  icons = loadImage("icons.png");
  state1 = loadImage("Frame 3.png");
  state2 = loadImage("Frame 4.png");
  addnew = loadImage("ADD.png");
  saveTable(data, "data/data.csv");
}

void captureEvent(Capture video) {
  if (!detected) {
    video.read();
  }
}
void mousePressed() {
  println(mouseX, mouseY);
  if (state==1) {
    for (int i = 0; i<køleskab.getRowCount(); i++) {
      if (mouseY>(83+42*i)+scroll&&mouseY<(83+42*i)+40+scroll&&mouseX>21&&mouseX<305) {
        TableRow a = køleskab.getRow(i);
        int count = a.getInt("Mængde");
        if (count==0) {
          køleskab.removeRow(i);
        } else {
          a.setInt("Mængde", count-1);
        }
      }
      rect(width/2, (100+42*i) + scroll, width-40, 40);
    }
    saveTable(køleskab, "data/køleskab.csv");
  } else if (state==2) {
    for (int i = 0; i<data.getRowCount(); i++) {
      if (mouseY>(83+42*i)+scroll&&mouseY<(83+42*i)+40+scroll&&mouseX>21&&mouseX<305) {
        TableRow a = data.getRow(i);
        int count = a.getInt("Mængde");
        if (count==0) {
          data.removeRow(i);
        } else {
          a.setInt("Mængde", count-1);
        }
      }
    }
    saveTable(data, "data/data.csv");
  }
  if (add) {

    if ((mouseX>17&&mouseX<307&&mouseY>253&&mouseY<471)) {
      if (mouseX>24&&mouseX<302&&mouseY>261&&mouseY<284) {
        selected = 0;
      }
      if (mouseX>24&&mouseX<167&&mouseY>289&&mouseY<313) {
        selected = 1;
      }
      if (mouseX>24&&mouseX<167&&mouseY>321&&mouseY<344) {
        selected = 2;
      }

      if (mouseX>247&&mouseX<300&&mouseY>362&&mouseY<385) {
        TableRow place = data.findRow(latestDecodedText, "EAN");
        tEAN = latestDecodedText;
        if (state==2) {
          if (place==null) {
            place = data.addRow();
          }
          place.setString("EAN", tEAN);
          place.setString("ProduktNavn", tNavn);
          place.setString("Varighed", tbestby);
          saveTable(data, "data/data.csv");
        }
        if (state==1) { //køleskab
          TableRow bruh = køleskab.findRow(tEAN, "EAN");
          if (bruh!=null) {
            bruh.setInt("Mængde", bruh.getInt("Mængde")+1);
            bruh.setString("EAN", tEAN);
            bruh.setString("ProduktNavn", tNavn);
            bruh.setString("Varighed", tbestby);
            String year = nf(year(), 4);
            String month = nf(month(), 2);
            String day = nf(day(), 2);
            String dateString = day + "-" + month + "-" + year;

            bruh.setString("Købsdato", dateString);
            saveTable(køleskab, "data/køleskab.csv");
          } else {
            bruh = køleskab.addRow();
            bruh.setString("EAN", tEAN);
            bruh.setString("ProduktNavn", tNavn);
            bruh.setString("Varighed", tbestby);
            bruh.setInt("Mængde", 1);
            String year = nf(year(), 4);
            String month = nf(month(), 2);
            String day = nf(day(), 2);
            String dateString = day + "-" + month + "-" + year;

            bruh.setString("Købsdato", dateString);
            saveTable(køleskab, "data/køleskab.csv");
          }
        }
      }
    } else {
      add = false;
    }
    return;
  }

  if (dist(241, 691, mouseX, mouseY)<21) { //knap 1
    if (state==0) { //knap 1, state 0
      state = 1;
    } else if (state == 1) {
      state = 2;
      //Choose one.
      //then copy that one to fridge
    } else if (state==2) { //knap 1, state 1, eller 2
      add = true;
    }
    return;
  } else if (dist(295, 691, mouseX, mouseY)<21) {  //knap 2
    if (state==0) { //knap 2, state 0
      state = 2;
    } else if (state==1||state==2) { //knap 2, state 1, eller 2
      state= 0;
    }
    return;
  }

  //resume
  video.read();




  println(detected);

  if (detected&&!latestDecodedText.equals("")) {
    /*if (!latestDecodedText.equals(prev)) {
     prev = latestDecodedText;
     detected = true;
     }*/
    TableRow place = data.findRow(latestDecodedText, "EAN");
    if (place==null) {
      println("WE DONT KNOW THIS ONE");
      onlist = false;
      detected = true;

      //add = true;
      tEAN = latestDecodedText;
      //place.setString("EAN", latestDecodedText);
      //place.setString("ProduktNavn", "Place Holder");
      //saveTable(data, "data/data.csv");
    } else {
      onlist = true;
      detected = true;
      tEAN = latestDecodedText;
      tNavn = place.getString("ProduktNavn");
      tbestby = place.getString("Varighed");
      println("WE DOOOOO");
    }
  }

  if (detected) {
    scanArea = createImage(220-52, 218-190, RGB);
    detected = false;
    if (!onlist&&mouseX>63&&mouseX<266&&mouseY>430&&mouseY<461 ||mouseX>78&&mouseX<249&&mouseY>456&&mouseY<490) {
      state = 2;
      add = true;
    } else if (onlist&&dist(mouseX, mouseY, 262, 526)<=11) {
      state = 1;
      add = true;
    }
  } else {
    scanArea = get(52, 190, 220, 218);
  }
  delay(200);

  if (detected) {
    detected = false;
    return;
  }
}


//------------------------------------typing------------------------------------
void keyPressed() {
  if (selected==0) {
    tEAN = type(tEAN, key);
  } else if (selected==1) {
    tNavn = type(tNavn, key);
  } else if (selected==2) {
    tbestby = type(tbestby, key);
  }
}

String type(String edit, char Key) {
  if ((Key >= '!' && Key <= 'z'|| Key == ' '||Key >= 128 && Key <= 255)) {  // 12865
    edit = edit + Key;
    // lånt kode slutter
  } else if (Key==BACKSPACE) {  //   opsummering: delete key
    try {
      edit = edit.substring(0, edit.length()-1);
    }
    catch(StringIndexOutOfBoundsException e) {
    }
  } else if (Key==ENTER&&!(selected<=2)) {
    selected++;
  }
  return edit;
}



void mouseWheel(MouseEvent event) {
  if (state!=0) {
    scroll = constrain(scroll-event.getCount(), -10000, 0);
    println(scroll, event.getCount());
  }
}
