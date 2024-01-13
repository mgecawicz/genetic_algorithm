ArrayList<Agent> population = new ArrayList<Agent>();
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

int scope = 64;

PFont mono;
int gen = 1;
int litterSize = 5;

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

void graphIt(float best) {
  pushMatrix();
  translate(100, 100);
  noFill();
  stroke(255);
  strokeWeight(2);
  line(0, 0, 0, 200);
  line(0, 200, 1200, 200);
  for (pt p : points) {
    p.show();
  }
  points.add(new pt(gen*2, 200-(best*200)));
  text(best, gen*2, 200-(best*200));
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
    for (int j = 0; j < litterSize; j++) {
      nextPop.add(combineDNA(children.get(floor(random(children.size()))), children.get(floor(random(children.size())))));
    }
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
