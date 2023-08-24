#include "compute.h"

// Computes the dot product of vec1 and vec2, both of size n
int32_t dot(uint32_t n, int32_t *vec1, int32_t *vec2) {
  // TODO: implement dot product of vec1 and vec2, both of size n
  int32_t res = 0;
  for (uint32_t i = 0; i < n; i++) {
    res += vec1[i] * vec2[i];
  }
  return res;
}

// Computes the convolution of two matrices
int convolve(matrix_t *a_matrix, matrix_t *b_matrix, matrix_t **output_matrix) {
  // TODO: convolve matrix a and matrix b, and store the resulting matrix in
  // output_matrix
  if (!a_matrix || !b_matrix || !output_matrix) return -1;
  uint32_t aCol = a_matrix->cols, bCol = b_matrix->cols;
  uint32_t aRow = a_matrix->rows, bRow = b_matrix->rows;
  if (!aCol || !bCol || !aRow || !bRow) return -1;
  int32_t* A = a_matrix->data, *B = b_matrix->data;
  if (!A || !B) return -1;
  
  //FLIP B
  //horizontally flip B
  for (uint32_t i = 0; i < bRow; i++) {
    for (uint32_t j = 0; j < (bCol>>1); j++) {
      int32_t temp = B[i * bCol + j];
      B[i * bCol + j] = B[(i + 1) * bCol - j - 1];
      B[(i + 1) * bCol - j - 1] = temp;
    }
  }
  //vertically flip B
  for (uint32_t j = 0; j < bCol; j++) {
    for (uint32_t i = 0; i < (bRow>>1); i++) {
      int32_t temp = B[i * bCol + j];
      B[i * bCol + j] = B[(bRow - i - 1) * bCol + j];
      B[(bRow - i - 1) * bCol + j] = temp;
    }
  }

  //convolve
  matrix_t* res = malloc(sizeof(matrix_t));
  res->rows = aRow - bRow + 1;
  res->cols = aCol - bCol + 1;
  res->data = malloc(res->rows * res->cols * sizeof(int32_t));
  int num = bCol * bRow;
  int32_t* temp = malloc(num * sizeof(int32_t));

  for (uint32_t i = 0, count1 = 0; i < res->rows; i++) {
    for (uint32_t j = 0; j < res->cols; j++) {
      
      for (uint32_t y = i, count2 = 0; y < i + bRow; y++) {
        for (uint32_t x = j; x < j + bCol; x++) {
          temp[count2++] = A[y * aCol + x];
        }
      }

      res->data[count1++] = dot(num, temp, B);
    }
  }

  free(temp);
  *output_matrix = res;

  return 0;
}

// Executes a task
int execute_task(task_t *task) {
  matrix_t *a_matrix, *b_matrix, *output_matrix;

  if (read_matrix(get_a_matrix_path(task), &a_matrix))
    return -1;
  if (read_matrix(get_b_matrix_path(task), &b_matrix))
    return -1;

  if (convolve(a_matrix, b_matrix, &output_matrix))
    return -1;

  if (write_matrix(get_output_matrix_path(task), output_matrix))
    return -1;

  free(a_matrix->data);
  free(b_matrix->data);
  free(output_matrix->data);
  free(a_matrix);
  free(b_matrix);
  free(output_matrix);
  return 0;
}
