# Digital Visual Effects, Spring 2011
## project #2: Image Stitching ([original link](http://www.csie.ntu.edu.tw/~cyy/courses/vfx/11spring/assignments/proj2/))

D99944013,
Shuen-Huei (Drake) Guan,
(drake.guan@gmail.com)

doc online: [https://github.com/drakeguan/vfx11spring_project2/](https://github.com/drakeguan/vfx11spring_project2/ "online document")

# [Digital Visual Effects 2011 Spring](http://www.csie.ntu.edu.tw/~cyy/courses/vfx/11spring/ "Digital Visual Effects 2011 Spring") @ CSIE.NTU.EDU.TW

### Objective of the project

This project is my testing plan of examining the power and possibility of Open source for an university course, [VFX](http://www.csie.ntu.edu.tw/~cyy/courses/vfx/11spring/overview/ "Digital Visual Effects 2011 Spring"), lectured by Prof. [Yung-Yu Chuang](http://www.csie.ntu.edu.tw/~cyy/ "Yung-Yu Chuang 莊永裕"). The project contains 4 sub-folders, each for an assignment. Some is a programming assignment while others might focus on visual effects demo. This project will host my working history of assignments and hopefully, there is something informative or helpful to myself and others :)

### Introduction to the course

> With the help of digital technology, visual effects have been widely used in film production lately. For example, up to April 2004, the top ten all-time best selling movies are so-called "effects movies." Six of them even won Academic awards for their visual effects. This course will cover the techniques from computer graphics, computer vision and image processing with practical or potential usages in making visual effects.

### Project description

Image stitching is a technique to combine a set of images into a larger image by registering, warping, resampling and blending them together. A popular application for image stitching is creation of panoramas. Generally speaking, there are two classes of methods for image stitching, direct methods and feature-based methods. An example of direct methods is Szeliski and Shum's SIGGRAPH 1997 paper. Brown and Lowe's ICCV2003 paper, Recognising Panoramas, is a cool example for feature-based methods. 

In this project, you will implement part of the "Recognising Panoramas" paper. There are basically five components in that paper, feature detection, feature matching, image matching, bundle adjustment and blending. You are required to do feature detection, feature matching, image matching and blending. For feature matching, we have talked about several options, SIFT, Harris and MSOP. You are free to make your own choice. If you want to implement SIFT, you can refer to this matlab implementation as a reference. For feature matching, if you want to speed up matching, you can use some kd-tree library such as ANN. You have four weeks to finish this project. However, to encourage you not to wait until the last minute, you are asked to submit your feature detection and matching part at the checkpoint. For checkpoint submission, it is enough to submit images with features displayed on them. 

