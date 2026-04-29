import time
from datetime import datetime
import os

os.makedirs("/data", exist_ok=True)

while True:
    filename = f"/data/log_{int(datetime.now().timestamp())}.txt"
    with open(filename, "w") as f:
        f.write(f"version={datetime.now()}\n")

    print(f"Created {filename}")
    time.sleep(300)  # 5 minutes