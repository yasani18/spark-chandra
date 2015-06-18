# see github repos & package documentation
# - http://github.com/apache/spark/tree/master/R
# - http://spark.apache.org/docs/latest/api/R/

# install the SparkR package
devtools::install_github("apache/spark", ref="master", subdir="R/pkg")

# load the SparkR package
library('SparkR')

# initialize sparkContext which starts a new Spark session
sc <- sparkR.init(master="local")

# initialize sqlContext
sq <- sparkRSQL.init(sc)

#  load a parquet file into a Spark DataFrame
df1 <- parquetFile(sq, "Downloads/opendata/hscic-gpreg/gp-reg-clean")

# print the schema
printSchema(df1)
#  print the first 20 rows, then the first 50 rows
showDF(df1)
showDF(df1, numRows=50)

# run aggregate query on Spark DataFrame
df2 <- agg(groupBy(df1, "ccg_code"), "patients" = sum(df1$patients))

# collect all the elements of Spark DataFrame and coerce into an R data.frame 
df3 <- collect(df2)

# visualise R data.frame
qplot(ccg_code, patients, data = df3)

# terminate Spark session
sparkR.stop()