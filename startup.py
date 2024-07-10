from pymongo import MongoClient 
from logger.logger import *

try:
    mongoClient = MongoClient()
    db = mongoClient['attdance_system']
    print("MongoDB server connected")

except:
    print("MongoDB connection error occured")