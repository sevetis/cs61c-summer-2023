#include <omp.h>
#include <x86intrin.h>

#include "compute.h"

// Computes the dot product of vec1 and vec2, both of size n
int32_t dot(uint32_t n, int32_t *vec1, int32_t *vec2) {
  // TODO: implement dot product of vec1 and vec2, both of size n
  int32_t result = 0;
  __m256i sum_vec = _mm256_setzero_si256();
  __m256i temp1, temp2;
  for (uint32_t i = 0; i < n / 8 * 8; i += 8) {
    temp1 = _mm256_loadu_si256((__m256i *)(vec1 + i));
    temp2 = _mm256_loadu_si256((__m256i *)(vec2 + i));

    temp1 = _mm256_mullo_epi32(temp1, temp2);
    sum_vec = _mm256_add_epi32(sum_vec, temp1);
  }
  
  int32_t tmp_arr[8];
  _mm256_store_epi32((__m256i *)tmp_arr, sum_vec);

  for (int i = 0; i < 8; i++) 
    result += tmp_arr[i];

  for (uint32_t i = n / 8 * 8; i < n; i++) 
    result += vec1[i] * vec2[i];
  
  return result;
}

// Computes the convolution of two matrices
int convolve(matrix_t *a_matrix, matrix_t *b_matrix, matrix_t **output_matrix) {
  // TODO: convolve matrix a and matrix b, and store the resulting matrix in
  // output_matrix

  return -1;
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
