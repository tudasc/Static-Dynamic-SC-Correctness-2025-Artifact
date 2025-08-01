/*
 * MIT License
 *
 * Copyright (c) 2021 CSCS, ETH Zurich
 *               2021 University of Basel
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*! @file
 * @brief Density i-loop GPU driver
 *
 * @author Sebastian Keller <sebastian.f.keller@gmail.com>
 */

#include "cstone/cuda/cuda_utils.cuh"
#include "cstone/primitives/math.hpp"
#include "cstone/util/tuple.hpp"

#include "sph/sph_gpu.hpp"
#include "sph/eos.hpp"
#include "sph/particles_data.hpp"

namespace sph
{
namespace cuda
{

template<class Tt, class Tm, class Thydro>
__global__ void cudaEOS(size_t firstParticle, size_t lastParticle, Tm mui, Tt gamma, const Tt* temp, const Tm* m,
                        const Thydro* kx, const Thydro* xm, const Thydro* gradh, Thydro* prho, Thydro* c, Thydro* rho,
                        Thydro* p)
{
    unsigned i = firstParticle + blockDim.x * blockIdx.x + threadIdx.x;
    if (i >= lastParticle) return;

    Thydro p_i;
    Thydro rho_i         = kx[i] * m[i] / xm[i];
    util::tie(p_i, c[i]) = idealGasEOS(temp[i], rho_i, mui, gamma);
    prho[i]              = p_i / (kx[i] * m[i] * m[i] * gradh[i]);
    if (rho) { rho[i] = rho_i; }
    if (p) { p[i] = p_i; }
}

template<class Tt, class Tm, class Thydro>
void computeEOS(size_t firstParticle, size_t lastParticle, Tm mui, Tt gamma, const Tt* temp, const Tm* m,
                const Thydro* kx, const Thydro* xm, const Thydro* gradh, Thydro* prho, Thydro* c, Thydro* rho,
                Thydro* p)
{
    if (firstParticle == lastParticle) { return; }
    unsigned numThreads = 256;
    unsigned numBlocks  = cstone::iceil(lastParticle - firstParticle, numThreads);
    cudaEOS<<<numBlocks, numThreads>>>(firstParticle, lastParticle, mui, gamma, temp, m, kx, xm, gradh, prho, c, rho,
                                       p);
    checkGpuErrors(cudaDeviceSynchronize());
}

#define COMPUTE_EOS(Ttemp, Tm, Thydro)                                                                                 \
    template void computeEOS(size_t firstParticle, size_t lastParticle, Tm mui, Ttemp gamma, const Ttemp* temp,        \
                             const Tm* m, const Thydro* kx, const Thydro* xm, const Thydro* gradh, Thydro* prho,       \
                             Thydro* c, Thydro* rho, Thydro* p)

COMPUTE_EOS(double, double, double);
COMPUTE_EOS(double, float, double);
COMPUTE_EOS(double, float, float);
COMPUTE_EOS(float, float, float);

template<typename Th, typename Tu>
__global__ void cudaComputeIsothermalEOS(size_t first, size_t last, Th cConst, Th* rho, Th* p, const Th* m,
                                         const Th* kx, const Th* xm, const Th* gradh, Th* prho, Tu* temp)
{
    unsigned i = first + blockDim.x * blockIdx.x + threadIdx.x;
    if (i >= last) return;

    Th rho_i = kx[i] * m[i] / xm[i];
    Th p_i   = isothermalEOS(cConst, rho_i);
    prho[i]  = p_i / (kx[i] * m[i] * m[i] * gradh[i]);
    if (rho) { rho[i] = rho_i; }
    if (p) { p[i] = p_i; }
    if (temp) { temp[i] = 0; }
}

template<typename Dataset>
void computeIsothermalEOS(size_t first, size_t last, Dataset& d)
{
    if (first == last) { return; }
    unsigned numThreads = 256;
    unsigned numBlocks  = cstone::iceil(last - first, numThreads);
    cudaComputeIsothermalEOS<<<numBlocks, numThreads>>>(first, last, d.soundSpeedConst, rawPtr(d.devData.rho),
                                                        rawPtr(d.devData.p), rawPtr(d.devData.m), rawPtr(d.devData.kx),
                                                        rawPtr(d.devData.xm), rawPtr(d.devData.gradh),
                                                        rawPtr(d.devData.prho), rawPtr(d.devData.temp));
    checkGpuErrors(cudaDeviceSynchronize());
}

template void computeIsothermalEOS(size_t, size_t, sphexa::ParticlesData<cstone::GpuTag>& d);

} // namespace cuda
} // namespace sph
