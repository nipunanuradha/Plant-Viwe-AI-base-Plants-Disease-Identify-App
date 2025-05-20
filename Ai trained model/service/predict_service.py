import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import json
import io

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
num_classes = 38

# Transform for input images
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

# Load model
model = models.resnet18(pretrained=False)
model.fc = nn.Linear(model.fc.in_features, num_classes)
model.load_state_dict(torch.load("plant_disease_model.pth", map_location=DEVICE))
model = model.to(DEVICE)
model.eval()

# Load class indices
try:
    with open("class_indices.json", "r") as f:
        class_idx = json.load(f)
except Exception as e:
    print("Could not load class mapping file, using default mapping. Error:", e)
    class_idx = {str(i): f"Class_{i}" for i in range(num_classes)}

def predict_class(file):
    image = Image.open(io.BytesIO(file.read())).convert("RGB")
    input_tensor = transform(image).unsqueeze(0).to(DEVICE)

    with torch.no_grad():
        output = model(input_tensor)
        _, predicted = torch.max(output, 1)

    predicted_index = predicted.item()
    predicted_class = class_idx.get(str(predicted_index), f"Class_{predicted_index}")

    return {'predicted_class': predicted_class, 'class_index': predicted_index}
