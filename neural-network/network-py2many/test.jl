include("mnist_loader_res.jl")
include("network.jl")
(training_data, validation_data, test_data) = load_data_wrapper()
training_data = collect(training_data)
net = Network([784, 30, 10])
SGD(net, training_data, 30, 10, 3.0, test_data)
