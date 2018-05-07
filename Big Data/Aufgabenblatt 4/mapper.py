import sys
import random

for line in sys.stdin:
	line = line.strip()
	numbers = int(line)
	for number in range(0,numbers):
		x = random.uniform(0, 1)
		y = random.uniform(0, 1)
		if (x**2 + y**2 <= 1):
			sum = 1
		else:
			sum = 0
		print('%s\t%s' % 1,sum)


