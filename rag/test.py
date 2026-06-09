import requests

payload = {
    "model": "llama3.2",
    "prompt": "Dime hola",
    "stream": False
}

r = requests.post(
    "http://localhost:11434/api/generate",
    json=payload
)

print(r.json())