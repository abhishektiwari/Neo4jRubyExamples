# Adopted from Neo4j wiki http://wiki.neo4j.org/content/Getting_Started_Ruby
require "rubygems"
require "neo4j"

# The location where the database will be stored on the disk
# By defult it stores in the script folder
Neo4j::Config[:storage_path] = '/home/molseek/Neo4JDB/waypoint_db'

# By default Lucene indexes are kept in memory
# We can store store indexes on disk instead
Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = '/home/molseek/Neo4Index/waypoint_ind'

# Your domain model
#
class Waypoint
  include Neo4j::NodeMixin
  # The persistent properties of this class
  property :name, :lon, :lat
  # Friend relationships to other persons
  has_n :roads
  index :name
end
 
# Populate the db
#
Neo4j::Transaction.run do
  # The waypoints
  NYC = Waypoint.new :name=>'New York', :lon=>-74.007124, :lat=>40.714550
  SF  = Waypoint.new :name=>'San Francisco', :lon=>-122.420139, :lat=>37.779600
  SEA = Waypoint.new :name=>'Seattle', :lon=>-122.329439, :lat=>47.603560
  # The roads
  NYC.roads << SF
  NYC.roads << SEA
  SEA.roads << SF
end

# Search the db
#
Neo4j::Transaction.run do
  # Do a fulltext search over all Waypoints
  Waypoint.find(:name => 'New York').each { |x|
    puts "Found Waypoint: #{x.name}"
  }
end
