require 'disp3D'

module Disp3D
  class GLUTWindow < GLView
    def initialize(width, height)
      x = 100
      y = 100
      GLUT.InitWindowPosition(x, y)
      GLUT.InitWindowSize(width, height)
      GLUT.Init
      GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
      GLUT.CreateWindow("Disp3D view test")
      GLUT.DisplayFunc(method(:display).to_proc())
      GLUT.ReshapeFunc(method(:reshape).to_proc())
      GLUT.MouseFunc(method(:mouse).to_proc())
      GLUT.MotionFunc(method(:motion).to_proc())
      super(width, height)
    end

    def display
      super
      GLUT.SwapBuffers()
    end

    def reshape(w,h)
      @camera.reshape(w,h)
    end

    def mouse(button,state,x,y)
      @manipulator.mouse(button,state,x,y)
    end

    def motion(x,y)
      update = @manipulator.motion(x,y)
      if(update)
        GLUT.PostRedisplay()
      end
    end

    def start
      GLUT.MainLoop()
    end

  end
end
