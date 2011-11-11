require 'opengl'

def gl_display
  GLU.LookAt(0,0,1, 0,0,0, 0,1,0)
  GL.Clear(GL::COLOR_BUFFER_BIT)
  GL.Flush()
end

def gl_reshape(w,h)
  GL.Viewport(0,0,w,h)
  GL.MatrixMode(GL::PROJECTION)
  GL.LoadIdentity()
  GLU.Perspective(45, w.to_f/h.to_f, 1, 100)
  GL.MatrixMode(GL::MODELVIEW)
  GL.LoadIdentity()
end

def mouse(button, state, x, y)
  if( button == GLUT::LEFT_BUTTON)
    if( state == GLUT::DOWN)
      viewport = GL.GetIntegerv(GL::VIEWPORT)
      model_view_matrix = GL.GetDoublev(GL::MODELVIEW_MATRIX)
      projection_matrix = GL.GetDoublev(GL::PROJECTION_MATRIX)
      real_y = viewport[3] - y - 1
      wx, wy, wz = GLU.UnProject(x, real_y, 0, model_view_matrix, projection_matrix, viewport)
      p "x = #{x}, y = #{y}"

      p "z = 0"
      p "wx:#{wx}, wy:#{wy}, wz:#{wz}"

      wx, wy, wz = GLU.UnProject(x, real_y, 1, model_view_matrix, projection_matrix, viewport)
      p "z = 1"
      p "wx:#{wx}, wy:#{wy}, wz:#{wz}"
    end
  end
end

GLUT.Init
GLUT.InitDisplayMode(GLUT::GLUT_SINGLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
GLUT.InitWindowPosition(100, 100)
GLUT.InitWindowSize(300, 200)
GLUT.CreateWindow("unprojected test")
GLUT.DisplayFunc(method(:gl_display).to_proc())
GLUT.ReshapeFunc(method(:gl_reshape).to_proc())
GLUT.MouseFunc(method(:mouse).to_proc())
GLUT.MainLoop()


