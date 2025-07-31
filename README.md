# Coupling Static and Dynamic MPI Correctness Tools to Optimize Accuracy and Overhead - Computational Artifact

This is the computational artifact for the paper "Coupling Static and Dynamic MPI Correctness Tools to Optimize Accuracy and Overhead" submitted to the Correctness'25 workshop.

Authors: Yussur Mustafa Oraji, Simon Schwitanski, Semih Burak, Christian Bischof, Matthias S. Müller

## Repository Structure
- [CoVer](CoVer/): Contains the CoVer tool used for static analysis
- [MUST](MUST/): Contains the MUST tool used for dynamic analysis
- [proxy-app-benchmarks](proxy-app-benchmarks/): Contains the proxy application benchmarks and the results used in the paper.


## Reproducing Results


### Proxy Application Benchmarks
The proxy application benchmarks use the JUBE framework.
To run the benchmarks, navigate to the `proxy-app-benchmarks` directory and use the following JUBE commands to reproduce the results:

```
# LULESH benchmarks
cd proxy-app-benchmarks/benchmarks/LULESH
jube run LULESH.xml --tag layout

# TeaLeaf benchmarks
cd proxy-app-benchmarks/benchmarks/TeaLeaf
jube run TeaLeaf.xml --tag layout

# Stencil benchmarks
cd proxy-app-benchmarks/benchmarks/Stencil
jube run PRK_stencil.xml --tag layout S_fixed
```

The results can be retrieved using
```
jube result
```

All results are stored in the `results` directory within the `proxy-app-benchmarks` directory:
- [LULESH results](proxy-app-benchmarks/results/LULESH/result)
- [TeaLeaf results](proxy-app-benchmarks/results/TeaLeaf/result)
- [Stencil results](proxy-app-benchmarks/results/Stencil/result)
