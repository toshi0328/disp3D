require 'disp3D'

module Disp3D
  class Camera
    attr_accessor :rotation
    attr_accessor :translate
    attr_accessor :center
    attr_accessor :scale
    attr_accessor :is_orth

    def initialize()
      @rotation = Quat.from_axis(Vector3.new(1,0,0),0)
      @translate = nil
      @eye = Vector3.new(0,0,5)
      @center = Vector3.new(0,0,0)
      @scale = 1
      @angle = 30
      @is_orgh = false
      @near = 0.1
      @far = 100.0
    end

    def reshape(w,h)
      GL.Viewport(0.0,0.0,w,h)
      GL.MatrixMode(GL::GL_PROJECTION)
      GL.LoadIdentity()
      set_screen(w,h)
    end

    def display()
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.LoadIdentity()
      GLU.LookAt(@eye.x, @eye.y, @eye.z, @center.x, @center.y, @center.z, 0.0, 1.0, 0.0)

      GL.Translate(translate.x, translate.y, translate.z) if(@translate)
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

    def fit(radius, width, height)
      eye_z = radius / Math.sin(@angle/2.0*Math::PI/180.0)
      @eye = Vector3.new(0,0,eye_z)
      @near = radius - 1
      @far = eye_z + radius
      if @is_orgh
        min_screen = [width, height].min
        @scale = (min_screen.to_f/2.0)/radius
      else
        @scale = 1.0
      end
      set_screen(width,height)
    end

    def set_screen(w,h)
      @aspect = w.to_f()/h.to_f()
      if @is_orgh
        GL.Ortho(-w/2.0, w/2.0, -h/2.0, h/2.0, -@far*@scale*10, @far*@scale*10)
      else
        GLU.Perspective(@angle, @aspect, @near, @far)
      end
    end

  end
end
