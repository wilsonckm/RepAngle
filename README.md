# RepAngle: Goniometer App
## Description
The Goniometer App is a modern solution for measuring joint angles using the motion sensors in smartphones. Designed for both professionals and fitness enthusiasts, this app utilizes the device's built-in gyroscope to provide accurate and easy-to-read measurements in degrees.

### Technologies Used
- CoreMotion Framework
- Swift/SwiftUI
- MVVM Architecture 
- Xcode

## Features
- Real-time Angle Measurements: Utilizes smartphone sensors to measure joint angles in real time.
- Target-Angle Alert: Alerts user when user has reached user defined target angle.
- Rep Count: Counts rep when user has successfully reached target angle.

## Installation
- Clone the repo:
 ```git clone https://github.com/wilsonckm/RepAngle.git```
- Open the project in Xcode.
- Project must be run on device and not a simulator.

## Usage
The purpose of this app is to provide a digital tool to capture joint range of motion with the intention of providing fitness and sport professionals to perform baseline assessments and monitor progress with greater ease.  

Main features are:
-Measure
This allows a user to measure the range of motion in degrees along the Pitch/X Axis and Yaw/Z Axis of the phone.

### Per Apple Documentation, some helpful definitions are below: 
"Pitch/X is a rotation around a lateral axis that passes through the device from side to side."

"Roll/Y is a rotation around a longitudinal axis that passes through the device from its top to bottom."

"Yaw/Z is a rotation around an axis that runs vertically through the device. It is perpendicular to the body of the device, with its origin at the center of gravity and directed toward the bottom of the device."

<img width="225" alt="Screenshot 2024-01-31 at 12 16 39 PM" src="https://github.com/wilsonckm/RepAngle/assets/133422035/13df05d5-e294-4f22-99a5-d68c9e4aea57">

-Target
Allows the user to set a target postion in 3D space. Alerts the user when 3D space is reached and counts the number of times the user has reached that position. Ideally used with a iPhone strap to allow the user to attach to movement limb.

Slider bar has been provided to allow for a range of acceptance/accuracy for increased userability. 

## Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

-Fork the Project
-Create your Feature Branch 
``` (git checkout -b feature/AmazingFeature) ```
-Commit your Changes 
```(git commit -m 'Add some AmazingFeature')```
-Push to the Branch 
```(git push origin feature/AmazingFeature)```
-Open a Pull Request
