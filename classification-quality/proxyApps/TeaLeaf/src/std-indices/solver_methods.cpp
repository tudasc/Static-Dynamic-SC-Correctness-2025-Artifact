#include "chunk.h"
#include "dpl_shim.h"
#include "ranged.h"
#include "shared.h"
#include "std_shared.h"

/*
 *		SHARED SOLVER METHODS
 */

struct Summary {
  double vol;
  double mass;
  double ie;
  double temp;
  [[nodiscard]] constexpr Summary operator+(const Summary &that) const { //
    return {vol + that.vol, mass + that.mass, ie + that.ie, temp + that.temp};
  }
};

// The field summary kernel
void field_summary(const int x,           //
                   const int y,           //
                   const int halo_depth,  //
                   const double *volume,  //
                   const double *density, //
                   const double *energy0, //
                   const double *u,       //
                   double *volOut,        //
                   double *massOut,       //
                   double *ieOut,         //
                   double *tempOut) {

  Range2d range(halo_depth, halo_depth, x - halo_depth, y - halo_depth);
  ranged<int> it(0, range.sizeXY());
  auto summary = std::transform_reduce(EXEC_POLICY, it.begin(), it.end(), Summary{}, std::plus<>(), [=](int i) {
    const int index = range.restore(i, x);
    const double cellVol = volume[index];
    const double cellMass = cellVol * density[index];
    return Summary{.vol = cellVol, .mass = cellMass, .ie = cellMass * energy0[index], .temp = cellMass * u[index]};
  });

  *volOut += summary.vol;
  *ieOut += summary.ie;
  *tempOut += summary.temp;
  *massOut += summary.mass;
}

// Store original energy state
void store_energy(int x, int y, const double *energy0, double *energy) {
  ranged<int> it(0, x * y);
  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int ii) { energy[ii] = energy0[ii]; });
}

// Copies the current u into u0
void copy_u(const int x,          //
            const int y,          //
            const int halo_depth, //
            double *u0,           //
            const double *u) {
  ranged<int> it(halo_depth, y - halo_depth);
  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int jj) {
    for (int kk = halo_depth; kk < x - halo_depth; ++kk) {
      const int index = kk + jj * x;
      u0[index] = u[index];
    }
  });
}

// Calculates the current value of r
void calculate_residual(const int x,          //
                        const int y,          //
                        const int halo_depth, //
                        const double *u,      //
                        const double *u0,     //
                        double *r,            //
                        const double *kx,     //
                        const double *ky) {
  ranged<int> it(halo_depth, y - halo_depth);
  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int jj) {
    for (int kk = halo_depth; kk < x - halo_depth; ++kk) {
      const int index = kk + jj * x;
      const double smvp = tealeaf_SMVP(u);
      r[index] = u0[index] - smvp;
    }
  });
}

// Calculates the 2 norm of a given buffer
void calculate_2norm(const int x,          //
                     const int y,          //
                     const int halo_depth, //
                     const double *buffer, //
                     double *norm) {
  ranged<int> it(halo_depth, y - halo_depth);
  *norm += std::transform_reduce(EXEC_POLICY, it.begin(), it.end(), 0.0, std::plus<>(), [=](int jj) {
    double norm_temp = 0.0;
    for (int kk = halo_depth; kk < x - halo_depth; ++kk) {
      const int index = kk + jj * x;
      norm_temp += buffer[index] * buffer[index];
    }
    return norm_temp;
  });
}

// Finalises the solution
void finalise(const int x,           //
              const int y,           //
              const int halo_depth,  //
              double *energy,        //
              const double *density, //
              const double *u) {
  ranged<int> it(halo_depth, y - halo_depth);
  std::for_each(EXEC_POLICY, it.begin(), it.end(), [=](int jj) {
    for (int kk = halo_depth; kk < x - halo_depth; ++kk) {
      const int index = kk + jj * x;
      energy[index] = u[index] / density[index];
    }
  });
}

void run_store_energy(Chunk *chunk, Settings &settings) {
  START_PROFILING(settings.kernel_profile);
  store_energy(chunk->x, chunk->y, chunk->energy0, chunk->energy);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

void run_field_summary(Chunk *chunk, Settings &settings, double *vol, double *mass, double *ie, double *temp) {
  START_PROFILING(settings.kernel_profile);
  field_summary(chunk->x, chunk->y, settings.halo_depth, chunk->volume, chunk->density, chunk->energy0, chunk->u, vol, mass, ie, temp);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

// Shared solver kernels
void run_copy_u(Chunk *chunk, Settings &settings) {
  START_PROFILING(settings.kernel_profile);
  copy_u(chunk->x, chunk->y, settings.halo_depth, chunk->u0, chunk->u);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

void run_calculate_residual(Chunk *chunk, Settings &settings) {
  START_PROFILING(settings.kernel_profile);
  calculate_residual(chunk->x, chunk->y, settings.halo_depth, chunk->u, chunk->u0, chunk->r, chunk->kx, chunk->ky);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

void run_calculate_2norm(Chunk *chunk, Settings &settings, double *buffer, double *norm) {
  START_PROFILING(settings.kernel_profile);
  calculate_2norm(chunk->x, chunk->y, settings.halo_depth, buffer, norm);
  STOP_PROFILING(settings.kernel_profile, __func__);
}

void run_finalise(Chunk *chunk, Settings &settings) {
  START_PROFILING(settings.kernel_profile);
  finalise(chunk->x, chunk->y, settings.halo_depth, chunk->energy, chunk->density, chunk->u);
  STOP_PROFILING(settings.kernel_profile, __func__);
}
