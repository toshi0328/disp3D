require 'disp3D'

module Disp3D
  class GLUTWindow < GLView
    GLUT.Init
    def initialize(width, height, title = "")
      x = 100
      y = 100
      GLUT.InitWindowPosition(x, y)
      GLUT.InitWindowSize(width, height)
      GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
      GLUT.CreateWindow(title)
      GLUT.DisplayFunc(method(:gl_display).to_proc())
      GLUT.ReshapeFunc(method(:reshape).to_proc())

      GLUT.MouseFunc(method(:mouse).to_proc())
      GLUT.MotionFunc(method(:motion).to_proc())
      GLUT.PassiveMotionFunc(method(:motion).to_proc())
      super(width, height)
    end

    def update
      gl_display
    end

    def gl_display
      super
      GLUT.SwapBuffers
    end

    def idle_process(wait_msec = nil, &block)
      if(!wait_msec.nil?)
        new_block = lambda do
          @lasttime = Time.now if(@lasttime.nil?)
          interval = Time.now - @lasttime
          next if( interval < wait_msec/1000.0)
          yield
          @lasttime = Time.now
        end
        GLUT.IdleFunc(new_block)
      else
        GLUT.IdleFunc(block)
      end
    end

    def start
      fit
      GLUT.MainLoop()
    end

private
    def mouse(button,state,x,y)
      if(state == GLUT::GLUT_UP)
        mouse_release_process(button, x, y)
      elsif(state == GLUT::GLUT_DOWN)
        mouse_press_process(button, x, y)
      end
    end

    def motion(x,y)
      need_update = mouse_move_process(x, y)
      if(need_update)
        GLUT.PostRedisplay()
      end
    end
  end
end
