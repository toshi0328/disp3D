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
      GLUT.PassiveMotionFunc(method(:passive_motion).to_proc())
      super(width, height)
    end

    def idle_process(wait_sec = nil, &block)
      if(!wait_sec.nil?)
        new_block = lambda do
          @lasttime = Time.now if(@lasttime.nil?)
          interval = Time.now - @lasttime
          next if( interval < wait_sec)
          yield
          @lasttime = Time.now
        end
        GLUT.IdleFunc(new_block)
      else
        GLUT.IdleFunc(block)
      end
    end

    def update
      gl_display
    end

    def gl_display
      super
      GLUT.SwapBuffers
    end

    def reshape(w,h)
      @camera.reshape(w,h)
    end

    def mouse(button,state,x,y)
      if(state == GLUT::GLUT_UP)
        @mouse_release_proc.call(self, button, x, y) if( @mouse_release_proc != nil)
      elsif(state == GLUT::GLUT_DOWN)
        @mouse_press_proc.call(self, button, x, y) if( @mouse_press_proc != nil)
      end
      @manipulator.mouse(button,state,x,y)
    end

    def motion(x,y)
      @mouse_move_proc.call(self, x,y) if( @mouse_move_proc != nil)
      update = @manipulator.motion(x,y)
      if(update)
        GLUT.PostRedisplay()
      end
    end

    def passive_motion(x,y)
      @mouse_move_proc.call(self, x,y) if( @mouse_move_proc != nil)
    end

    def start
      fit
      GLUT.MainLoop()
    end
  end
end
