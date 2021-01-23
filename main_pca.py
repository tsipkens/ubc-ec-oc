
import numpy as np
import convert
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# Read in CSV file with RGB and EC/OC data
rgb = np.genfromtxt('test.csv',delimiter=',')
ec = rgb[:,[3]]
oc = rgb[:,[4]]
rgb = rgb[:,[0,1,2]]

xyz = convert.rgb2xyz(rgb)
lab = convert.rgb2lab(rgb)
lch = convert.rgb2lch(rgb)


plt.plot(rgb[:,[0]], ec, '.')
plt.show()

plt.plot(rgb[:,[0]], oc, '.')
plt.show()


x = np.concatenate((rgb, ec / oc), axis=1)

pca = PCA(n_components=4)
pca.fit(x)

print('Components:')
print(pca.components_)

print('Pct. explained variance:')
print(pca.explained_variance_ / sum(pca.explained_variance_))



