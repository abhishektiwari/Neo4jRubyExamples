# Adopted from Neo4j wiki http://wiki.neo4j.org/content/Getting_Started_Ruby
require "rubygems"
require 'neo4j'

# Create one node
#
Neo4j::Transaction.run do
  #create a node and on property
  node = Neo4j::Node.new :age => 21
   
  #update the node with another property
  node[:name] = 'Anuj'
   
  #make a relationship to the reference node of type "dummy"
  node.add_rel(:MY_TYPE, Neo4j.ref_node)
   
  #add some properties to the relationship
  node.rels.outgoing.first.update(:weight => '1')
end

# Neo4j operations must be wrapped in a transaction.
# It can be done in two ways: Transaction - in a block 
# or the Transaction.new method
#
#  Neo4j::Transaction.run do
#    neo4j operations goes here
#  end
#
# or
#
# Neo4j::Transaction.new
#   neo4j operations goes here
# Neo4j::Transaction.finish
