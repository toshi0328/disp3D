require 'disp3D'

module Disp3D
  class NodeTeaPod < NodeLeaf
    attr_for_disp :size

    def initialize(geom=nil, name=nil)
      super
      @size = 1.0
    end

    def box
      return Box.new(Vector3.new(-@size, -@size, -@size),Vector3.new(@size, @size, @size))
    end

protected
    def draw_element
      draw_color
      GLUT.SolidTeapot(@size)
    end
  end
end
