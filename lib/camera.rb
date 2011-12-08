require 'disp3D'

module Disp3D
  class Camera
    attr_accessor :rotate
    attr_accessor :pre_translate
    attr_accessor :post_translate

    attr_reader :eye
    attr_accessor :scale

    attr_reader :obj_rep_length

    attr_accessor :projection

    PERSPECTIVE = 0
    ORTHOGONAL = 1

    def initialize()
      @rotate = Quat.from_axis(Vector3.new(1,0,0),0)
      @pre_translate = Vector3.new(0,0,0)
      @post_translate = Vector3.new(0,0,0)
      @eye = Vector3.new(0,0,1)
      @center = Vector3.new(0,0,0)
      @scale = 1.0

      @obj_rep_length = 10.0

      @angle = 30

      @projection = PERSPECTIVE
      @orth_scale = 1.0
    end

    def switch_projection
      if(@projection == PERSPECTIVE)
        @projection = ORTHOGONAL
      else
        @projection = PERSPECTIVE
      end
    end

    def reshape(w,h)
      GL.Viewport(0.0,0.0,w,h)
      set_projection_for_world_scene
    end

    def apply_position
      GLU.LookAt(@eye.x, @eye.y, @eye.z, @center.x, @center.y, @center.z, 0.0, 1.0, 0.0)
    end

    def apply_rotate
      GL.MultMatrix(@rotate.to_array)
    end

    def apply_attitude
      GL.Translate(pre_translate.x, pre_translate.y, pre_translate.z)
      apply_rotate
      GL.Scale(@scale, @scale, @scale)
      GL.Translate(post_translate.x, post_translate.y, post_translate.z)
    end

    def set_screen(w,h)
      if @projection == ORTHOGONAL
        GL.Ortho(-w*@orth_scale/2.0, w*@orth_scale/2.0, -h*@orth_scale/2.0, h*@orth_scale/2.0, -@obj_rep_length*10, @obj_rep_length*10)
      else
        GLU.Perspective(@angle, w.to_f()/h.to_f(), 0.1, @eye.z + @obj_rep_length*5.0)
      end
    end

    def viewport
      return GL.GetIntegerv(GL::VIEWPORT)
    end

    def set_projection_for_world_scene
      GL.MatrixMode(GL::GL_PROJECTION)
      GL.LoadIdentity()
      dmy, dmy, w,h = viewport
      set_screen(w,h)
    end

    def set_projection_for_camera_scene
      GL.MatrixMode(GL::GL_PROJECTION)
      GL.LoadIdentity()
      dmy, dmy, w,h = viewport
      GL.Ortho(-w/2, w/2, -h/2, h/2, -100, 100)
    end

    def unproject(screen_pos)
      set_projection_for_world_scene

      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      apply_position()
      vp = viewport
      projection = GL::GetDoublev(GL::PROJECTION_MATRIX)
      model_view = GL::GetDoublev(GL::MODELVIEW_MATRIX)
      GL.PopMatrix()

      unprojected = GLU::UnProject(screen_pos.x, vp[3] - screen_pos.y - 1, screen_pos.z, model_view, projection, vp)
      unprojected = Vector3.new(unprojected[0], unprojected[1], unprojected[2])

      unprojected -= @pre_translate
      rot_matrix = Matrix.from_quat(@rotate)
      unprojected = rot_matrix*unprojected
      unprojected /= @scale
      unprojected -= @post_translate
      return unprojected
    end

    def fit(radius)
      @obj_rep_length = radius
      fit_camera_pos
      @scale = 1.0
      dmy, dmy, w, h = viewport
      set_screen(w,h)
    end

    def fit_camera_pos
      # move camera pos for showing all objects
      dmy, dmy, w, h = viewport
      min_screen_size = [w, h].min
      eye_z = @obj_rep_length*(Math.sqrt(w*w+h*h)/min_screen_size.to_f)/(Math.tan(@angle/2.0*Math::PI/180.0))
      @eye = Vector3.new(0,0,eye_z)
      @orth_scale = @obj_rep_length/(min_screen_size.to_f)*2.0
    end

  end
end
