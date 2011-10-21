require 'disp3D'
require 'gmath3D'

include GMath3D

module Disp3D
  class Camera
    attr_accessor :rotation

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

      rot_mat = Matrix.from_quat(@rotation)
      rot_mat_array = [
        [rot_mat[0,0], rot_mat[0,1], rot_mat[0,2], 0],
        [rot_mat[1,0], rot_mat[1,1], rot_mat[1,2], 0],
        [rot_mat[2,0], rot_mat[2,1], rot_mat[2,2], 0],
        [0,0,0,1]]
      GL.MultMatrix(rot_mat_array)

      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)
    end

    def initialize()
      @rotation = Quat.from_axis(Vector3.new(1,0,0),0)
      GL.Enable(GL::GL_LIGHTING)
      GL.Enable(GL::GL_LIGHT0)

      GLUT.ReshapeFunc(method(:reshape).to_proc())
    end
  end
end
