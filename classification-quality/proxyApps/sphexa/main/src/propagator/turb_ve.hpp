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
 * @brief A Propagator class for modern SPH with generalized volume elements
 *
 * @author Sebastian Keller <sebastian.f.keller@gmail.com>
 */

#pragma once

#include <filesystem>
#include <sstream>
#include <variant>

#include "cstone/util/constexpr_string.hpp"
#include "cstone/fields/field_get.hpp"
#include "io/arg_parser.hpp"
#include "sph/sph.hpp"
#include "sph/hydro_turb/turbulence_data.hpp"

#include "ve_hydro.hpp"
#include "gravity_wrapper.hpp"

namespace sphexa
{

using namespace sph;

template<bool avClean, class DomainType, class DataType>
class TurbVeProp final : public HydroVeProp<avClean, DomainType, DataType>
{
    using Base = HydroVeProp<avClean, DomainType, DataType>;
    using Base::rank_;
    using Base::timer;

    sph::TurbulenceData<typename DataType::RealType, typename DataType::AcceleratorType> turbulenceData;

public:
    TurbVeProp(std::ostream& output, size_t rank, const InitSettings& settings)
        : Base(output, rank)
        , turbulenceData(settings, rank == 0)
    {
    }

    void computeForces(DomainType& domain, DataType& simData) override
    {
        Base::computeForces(domain, simData);
        driveTurbulence(Base::groups_.view(), simData.hydro, turbulenceData);
        timer.step("Turbulence Stirring");
    }

    void save(IFileWriter* writer) override { turbulenceData.loadOrStore(writer); }

    void load(const std::string& initCond, IFileReader* reader) override
    {
        int         step = numberAfterSign(initCond, ":");
        std::string path = removeModifiers(initCond);
        // The file does not exist, we're starting from scratch. Nothing to do.
        if (!std::filesystem::exists(path)) { return; }

        reader->setStep(path, step, FileMode::independent);
        turbulenceData.loadOrStore(reader);

        if (rank_ == 0) { std::cout << "Restored turbulence state from " << path << ":" << step << std::endl; }
        reader->closeStep();
    }
};

} // namespace sphexa
