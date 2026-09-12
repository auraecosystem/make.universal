from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("LoadLibSVMDataset").getOrCreate()

# Load the file directly as a LIBSVM dataset
df = spark.read.format("libsvm").load("data.libsvm")

df.printSchema()
df.show(5, truncate=False)
