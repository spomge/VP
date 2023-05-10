from PIL import Image
i = Image.open("ImportedImages\Forestblank.jpg")


def rgb_to_hex(r, g, b):
    return '#{:02x}{:02x}{:02x}'.format(r, g, b)

pixels = i.load() # this is not a list, nor is it list()'able
width, height = i.size

all_pixels = []
for x in range(width):
    for y in range(height):
        cpixel = pixels[x, y]
        hex = rgb_to_hex(int(cpixel[0]),int(cpixel[1]),int(cpixel[2]))
        all_pixels.append(hex)

output_file = open('src\server\Images\FoggyForest.lua', 'a')
output_file.write("local Module = {")
for v in all_pixels:
    output_file.write(f"'{v}',\n")

output_file.write("}\n\n\nreturn Module")
output_file.close()