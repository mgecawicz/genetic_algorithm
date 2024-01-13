ArrayList<Agent> population = new ArrayList<Agent>();
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

int scope = 64;

class pt{
  float x; 
  float y;
  pt(float _x, float _y){
    x = _x; 
    y = _y;
  }
  void show(){
    stroke(255,0,0);
    strokeWeight(2);
    point(x,y);
  }
  
}

PFont mono;
int gen = 1;

ArrayList<pt> points = new ArrayList<pt>();

char letterSet[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
Agent tester;
Agent goal;
Agent best;
void setup() {
  fullScreen();
  mono = createFont("helvetica.tcc", 12);
  goal = new Agent(80, height-200, true);
  for (int i = 0; i < 10000; i++) {
    population.add(new Agent(0, 0));
  }
}

void graphIt(float best){
  pushMatrix();
  translate(100,100);
  noFill();
  stroke(255);
  strokeWeight(2);
  line(0,0,0,200);
  line(0,200,1200,200);
  for (pt p : points){
    p.show();
  }
  points.add(new pt(gen*2, 200-(best*200)));
  text(best,gen*2, 200-(best*200));
  popMatrix();
  noStroke();
}

void draw() {
  List<Agent> children = new ArrayList<Agent>();
  ArrayList<Agent> nextPop = new ArrayList<Agent>();
  background(20);
  goal.show();
  children = sortEm();
  if (children.get(0).getFitnessScore() == 1.0) {
    println("COMPLETE");
    stop();
  }
  children.get(0).xOffset = 80;
  children.get(0).yOffset = height-200;
  children.get(0).show();
  for (int i = 0; i < children.size()-1; i++) {
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
  }
  gen++;
  fill(255);
  textFont(mono);
  text("Goal Hash:", 40, height-70);
  text("Best Hash:", 40, height-50);
  text("Best Fitness:", 40, height-20);
  text(goal.seed.toUpperCase(), 180, height-70);
  text(children.get(0).seed.toUpperCase(), 180, height-50);
  text(children.get(0).getFitnessScore(), 180, height-20);
  graphIt(children.get(0).getFitnessScore());
  population.clear();
  population = nextPop;
}

List<Agent> sortEm() {
  Collections.sort(population, Comparator.comparing(Agent::getFitnessScore).reversed());

  int topCount = Math.min(200, population.size());
  return population.subList(0, topCount);
}


Agent combineDNA(Agent parent1, Agent parent2) {
  if (parent1.getSeed().length() != parent2.getSeed().length()) {
    throw new IllegalArgumentException("DNA lengths must be equal");
  }

  String dna1 = parent1.getSeed();
  String dna2 = parent2.getSeed();
  int length = dna1.length();

  int crossoverPoint = (int) (Math.random() * length);

  String combinedDNA = dna1.substring(0, crossoverPoint) + dna2.substring(crossoverPoint);

  Agent child = new Agent(parent1.xOffset, parent1.yOffset, combinedDNA);
  child.mutateDNA();
  return child;
}


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
      showFeature(features[i],i);
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
      int shape = int(map(int(sub.charAt(0)),95,103,5,20));
      int col = int(map(int(sub.charAt(1)),50,60,5,20));
      PVector topRight = new PVector((index*10)+xOffset+10,yOffset-(shape*col));
      PVector topLeft = new PVector((index*10)+xOffset,yOffset-(shape*col));
      PVector bottomRight = new PVector((index*10)+xOffset+10,yOffset);
      PVector bottomLeft = new PVector((index*10)+xOffset,yOffset);
      if (isGoal){
        fill(255,0,0);

      } else {
        fill(255);
      }
      quad(topLeft.x,topLeft.y, topRight.x, topRight.y, bottomRight.x, bottomRight.y, bottomLeft.x, bottomLeft.y);
    }
    catch (Exception e) {
    }
  }
}
