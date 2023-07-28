#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t* state, unsigned int snum);
static char next_square(game_state_t* state, unsigned int snum);
static void update_tail(game_state_t* state, unsigned int snum);
static void update_head(game_state_t* state, unsigned int snum);

/* Task 1 */
game_state_t* create_default_state() {
  // TODO: Implement this function.
  game_state_t* state = malloc(sizeof(game_state_t));

  state -> num_rows = 18;
  state -> board = malloc(18 * sizeof(char*));

  int i;
  for (i = 0; i < 18; i++) {
    state -> board[i] = malloc(22 * sizeof(char));
    if (i == 0 || i == 17) {
      strcpy(state -> board[i], "####################\n");
    } else {
      strcpy(state -> board[i], "#                  #\n");
    }
  }

  state -> num_snakes = 1;
  state -> snakes = malloc(sizeof(snake_t));

  state -> snakes -> tail_row = 2;
  state -> snakes -> tail_col = 2;
  state -> snakes -> head_row = 2;
  state -> snakes -> head_col = 4;
  state -> snakes -> live = true;
  
  state -> board[2][2] = 'd';
  state -> board[2][3] = '>';
  state -> board[2][4] = 'D';
  state -> board[2][9] = '*';

  return state;
}

/* Task 2 */
void free_state(game_state_t* state) {
  // TODO: Implement this function.
  int i;
  for (i = 0; i < state -> num_rows; i++) {
    free(state -> board[i]);
  }
  free(state -> board);
  free(state -> snakes);
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  // TODO: Implement this function.
  unsigned int n = state -> num_rows, i;
  for (i = 0; i < n; i++) {
    fprintf(fp, state -> board[i]);
  }
  return;
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t* state, unsigned int row, unsigned int col) {
  return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch) {
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  return c == 'w' || c == 's' || c == 'a' || c == 'd';
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  return c == 'W' || c == 'S' || c == 'A' || c == 'D';
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  return c == '^' || c == 'v' || c == '<' || c == '>' ||
    c == 'x' || is_head(c) || is_tail(c);
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  switch(c) {
    case '^':
      return 'w';
    case 'v':
      return 's';
    case '<':
      return 'a';
    case '>':
      return 'd';
  }
  return '?';
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  // TODO: Implement this function.
  switch(c) {
    case 'W':
      return '^';
    case 'S':
      return 'v';
    case 'A':
      return '<';
    case 'D':
      return '>';
  }
  return '?';
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if (c == 'v' || c == 's' || c == 'S') {
    return cur_row + 1;
  } else if (c == '^' || c == 'w' || c == 'W') {
    return cur_row - 1;
  } else {
    return cur_row;
  }
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  if (c == '<' || c == 'a' || c == 'A') {
    return cur_col - 1;
  } else if (c == '>' || c == 'd' || c == 'D') {
    return cur_col + 1;
  } else {
    return cur_col;
  }
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t* snake = state -> snakes + snum;
  unsigned int row = snake -> head_row, col = snake -> head_col;
  char head = get_board_at(state, row, col);
  
  row = get_next_row(row, head);
  col = get_next_col(col, head);
  
  return get_board_at(state, row, col);
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t* snake = state -> snakes + snum;
  unsigned int row = snake -> head_row, col = snake -> head_col;
  char head = get_board_at(state, row, col);

  state->board[row][col] = head_to_body(head);
  
  row = get_next_row(row, head);
  col = get_next_col(col, head);

  snake -> head_row = row;
  snake -> head_col = col;
  set_board_at(state, row, col, head);
  return;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t* snake = state -> snakes + snum;
  unsigned int row = snake -> tail_row, col = snake -> tail_col;
  
  char tail = get_board_at(state, row, col);
  set_board_at(state, row, col, ' ');

  row = get_next_row(row, tail);
  col = get_next_col(col, tail);

  snake -> tail_row = row;
  snake -> tail_col = col;

  char body = get_board_at(state, row, col);
  set_board_at(state, row, col, body_to_tail(body));
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  // TODO: Implement this function.
  snake_t* snakes = state -> snakes;
  unsigned int row, col, i;

  for (i = 0; i < state -> num_snakes; i++) {
    if (snakes[i].live) {
      row = snakes[i].head_row;
      col = snakes[i].head_col;
      char* head = &(state -> board[row][col]);

      row = get_next_row(row, *head);
      col = get_next_col(col, *head);
      char next = get_board_at(state, row, col);

      if (next == '#' || is_snake(next)) {
        snakes[i].live = false;
        *head = 'x';
      } else {
        update_head(state, i);
        if (next == '*') {
          add_food(state);
        } else {
          update_tail(state, i);
        }
      }
    }
  }

  return;
}

/* Task 5 */
game_state_t* load_board(FILE* fp) {
  // TODO: Implement this function.
  game_state_t* res = malloc(sizeof(game_state_t));
  char** board = (char**)malloc(sizeof(char*));
  unsigned int num_rows = 1, num_cols = 1;
  
  char c, temp[50];
  while((c = (char)fgetc(fp)) != EOF) {
    temp[num_cols - 1] = c; 
    num_cols++;
    
    if (c == '\n') {
      temp[num_cols - 1] = '\0';

      board[num_rows - 1] = (char*)malloc(num_cols);
      strcpy(board[num_rows - 1], temp);
      
      num_cols = 1;
      num_rows++;
      
      board = (char**)realloc(board, num_rows * sizeof(char*));
    }
  }
  fclose(fp);

  num_rows--;
  board = (char**)realloc(board, num_rows * sizeof(char*));
  
  res -> board = board;
  res -> num_rows = num_rows;
  res -> num_snakes = 0;
  res -> snakes = NULL;
  
  return res;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t* snake = state -> snakes + snum;
  unsigned int row = snake -> tail_row, col = snake -> tail_col;

  char c = get_board_at(state, row, col);

  while (!is_head(c)) {
    row = get_next_row(row, c);
    col = get_next_col(col, c);
    c = get_board_at(state, row, col);
  }

  snake -> head_row = row;
  snake -> head_col = col;
  
  return;
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  // TODO: Implement this function.
  char** board = state -> board;
  snake_t* snakes = malloc(sizeof(snake_t));
  
  unsigned int num_rows = state -> num_rows, num_snakes = state -> num_snakes, i, j;

  for (i = 0; i < num_rows; i++) {
    for (j = 0; j < strlen(board[i]); j++) {
      if (is_tail(board[i][j])) {
        num_snakes++;
        snakes = realloc(snakes, num_snakes * sizeof(snake_t));
        snakes[num_snakes - 1].tail_row = i;
        snakes[num_snakes - 1].tail_col = j;
        snakes[num_snakes - 1].live = true;
      }
    }
  }

  state -> num_snakes = num_snakes;
  state -> snakes = snakes;
  for (i = 0; i < num_snakes; i++) {
    find_head(state, i);
  }

  return state;
}
