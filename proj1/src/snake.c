#include <stdio.h>
#include <string.h>
#include <stdlib.h>  

#include "snake_utils.h"
#include "state.h"

int main(int argc, char* argv[]) {
  bool io_stdin = false;
  char* in_filename = NULL;
  char* out_filename = NULL;
  game_state_t* state = NULL;

  // Parse arguments
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-i") == 0 && i < argc - 1) {
      if (io_stdin) {
        fprintf(stderr, "Usage: %s [-i filename | --stdin] [-o filename]\n", argv[0]);
        return 1;
      }
      in_filename = argv[i + 1];
      i++;
      continue;
    } else if (strcmp(argv[i], "--stdin") == 0) {
      if (in_filename != NULL) {
        fprintf(stderr, "Usage: %s [-i filename | --stdin] [-o filename]\n", argv[0]);
        return 1;
      }
      io_stdin = true;
      continue;
    }
    if (strcmp(argv[i], "-o") == 0 && i < argc - 1) {
      out_filename = argv[i + 1];
      i++;
      continue;
    }
    fprintf(stderr, "Usage: %s [-i filename | --stdin] [-o filename]\n", argv[0]);
    return 1;
  }

  // Do not modify anything above this line.

  /* Task 7 */

  // Read board from file, or create default board
  if (in_filename != NULL) {
    // TODO: Load the board from in_filename
    // TODO: If the file doesn't exist, return -1
    // TODO: Then call initialize_snakes on the state you made
    FILE* fp;
    fp = fopen(in_filename, "r");
    if (!fp) {
      return -1;
    } 
    state = load_board(fp);
    initialize_snakes(state);
  } else if (io_stdin) {
    // TODO: Load the board from stdin
    // TODO: Then call initialize_snakes on the state you made
    // char** board = (char**)malloc(sizeof(char*));

    // char c, temp[50];
    // unsigned int num_rows = 1, num_cols = 1;

    // while ((c = getchar()) != EOF) {
    //   temp[num_cols - 1] = c;
    //   num_cols++;
      
    //   if (c == '\n') {
    //     temp[num_cols - 1] = '\0';
    //     board[num_rows - 1] = (char*)malloc(num_cols * sizeof(char));
    //     strcpy(board[num_rows - 1], temp);

    //     num_rows++;
    //     board = realloc(board, num_rows * sizeof(char*));
    //   }
    // }
    // num_rows--;
    // board = realloc(board, num_rows * sizeof(char*));

    // state -> board = board;
    // state -> num_rows = num_rows;
    // state -> num_snakes = 0;
    // state -> snakes = NULL;

    // initialize_snakes(state);
  } else {
    // TODO: Create default state

    state = create_default_state();

  }

  // TODO: Update state. Use the deterministic_food function
  // (already implemented in snake_utils.h) to add food.
      for (int i = 0; i < state -> num_rows; i++) {
      printf("%s", state -> board[i]);
    }
    printf("\n");
  update_state(state, deterministic_food);
      for (int i = 0; i < state -> num_rows; i++) {
      printf("%s", state -> board[i]);
    }

  // Write updated board to file or stdout
  if (out_filename != NULL) {
    // TODO: Save the board to out_filename
    save_board(state, out_filename);
  } else {
    // TODO: Print the board to stdout
    int i;
    for (i = 0; i < state -> num_rows; i++) {
      printf("%s", state -> board[i]);
    }
  }

  // TODO: Free the state
  free_state(state);

  return 0;
}
