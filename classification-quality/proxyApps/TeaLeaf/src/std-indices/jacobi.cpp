#include "chunk.h"
#include "dpl_shim.h"
#include "ranged.h"
#include "shared.h"
#include "std_shared.h"
#include <cmath>

/*
 *		JACOBI SOLVER KERNEL
 */

// Initialises the Jacobi solver
void jacobi_init(const int x,           //
                 const int y,           //
                 const int halo_depth,  //
                 const int coefficient, //
                 double rx,             //
                 double ry,             //
                 const double *density, //
                 const double *energy,  //
                 double *u0,            //
                 double *u,             //
                 double *kx,            //
                 double *ky) {
  if (coefficient < CONDUCTIVITY && coefficient < RECIP_CONDUCTIVITY) {
    die(__LINE__, __FILE__, "Coefficient %d is not valid.\n", coefficient);
  }
  Range2d range(1, 1, x - 1, y - 1);
  ranged<int> it(0, range.sizeXY());
  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int i) {
    const int index = range.restore(i, x);
    double temp = energy[index] * density[index];
    u0[index] = temp;
    u[index] = temp;
  });

  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int i) {
    const int index = range.restore(i, x);
    double densityCentre = (coefficient == CONDUCTIVITY) ? density[index] : 1.0 / density[index];
    double densityLeft = (coefficient == CONDUCTIVITY) ? density[index - 1] : 1.0 / density[index - 1];
    double densityDown = (coefficient == CONDUCTIVITY) ? density[index - x] : 1.0 / density[index - x];

    kx[index] = rx * (densityLeft + densityCentre) / (2.0 * densityLeft * densityCentre);
    ky[index] = ry * (densityDown + densityCentre) / (2.0 * densityDown * densityCentre);
  });
}

// The main Jacobi solve step
void jacobi_iterate(const int x,          //
                    const int y,          //
                    const int halo_depth, //
                    double *error,        //
                    const double *kx,     //
                    const double *ky,     //
                    const double *u0,     //
                    double *u,            //
                    double *r) {

  {
    Range2d range(0, 0, x, y);
    ranged<int> it(0, range.sizeXY());
    std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int i) {
      const int index = range.restore(i, x);
      r[index] = u[index];
    });
  }

  {
    Range2d range(halo_depth, halo_depth, x - halo_depth, y - halo_depth);
    ranged<int> it(0, range.sizeXY());
    *error = std::transform_reduce(EXEC_POLICY, it.begin(), it.end(), 0.0, std::plus<>(), [=](int i) {
      const int index = range.restore(i, x);
      u[index] = (u0[index] + (kx[index + 1] * r[index + 1] + kx[index] * r[index - 1]) +
                  (ky[index + x] * r[index + x] + ky[index] * r[index - x])) /
                 (1.0 + (kx[index] + kx[index + 1]) + (ky[index] + ky[index + x]));

      return fabs(u[index] - r[index]);
    });
  }
}

// Jacobi solver kernels
void run_jacobi_init(Chunk *chunk, Settings &settings, double rx, double ry) {
  START_PROFILING(settings.kernel_profile);
  jacobi_init(chunk->x, chunk->y, settings.halo_depth, settings.coefficient, rx, ry, chunk->density, chunk->energy, chunk->u0, chunk->u,
              chunk->kx, chunk->ky);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

void run_jacobi_iterate(Chunk *chunk, Settings &settings, double *error) {
  START_PROFILING(settings.kernel_profile);
  jacobi_iterate(chunk->x, chunk->y, settings.halo_depth, error, chunk->kx, chunk->ky, chunk->u0, chunk->u, chunk->r);
  STOP_PROFILING(settings.kernel_profile, __func__);
}