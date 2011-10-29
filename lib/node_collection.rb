require 'disp3D'

module Disp3D
  class NodeCollection < Node
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

    def initialize()
      @children = []
    end
  end
end
