require 'disp3D'

module Disp3D
  class NodeCollection < Node
    def initialize(name = nil)
      super
      @children = Hash.new()
    end

    def open(&block)
      self.instance_eval(&block)
    end

    # returns generated path_id
    def add(node)
      if(node.kind_of?(Symbol))
        add_node_by_name(node)
      else
        add_node(node)
      end
    end

    def draw currnet_view
      pre_draw()
      @children.each do |key, node|
        if(node.kind_of?(NodeLeaf))
          NodePathDB.add(key, node)
          GL.LoadName(key)
        end
        node.draw currnet_view
      end
      post_draw()
    end

    def box
      return nil if @children == nil || @children.size == 0
      rtnbox = nil
      @children.each do |key, node|
        adding_box = box_transform(node.box)
        if rtnbox.nil?
          rtnbox = adding_box
        else
          rtnbox += adding_box
        end
      end
      return rtnbox
    end

    def include?(path_id)
      @children.include?(path_id)
    end

    def child(path_id)
      return @children[path_id]
    end

    def child_nodes
      return @children.values
    end

    def child_path_id
      return @children.keys
    end

protected
    def remove_child_by_path_id(path_id)
      @children.delete(path_id)
    end

    def remove_child_by_node(child_node)
      @children.reject!{|key, value| value == child_node}
    end

    def update_for_display
      @children.each do |key, node|
        node.update_for_display
      end
    end
private
    def add_new(node_info, &block)
      if(block_given?)
        create_and_add_node_by_block(node_info, &block)
      elsif(node_info.kind_of?(Hash))
        create_and_add_node(node_info)
      else
        Util3D.raise_argurment_error(node_info)
      end
    end

    def remove(path_id)
      if(path_id.kind_of?(Integer))
        node = NodePathDB.find_by_path_id(path_id)
      else
        Util3D::raise_argurment_error(path_id)
      end
      node.parents.each do |parent|
        parent.remove_child_by_path_id(path_id)
      end
    end

    def add_node_by_name(node_name)
      Util3D.check_arg_type(Symbol, node_name)
      nodes = NodeDB.find_by_name(node_name)
      add_node(nodes)
    end

    def add_node(node)
      ancestors_ary = self.ancestors
      if(node.kind_of?(Array))
        new_ids = Array.new(node.size)
        node.each_with_index do |item,i|
          new_ids[i] = self.add(item)
        end
        return new_ids
      elsif(node.kind_of?(Node))
        if(ancestors_ary.include?(node.instance_id) || node.instance_id == self.instance_id)
          raise CircularReferenceException
        end
        new_id = gen_path_id()
        @children[new_id] = node
        node.parents.push(self)
        return new_id
      else
        Util3D.raise_argurment_error(node)
      end
    end

    def create_and_add_node(hash)
      new_node = create(hash)
      add_node(new_node)
    end

    def create_and_add_node_by_block(hash, &block)
      hash[:type] = :Collection
      new_node = create(hash)
      new_node.instance_eval(&block) if(block_given?)
      add_node(new_node)
    end

    @@path_id_list = Array.new()
    def gen_path_id
      id_adding = @@path_id_list.size
      @@path_id_list.push(id_adding)
      return id_adding
    end
  end

  # hold path id and node connectivity
  class NodePathDB
    def self.init
      @path_db = Hash.new
    end

    def self.add(path_id, node)
      return @path_db[path_id] = node
    end

    def self.find_by_path_id(path_id)
      return @path_db[path_id]
    end
  end
end
