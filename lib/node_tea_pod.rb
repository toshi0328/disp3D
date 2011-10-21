require 'disp3D'

module Disp3D
  class NodeTeaPod < Node
    def draw
      GLUT.SolidTeapot(0.5)
    end
  end
end
