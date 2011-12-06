require 'disp3D'

module Disp3D
  class NodeCone < NodeLeaf
    attr_for_disp :radius
    attr_for_disp :height
    attr_for_disp :base_point
    attr_for_disp :direction

    def initialize(geom=nil, name=nil)
      super
      @radius = 1.0
      @height = 3.0
      @slices = 10
      @stacks = 10
      @base_point = Vector3.new()
      @direction = Vector3.new(0,0,1)
    end

    def box
      rtn_box = Box.new(Vector3.new(-@radius,-@radius,0), Vector3.new(@radius,@radius,@height))
      rtn_box = box_transform(rtn_box)
      rot = calc_rotate_from_direction
      rtn_box = rtn_box.rotate(rot) if(!rot.nil?)
      rtn_box = rtn_box.translate(@base_point)
      return rtn_box
    end

protected
    def draw_element
      GL.PushMatrix()
      rot = calc_rotate_from_direction
      GL.Translate(@base_point.x, @base_point.y, @base_point.z) if(@base_point)
      GL.MultMatrix(rot.to_array) if(!rot.nil?)
      draw_color
      GLUT.SolidCone(@radius, @height, @slices, @stacks)
      GL.PopMatrix()
    end

private
    def calc_rotate_from_direction
      return nil if(@direction.length < 1e-2)
      base_direction = Vector3.new(0,0,1)
      angle = base_direction.angle(@direction)
      axis = base_direction.cross(@direction)
      rotate = Quat.from_axis(axis, angle)
    end
  end
end
