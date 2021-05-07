#
# Install:
# pip install --upgrade tensorflow image
#

# disable debug output
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 

# script imports
import glob, shutil, time, timeit
import tensorflow.keras
from PIL import Image, ImageOps
import numpy as np
import operator

# Disable scientific notation for clarity
np.set_printoptions(suppress=True)

# Create the array of the right shape to feed into the keras model
data = np.ndarray(shape=(1, 224, 224, 3), dtype=np.float32)

# Load the model
model = tensorflow.keras.models.load_model('keras_model.h5', compile=False)

# Long loop
for x in range(1000):

    # Find all files to classify
    for filename in glob.glob('../../../data/card/*.png'):
    
        # if there is no lock file
        if not os.path.isfile(filename+'.lock'):

            start = timeit.timeit()

            # convert to 3 channel RGB
            image = Image.open(filename)
            newImage = Image.new('RGB', image.size, (255, 255, 255))
            newImage.paste(image, mask = image.split()[3])
            image = newImage

            #resize the image to a 224x224 with the same strategy as in TM2:
            image = ImageOps.fit(image, (224, 224), Image.ANTIALIAS)

            #turn the image into a numpy array
            image_array = np.asarray(image)

            # Normalize the image
            normalized_image_array = (image_array.astype(np.float32) / 127.0) - 1

            # Load the image into the array
            data[0] = normalized_image_array

            # run the prediction
            prediction = model.predict(data)
            score = np.amax(prediction[0])
            result = np.where(prediction[0] == score)[0][0]
            cards = ['2','3','4','5','6','7','8','9','T','J','Q','K','A','H','D','C','S']
            dest = cards[result]
            end = timeit.timeit()
            
            # set dest as X if prediction is weak
            if score < 0.9:
                dest = 'X'

            # if the file is already in the destination then delete it
            if os.path.isfile('../../../data/card/'+dest+'/'+os.path.basename(filename)):
                os.remove(filename)
            # otherwise, move the file to the destination
            else:
                shutil.move(filename, '../../../data/card/'+dest)
            
            # some output
            print(cards[result]+'='+str(score)+' - moved to '+dest+' in '+str(end - start)+'s')
                
    time.sleep(0.05)