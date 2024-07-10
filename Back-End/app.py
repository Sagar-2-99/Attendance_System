from flask import Flask, request, flash, jsonify
from werkzeug.utils import secure_filename
from services.attdance_system import *
from startup import *
import json

app = Flask(__name__)

@app.route('/register', methods = ['POST'])
def register_new_user():
    body = request.data
    userDetails = json.loads(body)
    existringUser = list(db.users.find(
        {
            "$or": 
            [ 
                {"username": userDetails['username']},
                {"email":  userDetails["email"]}
            ]
        }
    ))
    print(existringUser)
    if(len(existringUser) > 0):
        return {
            'status_code': 400,
            'message': "username or email address adready exists.",
            'data': {}
        }

    db.users.insert_one(userDetails)
    user_details = get_user_details(userDetails['username'])[0]
    course_details = get_courses_details(userDetails['username'])
    os.mkdir(f"./images/{userDetails['username']}")
    return {
        "status_code": 200,
        "message": "Account Created",
        "data": {
            'user_details': user_details,
            'course_details': course_details
        }
    }

@app.route("/get_attendance", methods = ['POST'])
def get_attendance_details():
    query_dict = request.json
    course_code = query_dict['course_code']
    username = query_dict['username']
    print(query_dict)
    attendance_details = query_attendance_details({
        "$and": [
            {
                "course_code": course_code
            },
            {
                "username": username
            }
        ]
    })
    print(attendance_details)
    return {
        "status_code": 200,
        "message": "Successfull",
        "data": {
            "attendance_data": attendance_details
        }
    }


@app.route('/login', methods = ['POST'])
def user_login():
    body = request.data
    userDetails = json.loads(body)
    print(userDetails)
    targetUser = list(db.users.find(
        {
            "$and": 
            [ 
                {"username": userDetails['username']},
                {"password":  userDetails["password"]}
            ]
        }
    ))
    print(targetUser)
    if(len(targetUser) == 0):
        return {
            'status_code': 400,
            'message': "Invalue username or password",
            'data': []
        }
    targetUser = targetUser[0]
    del targetUser['_id']
    course_details = get_courses_details(userDetails['username'])
    return {
        "status_code": 200,
        "message": "Successfull",
        "data": {
            'user_details': targetUser,
            'course_details': course_details
        }
    }

@app.route('/upload', methods = ['POST'])
def upload_file():
    if request.method == 'POST':
        if 'file' not in request.files:
            flash('No file part')
            return {}
        file = request.files['file']
        content = file.read()
        f = open(file.filename, 'wb')
        f.write(content)
        f.close()
        print(content)
        return {}
    
@app.route('/regiter_course', methods = ['POST'])
def register_new_course():
    course_data = request.json
    print(course_data)
    current_exist_course = query_course_details({
        "$and": [
            {
                "username": course_data['username']
            },
            {
                "course_code": course_data['course_code']
            }
        ]
    })
    print(current_exist_course)
    if len(current_exist_course) > 0:
        return {
            'status_code': 400,
            'message': "Course code already exists",
            'data': {

            }
        }
    db.courses.insert_one(course_data)
    os.mkdir(f"./images/{course_data['username']}/{course_data['course_code']}")
    return {
        'status_code': 200,
        'message': 'Successfull',
        'data': {

        }
    }

@app.route("/register_student", methods = ['POST'])
def regiter_new_student():
    print(request.files)
    print(request.form)
    course_code = request.form['course_code']
    roll_number = request.form['roll_number']
    full_name = request.form['full_name']
    username = request.form['username']

    student_list = query_student_details({
        'course_code': course_code,
        'roll_number': roll_number,
        'username': username
    })

    if len(student_list) > 0:
        return {
            "status_code": 400,
            "message": "Roll Number Alredy Registered.",
            "data": {}
        }

    print(f"course code : {course_code} full name : {full_name} roll number : {roll_number} username : {username}")
    db.students.insert_one({
        'course_code': course_code,
        'roll_number': roll_number,
        'full_name': full_name,
        'username': username
    })
    try:
        file = request.files['picture']
        file.save(f"./images/{username}/{course_code}/{roll_number}.jpeg")
        return {
            "status_code": 200,
            "message": 'Successfull',
            'data': {

            }
        }
    except Exception as e:
        print(e)
        return {
            "status_code": 400,
            "message": "Sucessfull",
            'data': {
                
            }
        }
    
@app.route("/register_attendance", methods = ['POST'])
def register_attendance_request():
    print(request.files)
    print(request.form)
    number_of_image = int(request.form['number_of_picture'])
    username = request.form['username']
    course_code = request.form['course_code']
    date = request.form['date']
    present_student_list = []
    for i in range(number_of_image):
        key_name = "picture" + str(i)
        request.files[key_name].save(f"{username}_{course_code}.jpg")
        student_list = find_faces(username=username, course_code=course_code, target_img = f"{username}_{course_code}.jpg")
        print(student_list)
        present_student_list.extend(student_list)
    print(present_student_list)
    final_list = []
    for r in present_student_list:
        if r not in final_list:
            final_list.append(r)
    db.attendance.insert_one(
        {
            "course_code": course_code,
            "date": date,
            "present_list": final_list,
            "username": username
        }
    )
    return {
        "status_code": 200,
        "data": {},
        "message": "Succesfull"
    }


@app.route("/get_student_list", methods = ['POST'])
def get_course_student_list():
    username = request.json['username']
    course_code = request.json['course_code']
    student_list = get_course_students(username = username, course_code = course_code)
    print(student_list)
    return {
        "status_code": 200,
        "data": {
            "student_list": student_list
        },
        "message": "Successfull"
    }

@app.route("/update_attendance", methods = ['POST'])
def update_student_attendance():
    username = request.json['username']
    course_code = request.json['course_code']
    target_date = request.json['date']
    present_student_list = request.json['present_list']
    print(username)
    print(course_code)
    print(target_date)
    print(present_student_list)
    db.attendance.update_one(
        {
            "course_code": course_code,
            "date": target_date,
            "username": username
        },
        {  
            "$set": 
            {
                "present_list": present_student_list,
            }
        }
    )
    return {
        "status_code": 200,
        "message": "Successfull",
        "data": {

        }
    }


@app.route("/get_attendance_date", methods = ['POST'])
def get_attendance_details_date():
    query_dict = request.json
    course_code = query_dict['course_code']
    username = query_dict['username']
    date = query_dict['date']
    print(query_dict)
    attendance_details = query_attendance_details({
        "$and": [
            {
                "course_code": course_code
            },
            {
                "username": username
            },
            {
                "date": date
            }
        ]
    })
    print(attendance_details)
    return {
        "status_code": 200,
        "message": "Successfull",
        "data": {
            "attendance_data": attendance_details
        }
    }

app.run(host = "0.0.0.0",port=8000)


