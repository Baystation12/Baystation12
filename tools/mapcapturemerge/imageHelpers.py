from PIL import Image
import re
reg_findnums = re.compile("[0-9]+")

class ImageFile:
    def __init__(self, filename, path):
        self.filename = path
        nums = reg_findnums.findall(filename)
        self.cords = (int(nums[0]), int(nums[1]), int(nums[2]))
        self.range = int(nums[3])

    def getImage(self):
        im = Image.open(self.filename)
        im.load()
        return im
