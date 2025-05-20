from flask import Blueprint, request, jsonify
from service.predict_service import predict_class

predict_blueprint = Blueprint('predict', __name__)

@predict_blueprint.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'Empty file name'}), 400

    try:
        result = predict_class(file)
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500
