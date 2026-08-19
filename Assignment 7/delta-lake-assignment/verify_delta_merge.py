from pathlib import Path
from pyspark.sql import SparkSession
from delta.tables import DeltaTable

# Establish the project file paths
working_dir = Path.cwd()
delta_jar = working_dir / 'delta-spark_2.12-3.2.0.jar'
delta_storage_jar = working_dir / 'delta-storage-3.2.0.jar'
delta_db_path = working_dir / 'delta_tables' / 'customer_master'

# Create the configured Spark session
spark = SparkSession.builder \
    .appName('Delta_SCD1_Validation') \
    .master('local[*]') \
    .config('spark.jars', f'{delta_jar},{delta_storage_jar}') \
    .config('spark.sql.extensions', 'io.delta.sql.DeltaSparkSessionExtension') \
    .config('spark.sql.catalog.spark_catalog', 'org.apache.spark.sql.delta.catalog.DeltaCatalog') \
    .getOrCreate()

spark.sparkContext.setLogLevel('ERROR')

# Read and prepare the initial customer dataset
raw_customers = spark.read.option('header', True).option('inferSchema', True).csv('data/customer_master.csv')
cleaned_customers = raw_customers.dropDuplicates(['ID', 'Name', 'City']).na.fill({'City': 'Mumbai'})
cleaned_customers.write.format('delta').mode('overwrite').save(str(delta_db_path))

# Read the incoming change records
update_customers = spark.read.option('header', True).option('inferSchema', True).csv('data/customer_incremental.csv')

# Apply the Type 1 Delta merge
delta_table = DeltaTable.forPath(spark, str(delta_db_path))
(
    delta_table.alias('target')
    .merge(update_customers.alias('source'), 'target.ID = source.ID')
    .whenMatchedUpdate(set={'Name': 'source.Name', 'City': 'source.City'})
    .whenNotMatchedInsertAll()
    .execute()
)

# Check the merged table for expected quality conditions
final_records = spark.read.format('delta').load(str(delta_db_path))
final_records.orderBy('ID').show(truncate=False)

print('row_count=', final_records.count())
print('duplicate_ids=', final_records.groupBy('ID').count().filter('count > 1').count())

spark.stop()
