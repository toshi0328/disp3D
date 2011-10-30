require 'disp3D'

module Disp3D
  class Node
    attr_accessor :translate

    @@named_nodes = nil
    def initialize(geometry)
      @translate = nil
    end

    def self.init_node_list
      @@named_nodes = Hash.new
    end

    def self.from_id(id)
      return @@named_nodes[id]
    end

    def pre_draw
      GL.PushMatrix()
      GL.Translate(translate[0], translate[1], translate[2]) if(@translate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def box
      raise
    end
  end
end
