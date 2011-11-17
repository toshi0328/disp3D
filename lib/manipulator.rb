require 'disp3D'

include GMath3D
module Disp3D
  class Manipulator
    def initialize(camera, w, h)
      @camera = camera
      @start_x = 0
      @start_y = 0

      @rotating = false
      @scalling = false
      @translating = false
      @trackball_size = 0.8

      @compass = Compass.new(camera)
    end

    def centering(scene_graph)
      # TODO this procedure is not considered about rotation and scalling!
      @camera.pre_translate = @camera.post_translate*-1.0 - center_pos(scene_graph)
    end

    def fit(scene_graph)
      centering(scene_graph)
      @camera.fit(bb_radius(scene_graph))
    end

    def center_pos(scene_graph)
      bb = scene_graph.bounding_box
      return nil if bb.nil?
      return bb.center
    end

    def bb_radius(scene_graph)
      bb = scene_graph.bounding_box
      return if bb.nil?
      length = bb.length # TODO refactaring box.rb
      orth_length = Math.sqrt( length[0]*length[0] + length[1]*length[1] + length[2]*length[2] )
      orth_length/2.0
    end

    def set_rotation_ceter(pos)
      # TODO If pre_translate is set...
      @camera.post_translate = pos*-1.0
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
        @camera.rotation = @lastquat * @camera.rotation if( @lastquat )
        return true
      end
      return false
    end

    def gl_display_compass
      @compass.gl_display()
    end

private
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
