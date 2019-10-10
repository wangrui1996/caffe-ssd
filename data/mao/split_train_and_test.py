import os
import random
dataset_path = "/home/rui/tmp/ffff/mao"
shuffle_datset = True

file_train_path = os.path.join(dataset_path, "train")
file_test_path = os.path.join(dataset_path, "test")

train_txt_path = os.path.join(dataset_path, "train.txt")
test_txt_path = os.path.join(dataset_path, "test.txt")

def write_to_txt(file_path, write_txt_path):
    images_name = []
    for file in os.listdir(file_path):
        if file.split(".")[1] == "jpg":
            images_name.append(file)
    if shuffle_datset:
        random.shuffle(images_name)
    with open(write_txt_path, "w+") as f:
        for image_name in images_name:
            f.writelines("{}\n".format(image_name.split(".")[0]))
write_to_txt(file_train_path, train_txt_path)
write_to_txt(file_test_path, test_txt_path)

