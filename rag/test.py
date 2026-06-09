from transformers import CLIPModel, CLIPProcessor
from PIL import Image
from io import BytesIO
import requests
import torch

MODEL_NAME = "openai/clip-vit-base-patch32"

print("Cargando modelo...")
model = CLIPModel.from_pretrained(MODEL_NAME)
processor = CLIPProcessor.from_pretrained(MODEL_NAME)

print("Modelo cargado.")

url = "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"

print("Descargando imagen...")
response = requests.get(url, timeout=20)
response.raise_for_status()

image = Image.open(BytesIO(response.content)).convert("RGB")

print("Procesando imagen...")
inputs = processor(images=image, return_tensors="pt")

print("\n=== PRUEBA get_image_features ===")

try:
    with torch.no_grad():
        features = model.get_image_features(**inputs)

    print("Tipo:", type(features))
    print("Shape:", features.shape)

    normalized = features / features.norm(p=2, dim=-1, keepdim=True)

    print("Normalización OK")
    print("Shape normalizado:", normalized.shape)

except Exception as e:
    print("ERROR get_image_features:")
    print(type(e).__name__)
    print(e)

print("\n=== PRUEBA vision_model ===")

try:
    with torch.no_grad():
        vision_output = model.vision_model(**inputs)

    print("Tipo:", type(vision_output))

    if hasattr(vision_output, "pooler_output"):
        print("Tiene pooler_output:", vision_output.pooler_output.shape)

except Exception as e:
    print("ERROR vision_model:")
    print(type(e).__name__)
    print(e)

print("\n=== VERSIONES ===")

import transformers

print("Transformers:", transformers.__version__)
print("Torch:", torch.__version__)