import sys

sum = 0
for line in sys.stdin:
		line = line.strip()
		number = int(line)
		sum += number

pi = 4*sum/N
print(pi)

