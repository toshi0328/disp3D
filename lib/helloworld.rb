require "rubygems"
require "opengl"
require "glut"

class Teapot
  LIGHT_POSITION = [0.25, 1.0, 0.25, 0.0]
  LIGHT_DIFFUSE  = [1.0, 1.0, 1.0]
  LIGHT_AMBIENT  = [0.25, 0.25, 0.25]
  LIGHT_SPECULAR = [1.0, 1.0, 1.0]

  MAT_DIFFUSE   = [1.0, 0.0, 0.0]
  MAT_AMBIENT   = [0.25, 0.25, 0.25]
  MAT_SPECULAR  = [1.0, 1.0, 1.0]
  MAT_SHININESS = [32.0]

  def reshape(w,h)
    GL.Viewport(0,0,w,h)

    GL.MatrixMode(GL::GL_PROJECTION)
    GL.LoadIdentity()
    GLU.Perspective(45.0, w.to_f()/h.to_f(), 0.1, 100.0)
#    GL.Ortho(-1,1,-1,1,2,4)
  end

  def display()
    GL.MatrixMode(GL::GL_MODELVIEW)
    GL.LoadIdentity()
    GLU.LookAt(0.5, 1.5, 2.5, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)

    GL.Lightfv(GL::GL_LIGHT0, GL::GL_POSITION, LIGHT_POSITION)
    GL.Lightfv(GL::GL_LIGHT0, GL::GL_DIFFUSE, LIGHT_DIFFUSE)
    GL.Lightfv(GL::GL_LIGHT0, GL::GL_AMBIENT, LIGHT_AMBIENT)
    GL.Lightfv(GL::GL_LIGHT0, GL::GL_SPECULAR, LIGHT_SPECULAR)

    GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, MAT_DIFFUSE)
    GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, MAT_AMBIENT)
    GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, MAT_SPECULAR)
    GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, MAT_SHININESS)

    GL.ClearColor(0.0, 0.0, 0.0, 1.0)
    GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)

    GL.Rotate(@rotX, 1, 0, 0)
    GL.Rotate(@rotY, 0, 1, 0)
    GLUT.SolidTeapot(0.5)

    GLUT.SwapBuffers()
  end

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

      @rotY += dx
      @rotY = @rotY % 360

      @rotX += dy
      @rotX = @rotX % 360
    end
    @start_x = x
    @start_y = y
    GLUT.PostRedisplay()
  end

  def initialize()
    @start_x = 0
    @start_y = 0
    @rotY = 0
    @rotX = 0
    @drag_flg = false
    GLUT.InitWindowPosition(100, 100)
    GLUT.InitWindowSize(300,300)
    GLUT.Init
    GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
    GLUT.CreateWindow("Ruby de OpenGL")

    GL.Enable(GL::GL_DEPTH_TEST)
    GL.Enable(GL::GL_LIGHTING)
    GL.Enable(GL::GL_LIGHT0)

    GL.FrontFace(GL::GL_CW)
    GL.Enable(GL::GL_AUTO_NORMAL)
    GL.Enable(GL::GL_NORMALIZE)
    GL.Enable(GL::GL_DEPTH_TEST)
    GL.DepthFunc(GL::GL_LESS)

    GL.ShadeModel(GL::SMOOTH)

    GLUT.ReshapeFunc(method(:reshape).to_proc())
    GLUT.DisplayFunc(method(:display).to_proc())
    GLUT.MouseFunc(method(:mouse).to_proc())
    GLUT.MotionFunc(method(:motion).to_proc())
  end

  def start()
    GLUT.MainLoop()
  end
end

Teapot.new().start()

