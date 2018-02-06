#ECG-R-wave-and-sinus-arrest-detection
-note that dataN is data taken from healthy heart and Data2 is taken from a heart suffering from sinus arrest 
-I chose the threshold as mean(data)+std(data) hoping to obtain the maximum 16% of the data, this method is more dependent on the data an immune to some noise ex: in case of something caused high amplitude for a certain beats or time we can’t depend on the max in this case.
-The optimal window size would be 25 in our case as it is approximately equal to half the QRS interval and then in the code checking with one last interval.
-The two functions named R_R and arrest takes the window size and the directory of the data as inputs
-R_R returns a vector with the time stamps of the beats and another vector for the RR intervals
-Arrest returns a vector with the time stamps of the missing beats and automatically creates a text file called "missing beats" and prints the output in it
-The two functions plots automatically the outputs
-Matlab 2016 was used to implement.
