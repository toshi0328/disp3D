require 'disp3D'

include GMath3D
module Disp3D
  class Manipulator
    def initialize(camera, picker)
      @camera = camera
      @picker = picker

      @start_x = 0
      @start_y = 0

      @rotating = false
      @scalling = false
      @translating = false
      @trackball_size = 0.8
    end

    def centering(scene_graph)
      @camera.pre_translate = Vector3.new()
      set_rotation_ceter(scene_graph.center)
    end

    def fit(scene_graph)
      centering(scene_graph)
      @camera.fit(scene_graph.radius)
    end

    def set_rotation_ceter(rot_center)
      scale = @camera.scale
      post_trans_vec = @camera.post_translate.to_column_vector
      pre_trans_vec = @camera.pre_translate.to_column_vector
      rot_mat = Matrix.from_quat(@camera.rotate)
      new_pre_translate = ( rot_mat.t * post_trans_vec * scale + pre_trans_vec ) +
        rot_mat.t * rot_center.to_column_vector * scale
      new_pre_translate = GMath3D::Vector3.new(new_pre_translate[0,0], new_pre_translate[1,0], new_pre_translate[2,0])
      @camera.pre_translate = new_pre_translate
      @camera.post_translate = rot_center*-1.0
    end

    def mouse(button,state,x,y)
      if (state == GLUT::GLUT_DOWN &&
          ((button == GLUT::GLUT_RIGHT_BUTTON && @rotating == true) ||
          (button == GLUT::GLUT_LEFT_BUTTON && @scalling == true) ))
        # pushed left and right at the same time
        @translating = true
        @start_x = x
        @start_y = y
      elsif (button == GLUT::GLUT_RIGHT_BUTTON && state == GLUT::GLUT_DOWN)
        @scalling = true
        @start_y = y
      elsif ( button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_DOWN )
        @rotating = true
        @start_x = x
        @start_y = y
      elsif ( button == GLUT::GLUT_MIDDLE_BUTTON && state == GLUT::GLUT_DOWN )
        set_clicked_point_as_rotation_center(x,y)
      elsif ( button == GLUT::GLUT_RIGHT_BUTTON && state == GLUT::GLUT_UP )
        @scalling = false
        @translating = false
      elsif ( button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_UP )
        @rotating = false
        @translating = false
      end
    end

    # return true if should be redisplay
    def motion(x,y)
      dmy, dmy, width, height = @camera.viewport()
      if( @translating )
        delta_x = 2*((@start_x - x).to_f/width)
        delta_y = 2*((@start_y - y).to_f/height)
        @start_x = x
        @start_y = y

        @camera.pre_translate.x -= delta_x*@camera.obj_rep_length
        @camera.pre_translate.y += delta_y*@camera.obj_rep_length
        return true
      elsif ( @scalling )
        @camera.scale *= (1.0+(@start_y - y).to_f/height)
        @start_y = y
        return true
      elsif ( @rotating )
        @lastquat =trackball(
                   (2.0 * @start_x - width) / width,
                   (height - 2.0 * @start_y) / height,
                   (2.0 * x - width) / width,
                   (height - 2.0 * y) / height)
        @start_x = x
        @start_y = y
        @camera.rotate = @lastquat * @camera.rotate if( @lastquat )
        return true
      end
      return false
    end

private
   def set_clicked_point_as_rotation_center(x,y)
     results = @picker.pick(x,y)
     nearest = results.min {|a,b| a.near <=> b.near}
     return if(nearest.nil?)
     set_rotation_ceter(nearest.world_position)
   end

    def project_to_sphere(r, x, y)
      d = Math.sqrt(x*x + y*y)
      if (d < r * Math.sqrt(2)/2) # inside sphere
        z = Math.sqrt(r*r - d*d)
      else
        t = r / Math.sqrt(2)
        z = t*t / d
      end
      return z
    end

    def trackball(p1x, p1y, p2x, p2y)
      if( p1x == p2x && p1y == p2y)
        return Quat.new(0,0,0,1)
      end

      p1 = Vector3.new( p1x, p1y, project_to_sphere(@trackball_size, p1x, p1y))
      p2 = Vector3.new( p2x, p2y, project_to_sphere(@trackball_size, p2x, p2y))
      a = p1.cross(p2)
      d = p1 - p2
      t = d.length / (2*@trackball_size)
      t = 1 if( t > 1)
      t = -1 if( t < -1 )
      phi = 2*Math.asin(t)
      a = a.normalize
      return Quat.from_axis(a, phi)
    end
  end
end
