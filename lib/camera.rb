require 'disp3D'

module Disp3D
  class Camera
    attr_accessor :rotX
    attr_accessor :rotY

    MAT_DIFFUSE   = [1.0, 1.0, 1.0]
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
      GLU.LookAt(0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)

      GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, MAT_DIFFUSE)
      GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, MAT_AMBIENT)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, MAT_SPECULAR)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, MAT_SHININESS)

      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)

      GL.Rotate(@rotX, 1, 0, 0)
      GL.Rotate(@rotY, 0, 1, 0)
    end

    def initialize()
      @rotY = 0
      @rotX = 0
      GL.Enable(GL::GL_LIGHTING)
      GL.Enable(GL::GL_LIGHT0)

      GLUT.ReshapeFunc(method(:reshape).to_proc())
    end
  end
end
