require 'disp3D'

module Disp3D
  class NodeTeaPod < Node
    def draw
      pre_draw()
      GLUT.SolidTeapot(0.5)
      post_draw()
    end
  end
end
