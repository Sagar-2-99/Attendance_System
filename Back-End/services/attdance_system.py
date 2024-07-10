import face_recognition
import cv2
import os 
from startup import db
import numpy as np

def find_faces(username : str, course_code: str, target_img : str):
    image_list_path = f'./images/{username}/{course_code}/'
    image_file_name_list = [(os.path.join(image_list_path, fname), fname) for fname in os.listdir(image_list_path)]
    known_face_encodings = []
    known_face_names = []
    for image_path in image_file_name_list:
        known_face_encodings.append(face_recognition.face_encodings(face_recognition.load_image_file(image_path[0]))[0])
        known_face_names.append(image_path[1][:-5])
    frame = cv2.imread(target_img)
    face_locations = face_recognition.face_locations(frame)
    face_encodings = face_recognition.face_encodings(frame, face_locations)
    face_names = []
    for face_encoding in face_encodings:
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
        name = "Unknown"
        face_distances = face_recognition.face_distance(known_face_encodings, face_encoding)
        best_match_index = np.argmin(face_distances)
        if matches[best_match_index]:
            name = known_face_names[best_match_index]
        if name != "Unknown" and name not in face_names:
            face_names.append(name)
    return face_names


def get_user_details(user_name : str):
    user_details = list(db.users.find({
        "username": user_name
    }))
    res_lst = []
    for user in user_details:
        del user['_id']
        res_lst.append(user)
    return res_lst

def get_courses_details(user_name: str):
    course_details = list(db.courses.find({
        "username": user_name
    }))
    res_lst = []
    for course in course_details:
        del course['_id']
        res_lst.append(course)
    return res_lst

def query_course_details(query_dict: dict):
    course_details = list(db.courses.find(query_dict))
    return course_details


def query_student_details(query_dict : dict):
    student_details = list(db.students.find(query_dict))
    return student_details

def query_attendance_details(query_dict : dict):
    present_student_list = list(
        db.attendance.find(query_dict)
    )
    for i in range(len(present_student_list)):
        del present_student_list[i]["_id"]
    return present_student_list


def get_course_students(username : str, course_code : str):
    student_list = list(
        db.students.find(
            {
                "username": username,
                "course_code": course_code
            },
            {
                "_id": 0,
                "full_name": 1,
                "roll_number": 1
            }
        )
    )
    return student_list
