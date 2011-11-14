require 'disp3D'

module Disp3D
  class Camera
    attr_accessor :rotation
    attr_accessor :pre_translate
    attr_accessor :post_translate

    attr_reader :eye
    attr_accessor :scale

    attr_accessor :is_orth

    def initialize()
      @rotation = Quat.from_axis(Vector3.new(1,0,0),0)
      @pre_translate = Vector3.new(0,0,0)
      @post_translate = Vector3.new(0,0,0)
      @eye = Vector3.new(0,0,1)
      @center = Vector3.new(0,0,0)
      @scale = 1.0

      @obj_rep_length = 10.0

      @angle = 30

      @is_orth = false
      @orth_scale = 1.0
    end

    def reshape(w,h)
      GL.Viewport(0.0,0.0,w,h)
      GL.MatrixMode(GL::GL_PROJECTION)
      GL.LoadIdentity()
      set_screen(w,h)
    end

    def apply_position()
      GLU.LookAt(@eye.x, @eye.y, @eye.z, @center.x, @center.y, @center.z, 0.0, 1.0, 0.0)
    end

    def apply_rotation()
      rot_mat = Matrix.from_quat(@rotation)
      rot_mat_array = [
        [rot_mat[0,0], rot_mat[0,1], rot_mat[0,2], 0],
        [rot_mat[1,0], rot_mat[1,1], rot_mat[1,2], 0],
        [rot_mat[2,0], rot_mat[2,1], rot_mat[2,2], 0],
        [0,0,0,1]]
      GL.MultMatrix(rot_mat_array)
    end

    def apply_attitude()
      GL.Translate(pre_translate.x, pre_translate.y, pre_translate.z)
      apply_rotation
      GL.Scale(@scale, @scale, @scale)
      GL.Translate(post_translate.x, post_translate.y, post_translate.z)
    end

    def set_screen(w,h)
      if @is_orth
        GL.Ortho(-w*@orth_scale/2.0, w*@orth_scale/2.0, -h*@orth_scale/2.0, h*@orth_scale/2.0, -@obj_rep_length*10, @obj_rep_length*10)
      else
        GLU.Perspective(@angle, w.to_f()/h.to_f(), 0.1, @eye.z + @obj_rep_length*5.0)
      end
    end

    def viewport
      return GL.GetIntegerv(GL::VIEWPORT)
    end

    def unproject(screen_pos)
      vp = viewport
      projection = GL::GetDoublev(GL::PROJECTION_MATRIX)
      model_view = GL::GetDoublev(GL::MODELVIEW_MATRIX)
      unprojected = GLU::UnProject(screen_pos.x, vp[3]-screen_pos.y-1, screen_pos.z, model_view, projection, vp)
      unprojected = Vector3.new(unprojected[0], unprojected[1], unprojected[2])
      unprojected.z += @eye.z

      unprojected -= @pre_translate
      rot_matrix = Matrix.from_quat(@rotation)
      unprojected = rot_matrix*unprojected
      unprojected /= @scale
      unprojected -= @post_translate
      return unprojected
    end

    def fit_camera_pos
      # move camera pos for showing all objects
      dmy, dmy, w, h = viewport
      min_screen_size = [w, h].min
      eye_z = @obj_rep_length*(Math.sqrt(w*w+h*h)/min_screen_size.to_f)/(Math.tan(@angle/2.0*Math::PI/180.0))
      @eye = Vector3.new(0,0,eye_z)
      @orth_scale = @obj_rep_length/(min_screen_size.to_f)*2.0
    end

    def fit(radius)
      @obj_rep_length = radius
      fit_camera_pos
      @scale = 1.0
      dmy, dmy, w, h = viewport
      set_screen(w,h)
    end
  end
end
