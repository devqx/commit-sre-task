import os, time
def main():
    while True:
        if os.path.exists("/mnt/efs/log.txt"):
            with open("/mnt/efs/log.txt", "r") as f:
                print(f"Log Version: {f.read().strip()}")
        time.sleep(20)