require 'disp3D'

include GMath3D
module Disp3D
  class Manipulator
    def initialize(camera, w, h)
      @camera = camera
      @start_x = 0
      @start_y = 0
      @w = w
      @h = h

      @moving = false
      @scalling = false
      @translating = false

      @trackball_size = 0.8
      GLUT.MouseFunc(method(:mouse).to_proc())
      GLUT.MotionFunc(method(:motion).to_proc())
    end

    def mouse(button,state,x,y)
      if (state == GLUT::GLUT_DOWN &&
          ((button == GLUT::GLUT_RIGHT_BUTTON && @moving == true) ||
          (button == GLUT::GLUT_LEFT_BUTTON && @scalling == true) ))
        # pushed left and right at the same time
        @translating = true
        @start_x = x
        @start_y = y
      elsif (button == GLUT::GLUT_RIGHT_BUTTON && state == GLUT::GLUT_DOWN)
        @scalling = true
        @start_y = y
      elsif ( button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_DOWN )
        @moving = true
        @start_x = x
        @start_y = y
      elsif ( button == GLUT::GLUT_RIGHT_BUTTON && state == GLUT::GLUT_UP )
        @scalling = false
        @translating = false
      elsif ( button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_UP )
        @moving = false
        @translating = false
      end
    end

    def motion(x,y)
      if( @translating )
        delta_x = 2*((@start_x - x).to_f/@w)
        delta_y = 2*((@start_y - y).to_f/@h)
        @start_x = x
        @start_y = y

        @camera.translate[0] -= delta_x
        @camera.translate[1] += delta_y
        GLUT.PostRedisplay()
      elsif ( @scalling )
        @camera.scale *= (1.0+(@start_y - y).to_f/@h)
        @start_y = y
        GLUT.PostRedisplay()
      elsif ( @moving )
        @lastquat =trackball(
                   (2.0 * @start_x - @w) / @w,
                   (@h - 2.0 * @start_y) / @h,
                   (2.0 * x - @w) / @w,
                   (@h - 2.0 * y) / @h)
        @start_x = x
        @start_y = y

        @camera.rotation = @lastquat * @camera.rotation if( @lastquat )

        GLUT.PostRedisplay()
      end
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