
import numpy as np


# RGB2XYZ Convert RGB colors to XYZformat
# Author: Timothy Sipkens
# Data:   September 30, 2019
# Note:   Assumes RGB is in standard format (sRGB)
#=========================================================================#

def rgb2xyz(rgb):
    
    if np.any(np.any(rgb > 1)):
        rgb = rgb / 255 # convert from integer to 0 to 1 scale
    
    # Evaluate each of the xyz parameters. 
    # https://en.wikipedia.org/wiki/SRGB
    x = 0.4124 * rgb[:,[0]] + 0.3576 * rgb[:,[1]] + 0.1805 * rgb[:,[2]];
    y = 0.2126 * rgb[:,[0]] + 0.7152 * rgb[:,[1]] + 0.0722 * rgb[:,[2]];
    z = 0.0193 * rgb[:,[0]] + 0.1192 * rgb[:,[1]] + 0.9505 * rgb[:,[2]];
    
    xyz = np.concatenate((x, y, z), axis=1);
    
    return xyz


# RGB2LAB Convert RGB colors to LAB format
# Author: Timothy Sipkens
# Data:   September 18, 2020
#=========================================================================#
def rgb2lab(rgb):
    
    xyz = rgb2xyz(rgb);
    xr = xyz[:,[0]] / 0.950489;
    yr = xyz[:,[1]] / 1.00;
    zr = xyz[:,[2]] / 1.088840;
    
    f = lambda t: iif(t>((6/29)**3), t**(1/3), 1/3*(29/6)**2*t + 4/29);
    
    L = 116 * f(yr) - 16;
    a = 500 * (f(xr) - f(yr));
    b = 200 * (f(yr) - f(zr));
    lab = np.concatenate((L, a, b), axis=1);
    
    return lab
    
    
#== IIF ==================================================================#
#   An inline 'if' function
def iif(cond, val_true, val_false):
    
    out = np.zeros(np.shape(cond));
    out[cond] = val_true[cond];
    out[~cond] = val_false[~cond];
    
    return out
    
    
    
# RGB2LCH Convert RGB colors to LCH format
# Author: Timothy Sipkens, September 30, 2019
#=========================================================================%
def rgb2lch(rgb):
    
    lab = rgb2lab(rgb);
    l = lab[:,[0]];
    a = lab[:,[1]];
    b = lab[:,[2]];
    
    h = np.arctan2(a, b) * 180 / np.pi;
    h[h<0] = h[h<0] + 360;
    
    c = np.sqrt(a**2 + b**2);
    lch = np.concatenate((l, c, h), axis=1);
    
    return lch
    
    
    
