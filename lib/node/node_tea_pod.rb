require 'disp3D'

module Disp3D
  class NodeTeaPod < NodeLeaf
    attr_accessor :size

    def initialize(geom = nil, name = nil, size)
      super(geom, name)
      @size = size
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
