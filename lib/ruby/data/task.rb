#require 'yaml'

class Task
  attr_accessor :number, :question, :right, :variants, :image
end  

# task =  YAML::load( File.open( '/home/shem/workspace/swing/res/generate.yml' ) )
# puts task[1].number
# puts task[1].question
# puts task[1].variants[0]


