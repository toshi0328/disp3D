require 'helper'

class ManipulatorTestCase < Minitest::Test
  def setup
    @gl_view = Disp3D::GLUTWindow.new(300, 300)
  end

  def test_set_rotation_ceter
    pre_translate = Vector3.new(100,130,50)
    @gl_view.camera.pre_translate = pre_translate
    @gl_view.camera.scale = 2.5
    angle_30 = 30.0*Math::PI/180.0
    @gl_view.camera.rotate = Quat.from_axis(Vector3.new(1,1,1).normalize, angle_30)
    @gl_view.camera.post_translate = Vector3.new(-40,10.5,-15.5)

    screen_pos = Vector3.new(20,150,30)
    unprojected = @gl_view.camera.unproject(screen_pos)

    # center_position changes post_translate but all projection matrix is not changed
    rot_center = Vector3.new(10,5,-3)
    @gl_view.manipulator.set_rotation_ceter(rot_center)

    assert(pre_translate != @gl_view.camera.pre_translate)
    assert_equal( rot_center*-1.0, @gl_view.camera.post_translate)
    assert_equal( unprojected, @gl_view.camera.unproject(screen_pos))
  end

  # TODO
  def test_mouse
  end
  def test_motion
  end
end
