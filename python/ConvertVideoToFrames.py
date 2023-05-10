import cv2
import os
from PIL import Image

#Path to video
cam = cv2.VideoCapture('ImportedVideos/Badapple.mp4')

#Name of video
NameofVideo = 'BadApple'

PixelSizeX = 80
PixelSizeY = 60

try:
    # creating a folder named data
    if not os.path.exists('Frames/'+NameofVideo):
        os.makedirs('Frames/'+NameofVideo)

# if not created then raise error
except OSError:
    print('Error: Creating directory of data')

currentframe = 0

while True:
    # reading from frame
    ret, frame = cam.read()

    if ret:
        # if video is still left, continue creating images
        name = f"Frames/{NameofVideo}/" + str(currentframe) + '.jpg'
        
        # writing the extracted images
        cv2.imwrite(name, frame)
        
        # open the saved image using PIL
        image = Image.open(name)
        new_image = image.resize((PixelSizeX, PixelSizeY))
        new_image.save(name)

        # increasing counter so that it will
        currentframe += 1
        if currentframe == 100:
            print(currentframe)
    else:
        break

# Release all space and windows once done
cam.release()
cv2.destroyAllWindows()