require 'disp3D'

module Disp3D
  class NodeTeaPod < NodeLeaf

protected
    def draw_element
      GLUT.SolidTeapot(0.5)
    end
  end
end
