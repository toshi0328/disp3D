require 'disp3D'

module Disp3D
  class Node
    attr_accessor :pre_translate # GMath3D::Vector3
    attr_accessor :rotate # GMath3D::Quat
    attr_accessor :post_translate # GMath3D::Vector3

    attr_reader :name
    attr_reader :instance_id

    attr_accessor :parents # Array of Node

    @@path_id_hash = nil

    def initialize(name = nil)
      Util3D.check_arg_type(Symbol, name, true)

      @name = name
      @translate = nil
      @rotate = nil
      @parents = []
      @instance_id = gen_instance_id()
      Node.add_to_db(self) if(!name.nil?)
    end

    def self.init_path_id_hash
      @@path_id_hash = Hash.new
    end

    def self.from_path_id(id)
      return @@path_id_hash[id]
    end

    def pre_draw
      GL.PushMatrix()
      GL.Translate(pre_translate.x, pre_translate.y, pre_translate.z) if(@pre_translate)
      GL.MultMatrix(@rotate.to_array) if(@rotate)
      GL.Translate(post_translate.x, post_translate.y, post_translate.z) if(@post_translate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def box
      # should be implimented in child class
      raise
    end

    def ancestors
      rtn_ancestors_ary = []
      return ancestors_inner(rtn_ancestors_ary)
    end

    # add node to DB
    def self.add_to_db(node)
      Util3D.check_arg_type(Node, node)
      @node_db ||= Hash.new()
      key = node.name
      if(!@node_db.key?(key))
        @node_db[key] = node
      elsif(@node_db[key].kind_of?(Node))
        @node_db[key] = [@node_db[key], node]
      elsif(@node_db[key].kind_of?(Array))
        @node_db[key].push(node)
      else
        raise
      end
    end

    # find node by name from DB
    def self.find(node_name)
      Util3D.check_arg_type(Symbol, node_name)
      return @node_db[node_name]
    end

protected
    def create(hash)
      Util3D.check_key_arg(hash, :type)
      geom = hash[:geom]
      name = hash[:name]
      clazz = eval "Node" + hash[:type].to_s
      new_node = clazz.new(geom, name)
      hash.each do | key, value |
        next if( key == :geom or key == :type or key ==:name)
        new_node.send( key.to_s+"=", value)
      end
      return new_node
    end

    def transform(hash)
      Util3D.check_arg_type(Vector3, hash[:pre_translate], true)
      Util3D.check_arg_type(Vector3, hash[:rotate], true)
      Util3D.check_arg_type(Vector3, hash[:post_translate], true)

      @pre_translate = hash[:pre_translate] if(hash.key?(:pre_translate))
      @rotate = hash[:rotate] if(hash.key?(:rotate))
      @pre_translate = hash[:post_translate] if(hash.key?(:post_translate))
    end

    def ancestors_inner(rtn_ancestors_ary)
      parents.each do |parent|
        if(!rtn_ancestors_ary.include?(parent.instance_id))
          rtn_ancestors_ary.push(parent.instance_id)
          parent.ancestors_inner(rtn_ancestors_ary)
        end
      end
      return rtn_ancestors_ary
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
