import torch

class YOLOv5:
    def __init__(self):
        self.model = torch.hub.load('ultralytics/yolov5', 'yolov5s')

    def predict(self, img):
        results = self.model(img)
        detections = results.xyxy[0].tolist()
        
        return detections

if __name__ == '__main__':
    detector = YOLOv5()
    img = 'https://ultralytics.com/images/zidane.jpg'
    results = detector.predict(img)
    print(results)
