# Genetic Algorithm in Processing

This project implements a simple genetic algorithm using the Processing framework.

## Overview

The genetic algorithm is a method inspired by natural selection to evolve solutions for optimization and search problems. This implementation uses a basic genetic algorithm to evolve a population of agents.

## How to Run

1. Make sure you have [Processing](https://processing.org/download/) installed on your machine.

2. Clone this repository:

    ```bash
    git clone git@github.com:mgecawicz/genetic_algorithm.git
    ```

3. Open the main Processing sketch file:

    ```
    genetic_algorithm/Genetic_Algorithm.pde
    ```

4. Click the "Run" button in the Processing IDE to execute the genetic algorithm.

## How to Build for Mac and Windows

If you want to export the project as a standalone application for Mac and Windows, follow these steps:

### For Mac:

1. Open the Processing IDE and open the main sketch file.

2. Click on `File -> Export Application`.

3. Choose `Application` for the mode.

4. Select your desired options and click `Export`.

5. This will create a standalone application in the selected directory.

### For Windows:

1. Open the Processing IDE and open the main sketch file.

2. Click on `File -> Export Application`.

3. Choose `Application` for the mode.

4. Select your desired options and click `Export`.

5. This will create a standalone application in the selected directory.

## Configuration

You can configure the genetic algorithm parameters such as population size, litter size and hash size.

```java
// Example configuration in Genetic_Algorithm.pde

int hashSize = 64;
int litterSize = 5;
int populationSize = 10000;

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
  for (int i = 0; i < populationSize; i++) {
    population.add(new Agent(0, 0));
  }
}
