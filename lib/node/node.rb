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
      # should be implimented in child class
      raise
    end

private
    @@id_list = Array.new()
    def new_id()
#      p "constructed id list #{@@id_list}"
      id_adding = GL.GenLists(1)
      @@id_list.push(id_adding)
      return id_adding
    end
  end
end
