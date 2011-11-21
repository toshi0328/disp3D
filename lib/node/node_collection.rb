require 'disp3D'

module Disp3D
  class NodeCollection < Node

    def initialize()
      super
      @children = Hash.new()
    end

    def add(node)
      # TODO if ancestor Node is added then cancel...
      # add parents and check processing
      if(node.kind_of?(Array))
        node.each do |item|
          self.add(item)
        end
      elsif(node.kind_of?(Node))
        # assign new path_id
        new_path_id = gen_path_id
        @children[new_path_id] = node
        node.parents.push(self)
      else
        raise # invalid Argument
      end
    end

    def draw
      pre_draw()
      @children.each do |key, node|
        if(node.kind_of?(NodeLeaf))
          @@path_id_hash[key] = node
          GL.LoadName(key)
        end
        node.draw
      end
      post_draw()
    end

    def box
      return nil if @children == nil || @children.size == 0
      rtnbox = nil
      @children.each do |key, node|
        if rtnbox.nil?
          rtnbox = node.box
        else
          rtnbox += node.box
        end
      end

      return rtnbox
    end

    def include?(path_id)
      @children.include?(path_id)
    end
  end
end
