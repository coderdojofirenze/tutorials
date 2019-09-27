// The aim of this game is that the user guesses the sum of two numbers that appear in
// two bubbles that slowly go down the screen. If they give the right answer the count of
// right answers increases by 1. If they are wrong, the right asnwer is shown to the user.
// In both cases a new set of bubbles will appear on the top of the screen.
// The game ends when the user does not manage to give an answer and the bubbles reach the bottom of the screen.
// At game end the total number of correct answers are given.
//
// This is a simple first program for the game. It can be changed and perfected in many ways,
// the game can be improved in different ways. Check the tutorial for some suggestions for improvements
// and added complications.


import processing.serial.*; // we need this to put some delays in the game

// variables for positioning the bubbles
float circleY = 25;
float circleX1 = 50;
float circleX2 = 150;

// the values in the bubbles and their sum
int num1 = int(random(100));
int num2 = int(random(100));
int realSum = num1 + num2;

// for keeping track of the answers given by the user
int count = 0;   // count of correct answers
int total = 0;   // total additions in the game

String solution = "";   // used to store user input - the sum of the two numbers - in type String
int numSolution;        // integer version of the user input

int state = 0;       // state of the game:
                     // 0: a new set of numbers appear in the bubbles
                     // 1: correct sum is given by the user
                     // 2: wrong sum is given by the user
                     // 3: bubbles have reached the bottom of the screen without an answer from the user

String message1 = "", message2 = "";   // messages to be displayed to the user
                                       // message1: when state = 0 or 1, appears in the lower text box
                                       // message2: when state = 2 or 3, appears in the upper text box

void setup(){
  size(600, 400);
}

void draw(){  
  background(200);    // grey
  
  if (state == 1 || state == 2) {   // a right or wrong answer has been given by the user
    delay(2000);
    state = 0;
  }
  fill(255, 10, 10); // green; can be changed with any color
  rect(300, 250, 300, 30);
  myTextBox();
  
  fill(0, 255, 0); // green
  ellipse(circleX1, circleY, 20, 20); 
  fill(0, 0, 0); // black
  text(num1, circleX1-7, circleY+5);
  fill(0, 255, 0);
  ellipse(circleX2, circleY, 20, 20);
  fill(0, 0, 0);
  text(num2, circleX2-7, circleY+5);
  circleY = circleY + 1;
  if (circleY > height && (key != RETURN || key != ENTER)) {  // bubbles arrive at the bottom
    state = 3;
    myTextBox();
    noLoop();     // stop the draw loop
  }
}

void myTextBox() { // to communicate with the user
  
  switch(state) {
    case 0: // game start; a new set of numbers
      fill(255); // white; can be changed with any color
      rect(300, 350, 300, 30);
      fill(0);
      message1 = "What is the sum of these numbers?\n";
      text(message1+solution, 310, 365);
      break;
    case 1: // correct solution
      fill(255, 20, 20); // red; can be changed with any color
      rect(300, 250, 300, 30);
      fill(0);
      message2 = "Correct! \n ";
      text(message2+solution, 310, 265);
      break;
    case 2: // wrong solution
      fill(255, 20, 20); // red
      rect(300, 250, 300, 30);
      fill(0);
      message2 = "Wrong answer! It was \n";
      text(message2+realSum, 310, 265);
      break;
    case 3: // bubbles out of screen, no answer, game over
      fill(255);  // white
      rect(300, 350, 300, 30);
      fill(0);
      message1 = "Time out! Game over with "+count+"\ncorrect answers out of "+total;
      text(message1, 310, 365);
  }  
}

// we should listen for input from the user
void keyPressed()
{
  if (key == RETURN || key == ENTER) {  // user input is finished; check if the result is correct
    numSolution = int(solution);        // get the integer value of the user input
    total++;                            // increase the number of total answers given by the user by 1
    if (numSolution == realSum) { // correct answer
      state = 1;
      count++;                    // increase the number of correct answers by 1
      myTextBox();
      
      // restart the game with new numbers
      num1 = int(random(100));
      num2 = int(random(100));
      realSum = num1 + num2;
      solution = "";              // initialize the variable for keeping keys pressed to empty
      circleY = 25;
      return;
    } else { // wrong answer 
        state = 2;
        myTextBox();
        // restart the game with new numbers
        num1 = int(random(100));
        num2 = int(random(100));
        realSum = num1 + num2;
        solution = "";
        circleY = 25;
        return;
    }
  }
  else if (key >= '0' && key <= '9')  // user continues writing
  {  
    solution = solution + key;        // add the lates key pressed to the string of keys pressed
  }
}
