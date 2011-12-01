require 'disp3D'

module Disp3D
  class Node
    attr_accessor :pre_translate # GMath3D::Vector3
    attr_accessor :rotate # GMath3D::Quat
    attr_accessor :post_translate # GMath3D::Vector3

    attr_reader :name
    attr_reader :instance_id

    attr_accessor :parents # Array of Node

    def initialize(name = nil)
      Util3D.check_arg_type(Symbol, name, true)

      @name = name
      @translate = nil
      @rotate = nil
      @parents = []
      @instance_id = gen_instance_id()
      Node.add_to_node_name_db(self) if(!name.nil?)
    end

    # path id DB
    def self.init_path_db
      @path_db = Hash.new
    end

    def self.add_to_path_db(path_id, node)
      return @path_db[path_id] = node
    end

    def self.find_node_by_path_id(path_id)
      return @path_db[path_id]
    end

    # node name DB
    def self.add_to_node_name_db(node)
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

    def self.find_node_by_name(node_name)
      Util3D.check_arg_type(Symbol, node_name)
      return @node_db[node_name]
    end

    def self.delete_from_node_name_db_by_node(node)
      node_name = node.name
      if(!node_name.nil?)
        entry = find_node_by_name(node_name)
        if(entry == node)
          @node_db[node_name] = nil
        elsif(entry.kind_of?(Array))
          entry.reject!{|item| item == node}
        end
      end
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

    def ancestors
      rtn_ancestors_ary = []
      return ancestors_inner(rtn_ancestors_ary)
    end

protected
    def box_transform(box)
      box = box.translate(@pre_translate) if(@pre_translate)
      box = box.rotate(@rotate) if(@rotate)
      box = box.translate(@post_translate) if(@post_translate)
      return box
    end

    def create(hash)
      Util3D.check_key_arg(hash, :type)
      geom = hash[:geom]
      name = hash[:name]
      clazz = eval "Node" + hash[:type].to_s
      # node leaf constractor need 2 args
      if( clazz < NodeLeaf )
        new_node = clazz.new(geom, name)
      else
        new_node = clazz.new(name)
      end
      hash.each do | key, value |
        next if( key == :geom or key == :type or key ==:name)
        new_node.send( key.to_s+"=", value)
      end
      return new_node
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
    def remove(path_id)
      if(path_id.kind_of?(Integer))
        node = Node.find_node_by_path_id(path_id)
      else
        Util3D::raise_argurment_error(path_id)
      end
      node.parents.each do |parent|
        parent.remove_child_by_path_id(path_id)
      end
    end

    def delete(node_name)
      if( node_name.kind_of?(Node) )
        node = node_name
      elsif(node_name.kind_of?(Symbol))
        node = Node.find_node_by_name(node_name)
      else
        Util3D::raise_argurment_error(node_name)
      end
      if(node.kind_of?(Array))
        node.each do | item |
          self.delete(item)
        end
      end
      if(!node.nil?)
        node.parents.each do |parent|
          parent.remove_child_by_node(node)
        end
        Node.delete_from_node_name_db_by_node(node)
      end
    end

    def gen_instance_id
      id_adding = GL.GenLists(1)
      return id_adding
    end

    @@path_id_list = Array.new()
    def gen_path_id
      id_adding = @@path_id_list.size
      @@path_id_list.push(id_adding)
      return id_adding
    end
  end
end
