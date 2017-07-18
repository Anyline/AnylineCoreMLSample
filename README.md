
     _____         _ _         
    |  _  |___ _ _| |_|___ ___ 
    |     |   | | | | |   | -_|
    |__|__|_|_|_  |_|_|_|_|___|
              |___|            


# Hotdog | Not Hotdog Sample Project #

## Intro ##
I made a short sample project which demonstrates the capabilities of the new CoreML framework which Apple will release with iOS 11 later this month. 

As an inspiration I used the Hotdog | Not Hotdog App idea from the latest Silicon Valley season.

## About the Source ##

The sample is pretty easy, most of the code is setting up the camera and converting the frames to the write size & format.

This Demo is written in Objective-C.

Keep in mind that you need the XCode 9 beta and iOS 11 beta to try the Demo yourself.

## About the Machine Learning Model ##

I used the model from the [Apple CoreML Sample Model page](https://developer.apple.com/machine-learning/). But you could easily convert the inception model by yourself with the [python tool](https://pypi.python.org/pypi/coremltools) Apple provides. It's basically 2 lines of python code and the converting tool supports at the moment Caffe & Keras for neuronal networks. Keras can also be used inside of Tensorflow, the popular Deep Learning Library from Google.

I used the Inception model because it is with > 300 nodes not so small and can classify 1000 objects which one of them is luckily a hotdog. You can see a list of all the labels which inception can classify [here](https://gist.github.com/yrevar/942d3a0ac09ec9e5eb3a). You can find a python script which generates the model and fills it with the correct weights [here](https://github.com/fchollet/deep-learning-models/blob/master/inception_v3.py).

## Demo of the App ##

![Demo](/gif/hotdog.gif)
