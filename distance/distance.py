import numpy as np
import socket

host = "84.237.21.36"
port = 5152
packet_size = 40002


def recvall(sock, n):
    image = bytearray()
    while len(image) < n:
        packet = sock.recv(n-len(image))
        if not packet:
            return
        image.extend(packet)
    return image


def find_distance(x, y):
    return ((x[0] - y[0]) ** 2 + (x[1] - y[1]) ** 2) ** 0.5


def find_max(image):
    res = []
    for i in range(1, len(image) - 1):
        for j in range(1, len(image[i] - 1)):
            if image[i - 1][j] < image[i][j] and image[i + 1][j] < image[i][j] and image[i][j - 1] < image[i][j] and image[i][j + 1] < image[i][j]:
                res.append((i, j))
    return res


c = 0
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    sock.connect((host, port))
    while c < 10:
        sock.send(b"get")
        data = recvall(sock, packet_size)
        rows, cols = data[:2]
        image = np.frombuffer(data[2:rows * cols + 2],
                              dtype="uint8").reshape(rows, cols)
        pos1 = np.unravel_index(np.argmax(image), image.shape)
        points = find_max(image)

        if len(points) >= 2:
            distance = round(find_distance(points[0], points[1]), 1)

        sock.send(str(distance).encode())
        msg = sock.recv(20)

        if msg == b'yep':
            c += 1

        print(distance)