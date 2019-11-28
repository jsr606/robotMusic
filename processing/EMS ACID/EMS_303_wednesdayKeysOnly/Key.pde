class Key {
  public float x, y, z;
  public float screenX, screenY;
  public String keyName;
  public int id, zone;
  public float push;
  public Key (int theID, String theKeyName, float theX, float theY, float theZ, int theZone, float thePush) {
    keyName = theKeyName;
    x = theX;
    y = theY;
    z = theZ;
    id = theID;
    zone = theZone;
    push = thePush;
  }
}

void createKeys() {

  for (int i = 0; i<amountOfKeys; i++) {
    JSONObject k = keyData.getJSONObject(i);
    println(i+": key id:"+k.getInt("id")+" name "+k.getString("name")+" x "+k.getFloat("x")+" y "+k.getFloat("y")+ " z "+k.getFloat("z"));
    keys[i] = new Key(k.getInt("id"), k.getString("name"), k.getFloat("x"), k.getFloat("y"), k.getFloat("z"), k.getInt("zone"), k.getFloat("push"));
  }
}

void checkKeys() {
  for (int i = 0; i<keys.length; i++) {
    Key k = (Key) keys[i];
    println(i+": key id: "+k.id+" name "+k.keyName+" x "+k.x+" y "+k.y+ " z "+k.z+" zone "+k.zone);
  }
}
