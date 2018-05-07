from pyspark import SparkConf, SparkContext

#run on cluster
confCluster = SparkConf()
confCluster.setAppName("Spark Test Cluster")

#run on local machine
confLocal = SparkConf().setMaster("local").setAppName("Spark Test Local")		

sc = SparkContext(conf = confCluster)

lines = sc.textFile("gutenberg/pg20417.txt")
filtered = lines.filter( lambda x: "word" in x)
c = filtered.count()

output = "Filtered line count = " + str(c) + "\n"

print(output)

# write to frontend
text_file = open("Output.txt", "w")
text_file.write(output)
text_file.close()

# write to HDFS folder
sc.parallelize([output]).saveAsTextFile("output")