## Digit Recognizer
Digit Recognizer is an Computer Vision based project. I am using Kaggle digit recognizer data set available at https://www.kaggle.com/c/digit-recognizer/data . The project aims at correctly identifying the digits from handwritten images. In this project I am using Multilayer Perceptron and Convolution Neural Networks and am comparing the performance of both the models.

### Multilayer Perceptron
A Multilayer Perceptron(MLP) is a feed forward artificial neural network consisting of atleast three layers of perceptron. MLP uses backpropagation supervised learning technique to train the model. In an MLP, expcept for the input layer each layer performs a non linear transformation(actiavtion function). Some of the widely used activation functions are Relu, sigmoid and tanh. There is an activation function at each neuron that maps the weighted input to the output of a neuron.
Learning occurs in the perceptron by changing connection weights after each piece of data is processed, based on the amount of error in the output compared to the expected result. This is an example of supervised learning, and is carried out through backpropagation.

For my implementation, I  am using an MLP with 3 layers - input, hidden and output. Input layer takes the 784 pixels of the image as an input, the hidden layer consists of 500 neurons performing relu transformation and finally there is an output layer with 10 neurons.

### Convolution Neural Network
Convolution Neural Network(CNN) is a class of feed forward artificial neural networkcommonly used for analyzing vision imagery. Like MLP, CNN also consists of input layer, hidden layers and ourtput layer but the hidden layers of CNN typically consists of convolutional layers, pooling layers, fully connected layers and normalization layers. Convolution in image classification is generally used for edge detection. So, the convolution layers in CNN help in identifying the patterns in the image. 

For my implementation, I am using a CNN with two convolution layers with 6 and 16 filters. I am also using a fully dense layer with 128 perceptrons and an output layer with 10 perceptrons. I am using max pooling and relu layers in between as well.

