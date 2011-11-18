require 'disp3D'

module Disp3D
  class NodeCollection < Node

    def initialize()
      super
      @children = []
    end

    def add(node)
      # TODO if ancestor Node is added then cancel...
      # add parents and check
      if(node.kind_of?(Array))
        node.each do |item|
          @children.push(item)
        end
      else
        @children.push(node)
      end
    end

    def draw
      pre_draw()
      @children.each do |child|
        child.draw
      end
      post_draw()
    end

    def box
      return nil if @children == nil || @children.size == 0
      box = @children[0].box
      @children.each do |child|
        box += child.box
      end
      return box
    end
  end
end
