require 'helper'

class CameraTestCase < Minitest::Test
  def setup
    gl_view = Disp3D::GLUTWindow.new(400, 300)
    @camera = gl_view.camera
    line_geom = FiniteLine.new(Vector3.new(0,0,0), Vector3.new(1,1,1))
    line_node = Disp3D::NodeLines.new(line_geom)
    line_node.width = 4
    gl_view.world_scene_graph.add(line_node)
  end


  def test_initialize
    assert_equal(Quat.from_axis(Vector3.new(1,0,0),0),@camera.rotate)
    assert_equal(Vector3.new(0,0,0), @camera.pre_translate)
    assert_equal(Vector3.new(0,0,0), @camera.post_translate)
    assert_equal(Vector3.new(0,0,1), @camera.eye)
    assert_equal(1.0, @camera.scale)

    assert_equal(10.0, @camera.obj_rep_length)
    assert_equal(Disp3D::Camera::PERSPECTIVE, @camera.projection)
  end

  def test_get_view_port
    viewport = @camera.viewport
    assert_equal(0, viewport[0])
    assert_equal(0, viewport[1])
    assert_equal(400, viewport[2])
    assert_equal(300, viewport[3])
  end

  def test_fit
    rad = 10.0
    @camera.fit(rad)
    assert_in_delta(62.20084679281463, @camera.eye.z, 1e-8)
    assert_in_delta(1.0, @camera.scale, 1e-8)
    assert_in_delta(10.0, @camera.obj_rep_length, 1e-8)

    @camera.projection = Disp3D::Camera::ORTHOGONAL
    @camera.fit(rad)
    assert_in_delta(62.20084679281463, @camera.eye.z, 1e-8)
    assert_in_delta(1.0, @camera.scale, 1e-8)
    assert_in_delta(10.0, @camera.obj_rep_length, 1e-8)
  end

  def test_unprojected
    screen_pos = Vector3.new(200,149,0.0)
    check_pricision = 1e-8
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(0.0, unprojected.x, check_pricision)
    assert_in_delta(0.0, unprojected.y, check_pricision)
    assert_in_delta(0.9, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.post_translate = Vector3.new(100,200)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(-100.0, unprojected.x, check_pricision)
    assert_in_delta(-200.0, unprojected.y, check_pricision)
    assert_in_delta(0.9, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.scale = 0.5
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(-100.0, unprojected.x, check_pricision)
    assert_in_delta(-200.0, unprojected.y, check_pricision)
    assert_in_delta(1.8,    unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.post_translate = Vector3.new(-50,30,0)
    @camera.scale = 2.0
    angle_30 = 30*Math::PI/180.0
    @camera.rotate = Quat.from_axis(Vector3.new(1,0,0),angle_30)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(50.0, unprojected.x, check_pricision)
    assert_in_delta(-30+(0.9*Math.sin(angle_30)*0.5), unprojected.y, check_pricision)
    assert_in_delta(0.9*Math.cos(angle_30)*0.5, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.pre_translate = Vector3.new(0,0,-5)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(50.0, unprojected.x, check_pricision)
    assert_in_delta(-30 + (5 + 0.9)*Math.sin(angle_30)*0.5 , unprojected.y, check_pricision)
    assert_in_delta((5 + 0.9)*Math.cos(angle_30)*0.5, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    #========= orth ============
    @camera.post_translate = Vector3.new()
    @camera.scale = 1.0
    @camera.rotate = Quat.from_axis(Vector3.new(1,0,0), 0.0)
    @camera.pre_translate = Vector3.new(0,0,0)

    @camera.projection = Disp3D::Camera::ORTHOGONAL
    screen_pos = Vector3.new(200,149,0.5)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(0.0, unprojected.x, check_pricision)
    assert_in_delta(0.0, unprojected.y, check_pricision)
    assert_in_delta(1.0, unprojected.z, check_pricision) # eye.z

    @camera.post_translate = Vector3.new(100,200)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(-100.0, unprojected.x, check_pricision)
    assert_in_delta(-200.0, unprojected.y, check_pricision)
    assert_in_delta(1.0, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.scale = 0.5
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(-100.0, unprojected.x, check_pricision)
    assert_in_delta(-200.0, unprojected.y, check_pricision)
    assert_in_delta(2.0,    unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.post_translate = Vector3.new(-50,30,0)
    @camera.scale = 2.0
    angle_30 = 30*Math::PI/180.0
    @camera.rotate = Quat.from_axis(Vector3.new(1,0,0),angle_30)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(50.0, unprojected.x, check_pricision)
    assert_in_delta(-30+(Math.sin(angle_30)*0.5), unprojected.y, check_pricision)
    assert_in_delta(Math.cos(angle_30)*0.5, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)

    @camera.pre_translate = Vector3.new(0,0,-5)
    unprojected = @camera.unproject(screen_pos)
    assert_in_delta(50.0, unprojected.x, check_pricision)
    assert_in_delta(-30 + (5 + 1)*Math.sin(angle_30)*0.5 , unprojected.y, check_pricision)
    assert_in_delta((5 + 1)*Math.cos(angle_30)*0.5, unprojected.z, check_pricision) # eye.z - 0.1(near plane from eye point)
  end

end
