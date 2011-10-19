require 'disp3D'

module Disp3D
  class NodeTeaPod
    def draw
      GLUT.SolidTeapot(0.5)
    end
  end
end
