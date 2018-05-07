import sys

in_object  = open("input.txt", "r+")
out_object  = open("output_mapper.txt", "w")

for line in in_object:
	line = line.strip()
	elements = line.split(" ")
	page_rank = elements[1]
	number_of_links = elements[2]
	receiving_nodes = elements[3].split(",")
	for node in receiving_nodes:
		out_object.write(str(node))
		out_object.write("\t")
		out_object.write(str(number_of_links))
		out_object.write(",")
		out_object.write(str(page_rank))
		out_object.write("\n")

in_object.close() 
out_object.close() 
	
	