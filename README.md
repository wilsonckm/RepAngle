# RepAngle: Goniometer App
## Description
The RepAngle App is a modern solution for measuring joint angles using the motion sensors in smartphones. Designed for both professionals and fitness enthusiasts, this app utilizes the device's built-in gyroscope to provide accurate and easy-to-read measurements in degrees.

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

### Main features are:
-Measure
This allows a user to measure the range of motion in degrees along the Pitch/X Axis and Yaw/Z Axis of the phone.

-Target
Allows the user to set a target postion in 3D space. Alerts the user when 3D space is reached and counts the number of times the user has reached that position. Ideally used with a iPhone strap to allow the user to attach to movement limb.

Slider bar has been provided to allow for a range of acceptance/accuracy for increased userability. 

### Per Apple Documentation, some helpful definitions are below: 
"Pitch/X is a rotation around a lateral axis that passes through the device from side to side."

"Roll/Y is a rotation around a longitudinal axis that passes through the device from its top to bottom."

"Yaw/Z is a rotation around an axis that runs vertically through the device. It is perpendicular to the body of the device, with its origin at the center of gravity and directed toward the bottom of the device."

<img width="225" alt="Screenshot 2024-01-31 at 12 16 39 PM" src="https://github.com/wilsonckm/RepAngle/assets/133422035/13df05d5-e294-4f22-99a5-d68c9e4aea57">


## Challenges

While working with CoreMotion, I ran into a few issues. 

#### SwiftUI View Current Coordinate Updates: 
When moving MotionManager to a different file to maintain MVVM architecture, the measurements no longer provided live motion data/coordinates. Although data would be passed through correctly when called .onTapGesture or on button press, it would not update in the view continuously. Attempted to use computed properties to perform this continuous data update but unfortuately they do not trigger a view update. A workaround was to have a timer that would force a SwiftUI update so that it would continuously "fetch" for these values.

#### App Usage and CoreMotion:
The purpose of the measurement feature was to simulate a digital goniometer to allow for fitness enthusiast or coaches to measure joint range of motion. At first, it seemed like a simple task, however, upon further inspection there would be several more use cases than anticipated and figuring out intent/how the user would use this became a larger consideration. The goal to standarize the app usage would be solved with demo videos of how to measure specific joints at different planes of the body (frontal, saggital, transverse). At first, the idea was to have the user move only in one plane as best as they can and find the greatest change/difference in rotation -- rational for this was that the user would be moving the most in the plane they were intending to measure and by capturing the max difference from inital position to end position. However, in certain measurements, Roll/Y and Yaw/Z had large changes in values that caused issues in this calculation. These large changes occurred when Pitch/X was near 90 degrees. Upon further inspection, this was a common technical barrier to using Euler Angles as this technical challenge was called "gimbal lock" -- when the pitch angle approaches ±90 degrees, causing an indistinguishability between Yaw and Roll. Conditionals were put into place to account for this and to measure the "plane of intent" or plane that they are likely to move through. Roll was not likely used as the axis where it would be an awkward set up with the phone on its smallest base of support while attempting to provide an accurate measurement. Therefore, Roll was instead used to assist in determining where the iPhone was directed in 3D space and depending on which axis it was pointing in, would result in how angles would be added. Transverse plane was measured with the Z axis with the phone facing up. xArbitraryZVertical was used to help assist this as it sets a "reference frame where the Z axis is vertical and the X axis points in an arbitrary direction in the horizontal plane." With all these things considered, consistent measurement could now be successful. Additionally, what plane was intented for measurement was also provided to the user for understanding what plane the app was anticipating (it has the same conditonals as the calculations). Additional tip would be to maintain points of interest when setting start/end measurements and limit extraneous axis movements.

For future consideration or a future update to the accuracy of the measurements, possibly look into SLERP or spherical trigonometry as it may offer greater accuracy without the technical limitations of Euler Angles-- a goniometer is essentially performing spherical trig. More specifically, another possibility would be to use quaternions as they do not have the same limitations as euler angles.

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
