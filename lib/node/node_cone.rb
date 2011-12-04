require 'disp3D'

module Disp3D
  class NodeCone < NodeLeaf
    attr_for_disp :radius
    attr_for_disp :height

    def initialize(geom=nil, name=nil)
      super
      @radius = 1.0
      @height = 3.0
      @slices = 10
      @stacks = 10
    end

    def box
      rtn_box = Box.new(Vector3.new(-@radius,-@radius,0), Vector3.new(@radius,@radius,@height))
      return box_transform(rtn_box)
    end

protected
    def draw_element
      draw_color
      GLUT.SolidCone(@radius, @height, @slices, @stacks)
    end
  end
end
