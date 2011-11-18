require 'disp3D'

module Disp3D
  class NodeTeaPod < NodeLeaf

    def initialize(size)
      @size = size
      super()
    end

    def box
      return Box.new(Vector3.new(-@size, -@size, -@size),Vector3.new(@size, @size, @size))
    end

protected
    def draw_element
      draw_color
      GL.ShadeModel(GL::SMOOTH)
      GLUT.SolidTeapot(@size)
    end
  end
end
