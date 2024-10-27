#!/usr/bin/python3
import random
machineid=""
for i in range(0, 32): machineid += str(random.choice([0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f']))
print(machineid)
