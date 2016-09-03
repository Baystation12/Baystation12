from PIL import Image
import os, re, imageHelpers

def BYONDCordsToPixelCords(B, BMax):
    y = (BMax[1] - B[1]) - 31
    return (B[0] * 32 - 32, y * 32 - 32)

image_location = os.path.join(os.getcwd(), 'captures')

print("Map capture merger by Karolis")

capture_images = []
capture_re = re.compile("map_capture_x[0-9]+_y[0-9]+_z[0-9]+_r32\.png")
for image_file in os.listdir(image_location):
    if os.path.isfile(os.path.join(image_location, image_file)) and capture_re.match(image_file):
        #print(image_file)
        capture_images.append(imageHelpers.ImageFile(image_file, os.path.join(image_location, image_file)))

max_x = 0
max_y = 0
z_levels = []
captures = {}
for capture in capture_images:
    max_x = max(max_x, capture.cords[0] + capture.range)
    max_y = max(max_y, capture.cords[1] + capture.range)
    if not capture.cords[2] in z_levels:
        z_levels.append(capture.cords[2])
        captures[capture.cords[2]] = []
    captures[capture.cords[2]].append(capture)

maxCords = (max_x, max_y)

for z in z_levels:
    print("Merging map from " + str(z) + " z level.")
    map = Image.new("RGBA", ((max_x - 1) * 32, (max_y - 1) * 32))
    for capture in captures[z]:
        part = capture.getImage()
        map.paste(part, BYONDCordsToPixelCords(capture.cords, maxCords))
    filename = "map_z" + str(z) + ".png"
    print("Saving map as: " + filename)
    map.save(filename)
