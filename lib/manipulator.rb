require 'disp3D'

module Disp3D
  class Manipulator
    def mouse(button,state,x,y)
      if button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_DOWN then
        @start_x = x
        @start_y = y
        @drag_flg = true
      elsif state == GLUT::GLUT_UP then
        @drag_flg = false
      end
    end

    def motion(x,y)
      if @drag_flg then
        dx = x - @start_x
        dy = y - @start_y

        @camera.rotY += dx
        @camera.rotY = @camera.rotY % 360

        @camera.rotX += dy
        @camera.rotX = @camera.rotX % 360
      end
      @start_x = x
      @start_y = y
      GLUT.PostRedisplay()
    end

    def initialize(camera)
      @camera = camera
      @start_x = 0
      @start_y = 0
      @drag_flg = false

      GLUT.MouseFunc(method(:mouse).to_proc())
      GLUT.MotionFunc(method(:motion).to_proc())
    end
  end
end
