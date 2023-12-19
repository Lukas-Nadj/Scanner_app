
import com.cage.zxing4p3.*;
ZXING4P zxing4p;

// PIMAGE WITH THE BARCODES TO DETECT
PImage scanArea;
Boolean bool = true; //only run once
// TEXT THAT WAS FOUND
String decodedText;
String latestDecodedText = "";
// FORMAT OF THE LATEST FOUND BARCODE
String barcodeFormat = "";
int    txtWidth;
// FOR THE VIEW FINDER AND SCAN AREA
int    frameWidth  = 400;
int    frameHeight = 400;
int    lineSize    = 40;
// CORNERS OF THE VIEW FINDER
PVector ul, ur, ll, lr;
// LIST WITH BARCODE TYPES TO LOOK FOR
ArrayList<String> barcodeTypes = new ArrayList<String>();

void scan() {
  while(true){
    try{
    
    //scanArea.copy(video, 52, 190, 231, 397);
    } catch(Exception e){
    printStackTrace(e);
    }
    try {
      // SCAN FOR ALL AVAILABLE BARCODE TYPES
      //decodedText = zxing4p.barcodeReader(scanArea, false);

      // SCAN FOR SPECIFIC BARCODE TYPES
      decodedText   = zxing4p.barcodeReader(scanArea, true, barcodeTypes);

      // GET THE TYPE OF THE LAST SCANNED BARCODE
      barcodeFormat = zxing4p.getBarcodeFormat();
    }
    catch (Exception e) {
      // NOT FOUND
      printStackTrace(e);
      decodedText = "";
    } 

    if (!decodedText.equals("")) {
      // FOUND A BARCODE!
      detected = true;
      if (latestDecodedText.equals("") || (!latestDecodedText.equals(decodedText))) {

        if (latestDecodedText.equals("") || (!latestDecodedText.equals(decodedText))) {

            println(validate(decodedText), "Zxing4processing detected: " + decodedText + " (" + barcodeFormat + ")");

        }
      }
      if(validate(decodedText)){
      latestDecodedText = decodedText;
      }
    } 
  }
}

boolean validate(String ean) {
    if (ean == null || (ean.length() != 13 && ean.length() != 8)) {
        return false; // EAN-13 codes must have 13 digits, EAN-8 codes must have 8 digit
    }
    int sum = 0;
    int factor = 3;
    for (int i = ean.length() - 2; i >= 0; i--) {
        int digit = Integer.parseInt(String.valueOf(ean.charAt(i)));
        sum += digit * factor;
        factor = 4 - factor;
    }
    int checkDigit = Integer.parseInt(String.valueOf(ean.charAt(ean.length() - 1)));
    int expectedCheckDigit = (10 - (sum % 10)) % 10;
    return checkDigit == expectedCheckDigit;
}
