require 'disp3D'

module Disp3D
  class Camera
    attr_accessor :rotation
    attr_accessor :translate
    attr_accessor :center
    attr_accessor :scale
    attr_accessor :is_orth

    def reshape(w,h)
      GL.Viewport(0,0,w,h)

      GL.MatrixMode(GL::GL_PROJECTION)
      GL.LoadIdentity()
      if @is_orgh
        GL.Ortho(-w/2.0, w/2.0, -h/2.0, h/2.0, -1000, 1000)
      else
        GLU.Perspective(45.0, w.to_f()/h.to_f(), 0.1, 100.0)
      end
    end

    def display()
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.LoadIdentity()
      GLU.LookAt(@eye.x, @eye.y, @eye.z, @center.x, @center.y, @center.z, 0.0, 1.0, 0.0)

      GL.Translate(translate[0], translate[1], translate[2]) if(@translate)
      rot_mat = Matrix.from_quat(@rotation)
      rot_mat_array = [
        [rot_mat[0,0], rot_mat[0,1], rot_mat[0,2], 0],
        [rot_mat[1,0], rot_mat[1,1], rot_mat[1,2], 0],
        [rot_mat[2,0], rot_mat[2,1], rot_mat[2,2], 0],
        [0,0,0,1]]

      GL.MultMatrix(rot_mat_array)
      GL.Scale(@scale, @scale, @scale)

      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)
    end

    def initialize()
      @rotation = Quat.from_axis(Vector3.new(1,0,0),0)
      @translate = [0.0,0.0,0.0]
      @eye = Vector3.new(0,0,5)
      @center = Vector3.new(0,0,0)
      @scale = 1
      @is_orgh = true
    end
  end
end
