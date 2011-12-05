require 'disp3D'

module Disp3D
  class NodeSphere < NodeLeaf
    attr_for_disp :radius
    attr_for_disp :center

    def initialize(geom=nil, name=nil)
      super
      @radius = 1.0
      @center = Vector3.new()
      @slices = 10
      @stacks = 10
    end

    def box
      rtn_box = Box.new(Vector3.new(-@radius,-@radius,-@radius)+@center, Vector3.new(@radius,@radius,@radius)+@center)
      return box_transform(rtn_box)
    end

protected
    def draw_element
      draw_color
      GL.Translate(@center.x, @center.y, @center.z) if(@center)
      GLUT.SolidSphere(@radius, @slices, @stacks)
    end
  end
end
