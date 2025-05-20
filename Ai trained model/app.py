from flask import Flask
from controller.predict_controller import predict_blueprint

app = Flask(__name__)
app.register_blueprint(predict_blueprint)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
