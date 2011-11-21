require 'disp3D'

module Disp3D
  class Node
    attr_accessor :translate # GMath3D::Vector3
    attr_accessor :rotate # GMath3D::Quat

    attr_reader :instance_id

    attr_accessor :parents # Array of Node

    @@path_id_hash = nil
    def initialize()
      @translate = nil
      @rotate = nil
      @parents = []
      @instance_id = gen_instance_id()
    end

    def self.init_path_id_hash
      @@path_id_hash = Hash.new
    end

    def self.from_path_id(id)
      return @@path_id_hash[id]
    end

    def pre_draw
      GL.PushMatrix()
      GL.Translate(translate.x, translate.y, translate.z) if(@translate)
      GL.MultMatrix(@rotate.to_array) if(@rotate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def box
      # should be implimented in child class
      raise
    end

private
    def gen_instance_id
      id_adding = GL.GenLists(1)
#      p "instance id : #{id_adding} is generated"
      return id_adding
    end

    @@path_id_list = Array.new()
    def gen_path_id
      id_adding = @@path_id_list.size
#      p "node id : #{id_adding} is generated"
      @@path_id_list.push(id_adding)
      return id_adding
    end
  end
end
