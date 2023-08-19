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
  uint32_t aLen = a_matrix->cols, bLen = b_matrix->cols;
  if (!aLen || !bLen) return -1;
  int32_t* A = a_matrix->data, *B = b_matrix->data;
  if (!A || !B) return -1;

  for (int32_t i = 0; i < (bLen>>1); i++) {
    int32_t temp = B[0];
    B[0] = B[bLen - i - 1];
    B[bLen - i - 1] = temp;
  }

  for (int32_t i = 0; i + bLen <= aLen; i++) {
    output_matrix[0]->data[i] = dot(bLen, A + i, B);
  }

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
