require 'disp3D'

module Disp3D
  class SceneGraph
    attr_accessor :root_node

    def initialize()
      @root_node = NodeCollection.new()
    end

    def gl_display()
      Node.init_node_list
      @root_node.draw()
    end

    def add(node)
      @root_node.add(node)
    end

    def bounding_box
      return @root_node.box
    end

    def center
      bb = self.bounding_box
      return nil if bb.nil?
      return bb.center
    end

    def radius
      bb = self.bounding_box
      return 0 if bb.nil?
      length = bb.length
      orth_length = Math.sqrt( length[0]*length[0] + length[1]*length[1] + length[2]*length[2] )
      orth_length/2.0
    end

  end
end
