
# AI-Based Student Attendance System

![face-recognition-based-attendance-system](https://github.com/Sagar-2-99/Attendance_System/assets/32218238/61264813-ae00-4114-b45a-00d581eaf980)


This project implements an AI-based attendance system where students are registered according to their courses. During class, you can take a photo of the entire class, and the system will automatically mark the attendance of all students. This system is designed to be highly efficient and convenient, requiring only a mobile device and an internet connection. It also features load management to handle high volumes of photos effectively.


## Features
* Automated Attendance Marking: Simply take a photo of the class, and the system will recognize and mark the attendance of all students.
* Course-Based Registration: Students are registered according to their respective courses, ensuring accurate attendance tracking.
* Mobile-Friendly: Requires only a mobile device and an internet connection.
* Load Management: The system can handle multiple photos arriving simultaneously by managing processing times based on previous loads and idle times.
## Getting Started
### Prerequisites
* A mobile device with a camera
* An internet connection
* A server to run the backend


### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/attendance-system.git
```
```bash
cd attendance-system
```
2. Install dependencies:

```bash
# For the backend
pip install -r requirements.txt
```

For the frontend
run the apk named as:

```bash
app-release.apk 
```

3. Configure the server:

```bash
Update the server configuration in config.json (or appropriate configuration file) to match your server settings.
```








## Usage

1. Start the backend server:
```bash
python app.py
```

2. Open the mobile app or web interface and log in.

3. Register students by taking their photos and assigning them to their respective courses.
 
4. During the class, take a photo of the entire class. The system will automatically process the photo and mark the attendance of all recognized students.
## How to use mobile app
