#include <mpi.h>
#include <stdio.h>

#define PROC_NUM 2
#define WIN_SIZE 1

int main(int argc, char** argv)
{
    int rank;
    MPI_Win win;
    int* win_base;
    int value;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Win_allocate(WIN_SIZE * sizeof(int), sizeof(int), MPI_INFO_NULL, MPI_COMM_WORLD, &win_base, &win);
    for (int i = 0; i < WIN_SIZE; i++) {
        win_base[i] = 0;
    }
    
    if(rank==0){
        value = 2;
    }
    if (rank==1) {
        value = 3;
    }

    MPI_Win_fence(0, win);
    if(rank==0){
        MPI_Get(&value, 1, MPI_INT, 1, 0, 1, MPI_INT, win);
    }

    foo()

    if (rank Ungerade) {
        MPI_Get(&value, 1, MPI_INT, 0, 0, 1, MPI_INT, win);
    }
    MPI_Win_fence(0, win);
    MPI_Win_free(&win);

    MPI_Finalize();

    return 0;
}
