
void main() {

  background(#d9d9d9);
  pushStyle();
  imageMode(CENTER);
  textAlign(CENTER);
  image(video, width/2, height/2, (int)(video.width*((float)height/(float)video.height)), height);
  popStyle();
  pushStyle();
  noStroke();
  fill(#414141, 127);
  rect(53, 408, 219, 312);
  rect(53, 0, 219, 190);
  rect(272, 0, 52, 720);
  rect(0, 0, 53, 720);

  fill(0, 255);

  //topleft
  rect(52, 190, 41, 11);
  rect(52, 190, 11, 41);
  //topright
  rect(231, 190, 41, 11);
  rect(262, 190, 11, 41);
  //bottomleft
  rect(53, 397, 41, 11);
  rect(53, 367, 11, 41);
  //bottomright
  rect(231, 397, 41, 11);
  rect(261, 367, 11, 41);
  popStyle();
  if (state==0) {

    pushStyle();
    textAlign(CENTER);
    txtWidth = int(textWidth(latestDecodedText + " (" + barcodeFormat + ")"));
    fill(0, 150);
    rect((width>>1) - (txtWidth>>1) - 5, 15, txtWidth + 10, 36);
    fill(255, 255, 0);
    text(latestDecodedText + " (" + barcodeFormat + ")", width>>1, 43);
    popStyle();

    image(icons, 0, 0);
    if (detected) {
      TableRow place = data.findRow(latestDecodedText, "EAN");
      if (onlist&&place!=null) {
        image(frame1, 0, 0);
        pushStyle();
        fill(0);
        textAlign(LEFT, CENTER);
        text(place.getString("ProduktNavn"), 51, 441-3);
        text("EAN: "+place.getString("EAN"), 51+10, 471-5);
        text("Varighed: "+place.getString("Varighed"), 51+10, 483-5);
        popStyle();
      } else {
        image(frame2, 0, 0);
        pushStyle();
        fill(0);
        textAlign(CENTER);
        text(latestDecodedText, width/2, 474);
        popStyle();
      }
    }
  }
}













void Barkoder() {
  image(state2, 0, 0);
  pushStyle();
  rectMode(CENTER);
  for (int i = 0; i<data.getRowCount(); i++) {
    fill(255);
    rect(width/2, (100+42*i) + scroll, width-40, 40);
    TableRow row = data.getRow(i);
    println(i, row);
    fill(0);
    textAlign(LEFT, CENTER);
    text(row.getString("ProduktNavn"), 25, (100-(textAscent()/2)+42*i)+scroll);
    text(row.getString("EAN"), 25, (100+(textAscent()/2)+42*i)+scroll);
    textAlign(RIGHT, CENTER);
    text(row.getString("EAN"), width-25, (100+42*i)+scroll);
  }
  popStyle();
  image(state2.get(0, 0, state2.width, 57), 0, 0);
}
void Køleskab() {
  image(state1, 0, 0);
  pushStyle();
  rectMode(CENTER);
  for (int i = 0; i<køleskab.getRowCount(); i++) {
    TableRow row = køleskab.getRow(i);

    // Get the current date
    try {
      Calendar currentDate = Calendar.getInstance();

      // Parse the date string
      String dateString = row.getString("Købsdato");
      SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
      Calendar date = Calendar.getInstance();
      date.setTime(dateFormat.parse(dateString));

      // Add an arbitrary number of days to the date
      int daysToAdd = Integer.valueOf(row.getString("Varighed"));
      date.add(Calendar.DAY_OF_MONTH, daysToAdd);

      // Calculate the difference between the two dates in days
      long diffInMillis = date.getTimeInMillis() - currentDate.getTimeInMillis();
      long diffInDays = diffInMillis / (1000 * 60 * 60 * 24);

      // Print the difference in days
      println("Difference in days: " + diffInDays);

      if (diffInDays>=3) {
        fill(#25D87A);
      } else if (diffInDays==2) {
        fill(#E5F25D);
      } else if (diffInDays<=1) {
        fill(#E81313);
      }
    }
    catch (Exception e) {
      printStackTrace(e);
      fill(255);
    }



    rect(width/2, (100+42*i) + scroll, width-40, 40);

    fill(0);
    textAlign(LEFT, CENTER);
    text(row.getString("ProduktNavn"), 25, (100-(textAscent()/2)+42*i)+scroll);
    text(row.getString("EAN"), 25, (100+(textAscent()/2)+42*i)+scroll);
    textAlign(RIGHT, CENTER);
    text(row.getString("Mængde")+" stk", width-25, (95+42*i)+scroll);
    text(row.getString("Varighed")+" dage", width-25, (105+42*i)+scroll);
  }
  popStyle();
    image(state1.get(0, 0, state2.width, 57), 0, 0);
  }
