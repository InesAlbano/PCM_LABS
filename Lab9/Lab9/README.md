PCM 2018-2019

Fourth Processing Exercise (Video Segmentation)
Max XP: 450

# Lab Guide

Using the provided video (PCMLab9.mov), do the following (by directly accessing individual pixel values and not by using predefined filters or specialised libraries):

1. Perform stroboscopic segmentation. Save the first frame of each video segment as an image file and create a text file where you display the time index of each segment's first frame. [115 XP]

2. Implement transition detection with a parametrisable threshold. To do so, compute histograms and use differences between consecutive frames' histograms (histogram differences or squared histogram differences). Again, save the first frame of each video segment as an image file and create a text file where you display the time index of each segment's first frame. [115 XP]

3. Repeat point 2, but using twin-comparison. Check the handouts in the materials for a quick reference on twin-comparison. [115 XP]

4. Save a text file that lists the histogram differences between consecutive frames of the video and register the thresholds used for transitions detection.  [105 XP]
The file should present the list with four columns like this: <br/>
     Frame 		Histogram_Diff		Threshold1	Threshold2 <br/>
     (…) 
     
     
# Running program
In order to execute the program, just go to the processing application and hit the *run button*, the output of the exercise if the following:
* **Exercise 1** - in the folder *frame data/frames1* are the output frames and in the file in the folder *data* is a file called *timeFrame1* with the time for each first segment.
* **Exercise 2** - in the folder *frame data/frames2* are the output frames and in the file in the folder *data* is a file called *timeFrame2* with the time for each first segment.
* **Exercise 3** - in the folder *frame data/frames3* are the output frames and in the file in the folder *data* is a file called *timeFrame3* with the time for each first segment.
* **Exercise 4** - in the file in the folder *data* is a file called *timeFrame4* with the time for each frame.