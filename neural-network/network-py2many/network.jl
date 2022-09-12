#= 
network.py
~~~~~~~~~~
IT WORKS

A module to implement the stochastic gradient descent learning
algorithm for a feedforward neural network.  Gradients are calculated
using backpropagation.  Note that I have focused on making the code
simple, easily readable, and easily modifiable.  It is not optimized,
and omits many desirable features.
 =#
using LinearAlgebra
using Random

abstract type AbstractNetwork end
mutable struct Network <: AbstractNetwork
    sizes::Vector{Int64}
    num_layers::Int64
    biases
    weights

    Network(
        sizes::Vector{Int64},
        num_layers = length(sizes),
        biases::Vector{Matrix} = [randn(y, 1) for y in sizes[2:end]],
        weights::Vector{Matrix} = [
            randn(y, x) for (x, y) in zip(sizes[begin:end-1], sizes[2:end])
        ],
    ) = begin
        #= The list ``sizes`` contains the number of neurons in the
        respective layers of the network.  For example, if the list
        was [2, 3, 1] then it would be a three-layer network, with the
        first layer containing 2 neurons, the second layer 3 neurons,
        and the third layer 1 neuron.  The biases and weights for the
        network are initialized randomly, using a Gaussian
        distribution with mean 0, and variance 1.  Note that the first
        layer is assumed to be an input layer, and by convention we
        won't set any biases for those neurons, since biases are only
        ever used in computing the outputs from later layers. =#
        new(sizes, num_layers, biases, weights)
    end
end

function feedforward(self::AbstractNetwork, a::Matrix)::Matrix
    #= Return the output of the network if ``a`` is input. =#
    for (b, w) in zip(self.biases, self.weights)
        a = sigmoid((w * a) .+ b)
    end
    return a
end

function SGD(
    self::AbstractNetwork,
    training_data::Vector,
    epochs::Int64,
    mini_batch_size::Int64,
    eta::Float64,
    test_data::Union{Vector, Nothing} = nothing,
)
    #= Train the neural network using mini-batch stochastic
            gradient descent.  The ``training_data`` is a list of tuples
            ``(x, y)`` representing the training inputs and the desired
            outputs.  The other non-optional parameters are
            self-explanatory.  If ``test_data`` is provided then the
            network will be evaluated against the test data after each
            epoch, and partial progress printed out.  This is useful for
            tracking progress, but slows things down substantially. =#
    training_data = collect(training_data)
    n = length(training_data)
    if test_data !== nothing
        test_data = collect(test_data)
        n_test = length(test_data)
    end
    for j = 0:epochs-1
        shuffle(training_data)
        mini_batches = [training_data[k+1:k+mini_batch_size] for k = 0:mini_batch_size:n-1]
        for mini_batch in mini_batches
            update_mini_batch(self, mini_batch, eta)
        end
        if test_data !== nothing
            println("Epoch $(j) : $(evaluate(self, test_data)) / $(n_test)")
        else
            println("Epoch $(j) complete")
        end
    end
end

function update_mini_batch(self::AbstractNetwork, mini_batch::Vector{Tuple}, eta::Float64)
    #= Update the network's weights and biases by applying
            gradient descent using backpropagation to a single mini batch.
            The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
            is the learning rate. =#
    nabla_b = [zeros(Float64, size(b)) for b in self.biases]
    nabla_w = [zeros(Float64, size(w)) for w in self.weights]
    for (x, y) in mini_batch
        (delta_nabla_b, delta_nabla_w) = backprop(self, x, y)
        nabla_b = [nb + dnb for (nb, dnb) in zip(nabla_b, delta_nabla_b)]
        nabla_w = [nw + dnw for (nw, dnw) in zip(nabla_w, delta_nabla_w)]
    end
    self.weights =
        [w - (eta / length(mini_batch)) * nw for (w, nw) in zip(self.weights, nabla_w)]
    self.biases =
        [b - (eta / length(mini_batch)) * nb for (b, nb) in zip(self.biases, nabla_b)]
end

function backprop(self::AbstractNetwork, x::Matrix, y::Matrix)::Tuple
    #= Return a tuple ``(nabla_b, nabla_w)`` representing the
            gradient for the cost function C_x.  ``nabla_b`` and
            ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
            to ``self.biases`` and ``self.weights``. =#
    nabla_b = [zeros(Float64, size(b)) for b in self.biases]
    nabla_w = [zeros(Float64, size(w)) for w in self.weights]
    activation::Matrix = x
    activations::Vector{Matrix} = [x]
    zs::Vector{Matrix} = []
    for (b, w) in zip(self.biases, self.weights)
        z = (w * activation) .+ b
        push!(zs, z)
        activation = sigmoid(z)
        push!(activations, activation)
    end
    delta = cost_derivative(self, activations[end], y) .* sigmoid_prime(zs[end])
    nabla_b[end] = delta
    nabla_w[end] = (delta * LinearAlgebra.transpose(activations[end-1]))
    for l = 2:self.num_layers-1
        z = zs[end-l+1]
        sp = sigmoid_prime(z)
        delta = (LinearAlgebra.transpose(self.weights[end-l+2]) * delta) .* sp
        nabla_b[end-l+1] = delta
        nabla_w[end-l+1] = (delta * LinearAlgebra.transpose(activations[end-l]))
    end
    return (nabla_b, nabla_w)
end

function evaluate(self::AbstractNetwork, test_data::Vector)
    #= Return the number of test inputs for which the neural
            network outputs the correct result. Note that the neural
            network's output is assumed to be the index of whichever
            neuron in the final layer has the highest activation. =#
    test_results = [(argmax(@view feedforward(self, x)[:]) - 1, y) for (x, y) in test_data]
    return sum((Int(x == y) for (x, y) in test_results))
end

function cost_derivative(
    self::AbstractNetwork,
    output_activations::Matrix,
    y::Matrix,
)::Matrix
    #= Return the vector of partial derivatives \partial C_x /
            \partial a for the output activations. =#
    return output_activations .- y
end

function sigmoid(z::Matrix)::Matrix
    #= The sigmoid function. =#
    return 1.0 ./ (1.0 .+ ℯ .^ -z)
end

function sigmoid_prime(z::Matrix)::Matrix
    #= Derivative of the sigmoid function. =#
    return sigmoid(z) .* (1 .- sigmoid(z))
end
