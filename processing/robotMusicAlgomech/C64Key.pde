class C64Key {
  public float x, y, z;
  public float screenX, screenY;
  public String keyName;
  public int asciiKeyCode;
  public C64Key (String theKeyName, float theX, float theY, float theZ, float theScreenX, float theScreenY, int theAsciiKeyCode) {
    keyName = theKeyName;
    x = theX;
    y = theY;
    z = theZ;
    screenX = theScreenX;
    screenY = theScreenY;
    asciiKeyCode = theAsciiKeyCode;
  }
}

void createKeys() {
  String line1;
  try {
    line1 = reader1.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line1 = null;
  }
  String[] linePieces = split(line1, ',');
  println("key screen coords: "+linePieces.length);
  for (int i = 0; i<linePieces.length; i++) {
    keyScreenCoordinates[i] = int(linePieces[i]);
  }

  String line2;
  int k = 0;

  try {
    line2 = reader2.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line2 = null;
  }
  int s = 0;
  String[] linePieces2 = split(line2, ',');
  for (int i = 0; i<linePieces2.length; i++) {
    keyNames[k] = linePieces2[i];
    println("key nr: "+k+" has name "+keyNames[k]);
    k++;
  }  

  String line3;

  try {
    line3 = reader3.readLine();
  } 
  catch (IOException e) {
    e.printStackTrace();
    line3 = null;
  }
  String[] linePieces3 = split(line3, ',');
  for (int i = 0; i<linePieces3.length; i++) {
    keyboardCoordinates[i] = float(linePieces3[i]);
  }

  for (int i = 0; i<keyNames.length; i++) {
    keys.add(new C64Key(keyNames[i], keyboardCoordinates[i*3], keyboardCoordinates[i*3+1], keyboardCoordinates[i*3+2], keyScreenCoordinates[i*2], keyScreenCoordinates[i*2+1], 1));
  }
}