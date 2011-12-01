require 'disp3D'

module Disp3D
  class Node
    attr_accessor :pre_translate # GMath3D::Vector3
    attr_accessor :rotate # GMath3D::Quat
    attr_accessor :post_translate # GMath3D::Vector3

    attr_reader :name
    attr_reader :instance_id
    attr_reader :parents # Array of Node

    def initialize(name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      @parents = []
      @instance_id = gen_instance_id()
      @name = name
      NodeDB.add_to_db(self) if(!name.nil?)
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
    def create(hash)
      Util3D.check_key_arg(hash, :type)
      geom_arg = hash[:geom]
      name_arg = hash[:name]
      clazz = eval "Node" + hash[:type].to_s
      # node leaf constractor need 2 args
      if( clazz < Disp3D::NodeLeaf )
        new_node = clazz.new(geom_arg, name_arg)
      elsif( clazz <= Disp3D::NodeCollection )
        new_node = clazz.new(name_arg)
      else
        raise
      end
      hash.each do | key, value |
        next if( key == :geom or key == :type or key ==:name)
        new_node.send( key.to_s+"=", value)
      end
      return new_node
    end

    def box_transform(box)
      box = box.translate(@pre_translate) if(@pre_translate)
      box = box.rotate(@rotate) if(@rotate)
      box = box.translate(@post_translate) if(@post_translate)
      return box
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
    def delete(node_name)
      if( node_name.kind_of?(Node) )
        node = node_name
      elsif(node_name.kind_of?(Symbol))
        node = NodeDB.find_node_by_name(node_name)
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
        NodeDB.delete_from_node_name_db_by_node(node)
      end
    end

    def gen_instance_id
      id_adding = GL.GenLists(1)
      return id_adding
    end
  end

  class NodeDB
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

    def self.find_by_name(node_name)
      @node_db ||= Hash.new()
      Util3D.check_arg_type(Symbol, node_name)
      return @node_db[node_name]
    end

    def self.delete_from_node_name_db_by_node(node)
      @node_db ||= Hash.new()
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
  end
end
