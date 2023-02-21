from flask import Flask,jsonify,request
import json
from flask_cors import CORS
import base64
import cv2
import pickle
# hinge feature extraction file
from hinge_feature_extraction import *
response=''

app=Flask(__name__)
CORS(app)
@app.route('/',methods=['POST'])
def home():
    global response
    print("finaly")
    imgrequest = request.json # json request
    imgbase64 = imgrequest['image'] # image in base 64
    inputImg = base64.b64decode(imgbase64)
    with open("InputImage.png", "wb") as fh:
        fh.write(inputImg)
    img = cv2.imread("InputImage.png",0)
    h_f = get_hinge_features("InputImage.png")
    pickled_model = pickle.load(open('model.pkl', 'rb'))
    x=[]
    x.append(h_f)
    y=pickled_model.predict(x)
    print(y)

    return jsonify({"message":str(y[0])})
    


app.run(port=8000)