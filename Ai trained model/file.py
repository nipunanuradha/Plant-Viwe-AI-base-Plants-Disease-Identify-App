import json
from torchvision import datasets, transforms

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor()
])

train_data = datasets.ImageFolder("./train", transform=transform)

class_idx = {str(idx): class_name for idx, class_name in enumerate(train_data.classes)}

with open("class_indices.json", "w") as f:
    json.dump(class_idx, f, indent=4)

print("class_indices.json has been created!")