require 'disp3D'

module Disp3D
  class SceneGraph
    attr_accessor :root_node

    def initialize()
      @root_node = NodeCollection.new()
    end

    def display()
      Node.init_node_list
      @root_node.draw()
    end

    def add(node)
      @root_node.add(node)
    end

    def bounding_box
      return @root_node.box
    end
  end
end
