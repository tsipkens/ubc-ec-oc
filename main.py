
import numpy as np
import convert

rgb = np.array([[232.1848,223.0044,184.3428]])


xyz = convert.rgb2xyz(rgb)
lab = convert.rgb2lab(rgb)
lch = convert.rgb2lch(rgb)
