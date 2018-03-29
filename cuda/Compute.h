#ifndef COMPUTE_H
#define COMPUTE_H


__global__ void compute_synapses(struct Synapse *d_synapses, float *d_weighted_sums, size_t pitch);

__global__ void compute_neurons(struct Synapse *d_synapses, int *d_neuron_outputs, size_t pitch);

__global__ void read(struct Synapse *d_synapses, size_t pitch);

__global__ void learn(struct Synapse *d_synapses, float reward, size_t pitch);

__global__ void tag_synapses(struct Synapse *d_synapses, int *d_neuron_outputs, size_t pitch);

__global__ void reset_synapses(struct Synapse *d_synapses, float *d_weighted_sums, size_t pitch);

#endif