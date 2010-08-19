# Adopted from http://gist.github.com/394786
require 'rubygems'
require 'neo4j'
include Neo4j

# The location where the database will be stored on the disk
# By defult it stores in the script folder
Neo4j::Config[:storage_path] = '/home/molseek/Neo4JDB/recomondation_db'

# By default Lucene indexes are kept in memory
# We can store store indexes on disk instead
Lucene::Config[:store_on_file] = true
Lucene::Config[:storage_path] = '/home/molseek/Neo4Index/recomondation_ind'


Transaction.new
# Create some people
andreas = Node.new :name => 'andreas'
peter = Node.new :name => 'peter'
kalle = Node.new :name => 'kalle'
sune = Node.new :name => 'sune'
adam = Node.new :name => 'adam'

# Create some composers/artists
madonna = Node.new :name => 'madonna'
beethoven = Node.new :name => 'beethoven'
schubert = Node.new :name => 'schubert'
brahms = Node.new :name => 'brahms'
pink_floyed = Node.new :name => 'pink floyed'
grieg = Node.new :name => 'grieg'
mozart = Node.new :name => 'mozart'

# Make relationships, who like what music
adam.rels.outgoing(:likes) << beethoven << brahms << grieg << mozart << pink_floyed
andreas.rels.outgoing(:likes) << beethoven << brahms << mozart
peter.rels.outgoing(:likes) << beethoven << brahms << schubert
kalle.rels.outgoing(:likes) << brahms << pink_floyed
sune.rels.outgoing(:likes) << pink_floyed << madonna


# Utility method, returns an array of composer nodes
#
def composers_for(person)
  [*person.outgoing(:likes)]
end

# Prints out recommendations for the given person
#
def recommend(person)
  # which composers does this person like ?
  my_composers = composers_for(person)

  # find all other people liking those composers
  other_people = person.outgoing(:likes).incoming(:likes).depth(2).filter{|f| f.depth == 2}

  # for each of those people, sort by the number of matching composers
  # so that the most relevant recommendations are printed first
  other_people.sort_by{|p| (composers_for(p) & my_composers).size}.reverse.each do |other_person|
    # then print out those composers that he don't have
    puts "Recommendation from #{other_person[:name]}"
    (composers_for(other_person) - my_composers).each do |s|
      puts "  composer #{s[:name]}"
    end
  end
end

recommend(andreas)

Transaction.finish