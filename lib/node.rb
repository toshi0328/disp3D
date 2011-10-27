require 'disp3D'

module Disp3D
  class Node
    attr_accessor :translate

    def pre_draw
      GL.PushMatrix()
      GL.Translate(translate[0], translate[1], translate[2]) if(@translate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def initialize(geometry)
      super
      @translate = nil
    end
  end
end
