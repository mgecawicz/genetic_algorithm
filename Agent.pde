class Agent {
  String seed;
  int xOffset, yOffset;
  boolean isGoal = false;
  int strLen = scope;

  Agent(int x, int y) {
    xOffset = x;
    yOffset = y;
    seed = generateString();
  }

  Agent(int x, int y, boolean g) {
    xOffset = x;
    yOffset = y;
    seed = generateString();
    isGoal = g;
  }

  Agent(int x, int y, String s) {
    xOffset = x;
    yOffset = y;
    seed = s;
  }

  String getSeed() {
    return seed;
  }

  float getFitnessScore() {
    if (seed.length() != goal.seed.length()) {
      throw new IllegalArgumentException("Input strings must have equal length");
    }

    int length = seed.length() / 2;
    int commonPairs = 0;

    for (int i = 0; i < length; i++) {
      String pair1 = seed.substring(2 * i, 2 * i + 2);
      String pair2 = goal.seed.substring(2 * i, 2 * i + 2);

      if (pair1.equals(pair2)) {
        commonPairs++;
      }
    }

    float similarity = (float) commonPairs / length;

    return similarity;
  }

  void mutateDNA() {
    char[] dnaArray = this.seed.toCharArray();

    int mutationPoint = (int) (Math.random() * dnaArray.length);

    dnaArray[mutationPoint] = mutateCharacter(dnaArray[mutationPoint]);

    this.setSeed(new String(dnaArray));
  }

  void setSeed(String s) {
    seed = s;
  }

  char mutateCharacter(char cToChange) {
    char[] possibleCharacters = {};
    char[] nums = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};
    char[] cs = {'a', 'b', 'c', 'd', 'e', 'f'};
    for (int i = 0; i < nums.length; i++) {
      if (cToChange == nums[i]) {
        possibleCharacters = nums;
      }
    }
    for (int i = 0; i < cs.length; i++) {
      if (cToChange == cs[i]) {
        possibleCharacters = cs;
      }
    }
    if (possibleCharacters.length == 0) {
      return cToChange;
    }
    int randomIndex = (int) (Math.random() * possibleCharacters.length);
    return possibleCharacters[randomIndex];
  }

  String generateString() {
    String output = "";
    for (int i = 0; i < strLen; i++) {
      int c = floor(random(10, 16));
      output += letterSet[c];
      output += letterSet[floor(random(0, 9))];
      output += ",";
    }
    return output;
  }

  void regenerateSeed() {
    seed = generateString();
  }

  void show() {
    String[] features = split(seed, ',');
    for (int i = 0; i < strLen/2; i++) {
      showFeature(features[i], i);
    }
  }

  int convertStringToInteger(String input) {

    try {
      // Use SHA-256 hash function
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));

      // Convert the hash to a decimal integer
      long decimalValue = bytesToLong(hashBytes);

      int mappedValue = (int) map((decimalValue % 81), -100, 100, -40, 40);


      return mappedValue;
    }
    catch (Exception e) {
      e.printStackTrace();
      return 0;
    }
  }

  long bytesToLong(byte[] bytes) {
    long value = 0;
    for (int i = 0; i < bytes.length; i++) {
      value = (value << 8) | (bytes[i] & 0xFF);
    }
    return value;
  }
  void showFeature(String sub, int index) {
    try {
      int shape = int(map(int(sub.charAt(0)), 95, 103, 5, 20));
      int col = int(map(int(sub.charAt(1)), 50, 60, 5, 20));
      PVector topRight = new PVector((index*10)+xOffset+10, yOffset-(shape*col));
      PVector topLeft = new PVector((index*10)+xOffset, yOffset-(shape*col));
      PVector bottomRight = new PVector((index*10)+xOffset+10, yOffset);
      PVector bottomLeft = new PVector((index*10)+xOffset, yOffset);
      if (isGoal) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      quad(topLeft.x, topLeft.y, topRight.x, topRight.y, bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}
