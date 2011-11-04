require 'disp3D'

module Disp3D
  class NodeTeaPod < NodeLeaf

    def box
      return Box.new(Vector3.new(-0.5, -0.5, -0.5),Vector3.new(0.5, 0.5, 0.5))
    end

protected
    def draw_element
      draw_color
      GL.ShadeModel(GL::SMOOTH)
      GLUT.SolidTeapot(0.5)
    end
  end
end
