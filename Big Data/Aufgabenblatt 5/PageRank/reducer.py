import sys

in_object  = open("input_reducer.txt", "r+")
out_object  = open("output_reducer.txt", "w")

for line in in_object:
	line = line.strip()
	elements = line.split("\t")
	values = elements[1]
	gerade = str(i) for i in xrange(len(values)) if i % 2 == 0
	ungerade = str(i) for i in xrange(len(values)) if i % 2 != 0
	page_ranks_sending = values[gerade]
	number_of_links = values[ungerade]
	page_ranks = page_ranks_sending/number_of_links
	res = sum(page_ranks) 

	out_object.write(str(elements[0]))
	out_object.write("\t")
	out_object.write(str(res))
	out_object.write("\n")

in_object.close() 
out_object.close() 
