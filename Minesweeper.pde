import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private int NUM_ROWS = 20;
private int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private int NUM_BOMBS = 100;
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup () {
    size(400, 400);
    textAlign(CENTER,CENTER);
    
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
    background( 0 );
    if(isWon()) {
        displayWinningMessage();
    }
}

public boolean isWon() {
    //your code here
    return false;
}

public void displayLosingMessage() {
    //your code here
}

public void displayWinningMessage() {
    //your code here
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
        marked = clicked = false;
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
        clicked = true;
        if (keyPressed) {
            marked = !marked;
        } else if (bombs.contains(this)) {
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

    public void draw () {    
        if (marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(255, 0, 0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(label, x+width/2, y+height/2);
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
}