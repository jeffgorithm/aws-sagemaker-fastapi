from fastapi import FastAPI
from schemas import Request
from yolov5 import YOLOv5

detector = YOLOv5()

app = FastAPI()

# AWS Sagemaker Health Check Endpoint
@app.get("/ping")
def ping():
    return {
        'message' : 'alive'
        }

# AWS Sagemaker Invocations endpoint
@app.post('/invocations')
def invocations(request: Request):
    try:
        detections = detector.predict(request.url)
    except Exception as e:
        return {
            'success' : False
        }

    return {
        'success' : True,
        'result' : detections
        }