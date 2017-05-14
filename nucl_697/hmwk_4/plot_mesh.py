import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

arr = np.loadtxt('sim/10000.dat')

plt.plot(np.arange(len(arr[:,0]) - 1), arr[1:,0] - arr[:-1,0])

arruni = np.loadtxt('sim/00000.dat')

plt.plot(np.arange(len(arruni[:,0]) - 1), arruni[1:,0] - arruni[:-1,0])

plt.savefig('figtest.pdf', format='pdf')

arr2 = np.loadtxt('sim/10000.dat')

plt.clf()
plt.plot(arr2[:,0], arr2[:,1])

arr3 = np.loadtxt('sim/10003.dat')
plt.plot(arr3[:,0], arr3[:,1])

arr4 = np.loadtxt('sim/10004.dat')
plt.plot(arr4[:,0], arr4[:,1])

arr5 = np.loadtxt('sim/10005.dat')
plt.plot(arr5[:,0], arr5[:,1])

plt.savefig('difftest.pdf', format='pdf')