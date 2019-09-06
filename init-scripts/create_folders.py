import os

if "data" in os.listdir():
    print("Folder already exists")
else:
    print("Creating data structures")
    os.makedirs("./data/processed/stepik")
    os.makedirs("./data/processed/vle")
    os.makedirs("./data/raw/stepik")
    os.makedirs("./data/raw/vle")
        