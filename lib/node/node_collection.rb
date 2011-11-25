require 'disp3D'

module Disp3D
  class NodeCollection < Node
    def initialize()
      super
      @children = Hash.new()
    end

    # returns generated path_id
    def add(node)
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
        adding_box = node.box
        adding_box = adding_box.translate(@pre_translate) if(@pre_translate)
        adding_box = adding_box.rotate(@rotate) if(@rotate)
        adding_box = adding_box.translate(@post_translate) if(@post_translate)
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
  end
end
