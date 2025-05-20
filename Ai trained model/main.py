import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import datasets, transforms, models
import time
from tqdm import tqdm

def main():

    BATCH_SIZE = 32
    EPOCHS = 10
    LEARNING_RATE = 0.001
    DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    MAX_BATCHES = 2000

    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                             std=[0.229, 0.224, 0.225])
    ])

    train_data = datasets.ImageFolder("./train", transform=transform)
    train_loader = DataLoader(train_data, batch_size=BATCH_SIZE, shuffle=True)

    eval_loader = DataLoader(train_data, batch_size=BATCH_SIZE, shuffle=False)

    model = models.resnet18(pretrained=True)
    model.fc = nn.Linear(model.fc.in_features, len(train_data.classes))
    model = model.to(DEVICE)

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)

    print("Starting training on device:", DEVICE, flush=True)

    for epoch in range(EPOCHS):
        start_time = time.time()
        model.train()
        progress_bar = tqdm(enumerate(train_loader), desc=f"Epoch [{epoch+1}/{EPOCHS}]", unit="batch")
        for batch_idx, (inputs, labels) in progress_bar:
            if batch_idx >= MAX_BATCHES:
                break
            inputs, labels = inputs.to(DEVICE), labels.to(DEVICE)
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            progress_bar.set_postfix(loss=loss.item())
        epoch_time = time.time() - start_time
        print(f"Epoch [{epoch+1}/{EPOCHS}] completed in {epoch_time:.2f} seconds", flush=True)

    print("Starting evaluation on training data...", flush=True)
    model.eval()
    correct = 0
    total = 0
    MAX_EVAL_BATCHES = 10
    eval_batches = 0
    with torch.no_grad():
        for inputs, labels in eval_loader:
            inputs, labels = inputs.to(DEVICE), labels.to(DEVICE)
            outputs = model(inputs)
            _, predicted = torch.max(outputs, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            eval_batches += 1
            if eval_batches >= MAX_EVAL_BATCHES:
                break
    if total > 0:
        accuracy = 100 * correct / total
        print(f"Training accuracy (evaluated on {eval_batches} batches): {accuracy:.2f}%", flush=True)
    else:
        print("No evaluation samples found.", flush=True)

    torch.save(model.state_dict(), "plant_disease_model.pth")
    print("Model saved to plant_disease_model.pth", flush=True)

if __name__ == '__main__':
    main()