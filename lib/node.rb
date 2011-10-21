require 'disp3D'

module Disp3D
  class Node
    attr_accessor :geom
    attr_accessor :translate
    attr_accessor :color

    def pre_draw
      GL.Color(@color[0], @color[1], @color[2]) if(@color && @color.size == 3)
      GL.Color(@color[0], @color[1], @color[2], @color[3]) if(@color && @color.size == 4)

      GL.PushMatrix()
      GL.Translate(translate[0], translate[1], translate[2]) if(@translate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def initialize(geometry)
      @geom = geometry
      @color = [1.0, 1.0, 1.0]
    end
  end
end
