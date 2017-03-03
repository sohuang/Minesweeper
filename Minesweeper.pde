import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private int NUM_BOMBS = 100;
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
private boolean isGameEnded;

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);
  colorMode(HSB);
  isGameEnded = false;

  // make the manager
  Interactive.make( this );

  //your code to declare and initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j] = new MSButton(i, j);
    }
  }

  bombs = new ArrayList<MSButton>();

  setBombs();
}

public void setBombs() {
  for (int i = 0; i < NUM_BOMBS; i++) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!bombs.contains(buttons[r][c])) {
      bombs.add(buttons[r][c]);
    }
  }
}

public void draw () {
  background(0);
  if (isWon()) {
    displayWinningMessage();
  }
  if (key == 'l') {
    displayLosingMessage();
  }
}

public boolean isWon() {
  int count = 0;
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (buttons[i][j].isClicked()) {
        count++;
      }
    }
  }
  if (count == NUM_ROWS * NUM_COLS - NUM_BOMBS || key == 'w') {
    displayWinningMessage();
    return true;
  }
  return false;
}

public void displayLosingMessage() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (bombs.contains(buttons[i][j])) {
        buttons[i][j].setClicked(true);
      } else {
        buttons[i][j].drawLose();
      }
    }
  }
  isGameEnded = true;
}

public void displayWinningMessage() {
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (bombs.contains(buttons[i][j])) {
        buttons[i][j].setClicked(true);
      } else {
        buttons[i][j].drawWin();
      }
    }
  }
  isGameEnded = true;
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked;
    Interactive.add( this ); // register it with the manager
  }

  public boolean isMarked() {
    return marked;
  }

  public boolean isClicked() {
    return clicked;
  }
  // called by manager

  public void mousePressed() {
    if (!isGameEnded) {
      if (mouseButton == LEFT) {
        if (clicked == false) {
          clicked = !clicked;
        }
        if (bombs.contains(this)) {
          displayLosingMessage();
        } else if (countBombs(r, c) > 0) {
          label = "" + countBombs(r, c);
        } else {
          for (int i = r - 1; i <= r + 1; i++) {
            for (int j = c - 1; j <= c + 1; j++) {
              if (isValid(i, j) && !buttons[i][j].isClicked()) {
                buttons[i][j].mousePressed();
              }
            }
          }
        }
      }

      if (mouseButton == RIGHT && clicked == false) {
        marked = !marked;
      }
    }
  }

  public void draw () {
    if (isGameEnded) {
      if (isWon()) {
        drawWin();
      } else {
        drawLose();
      }
    } else {
      if (marked) {
        fill(0);
      } else if (clicked && bombs.contains(this))
        fill(0, 225, 255);
      else if (clicked)
        fill(200);
      else
        fill(100);
    }

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }

  public void drawWin() {
    setLabel("");
    float h = map(r + c, 0, NUM_ROWS + NUM_COLS - 2, 0, 255);
    if (bombs.contains(this)) {
      float s = 0;
      s += 0.05 * frameCount;
      fill(h, map(noise(s, r, c), 0, 1, 0, 100), 255);
    } else {            
      fill(h, 200, 255);
    }
  }

  public void drawLose() {
    setLabel("");
    if (bombs.contains(this)) {
      fill(0, 225, 255);
    } else {
      fill(0, 0, 100);
    }
  }

  public void setLabel(String newLabel) {
    label = newLabel;
  }

  public boolean isValid(int r, int c) {
    return (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0);
  }

  public int countBombs(int row, int col) {
    int numBombs = 0;
    for (int i = row - 1; i <= row + 1; i++) {
      for (int j = col - 1; j <= col + 1; j++) {
        if (isValid(i, j)) {
          if (bombs.contains(buttons[i][j])) {
            numBombs += 1;
          }
        }
      }
    }
    return numBombs;
  }

  public void setClicked(boolean what) {
    clicked = what;
  }
}