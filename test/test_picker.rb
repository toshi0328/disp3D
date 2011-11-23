$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

MiniTest::Unit.autorun

class PickerTestCase < MiniTest::Unit::TestCase
  def test_pick_plane
    gl_view = Disp3D::GLUTWindow.new(400, 300)
    rect_geom = Rectangle.new(Vector3.new(-1,-1,2), Vector3.new(2,0,0), Vector3.new(0,2,0))
    rect_node = Disp3D::NodeTris.new(TriMesh.from_rectangle(rect_geom))
    gl_view.world_scene_graph.add(rect_node)
    gl_view.fit

    picked_result = gl_view.picker.pick(200,149)
    assert_equal(1, picked_result.size)
    picked_world_pos = picked_result[0].world_position

    precision = 0.001
    assert_in_delta(0.0, picked_world_pos.x, precision)
    assert_in_delta(0.0, picked_world_pos.y, precision)
    assert_in_delta(2.0, picked_world_pos.z, precision)
    assert_equal(1, picked_result[0].node_path_info.size)
    assert_equal(rect_node, picked_result[0].node_path_info[0].node)

    # translate model
    translate = Vector3.new(0.1, -0.3, 0.0)
    gl_view.camera.pre_translate = translate

    picked_result = gl_view.picker.pick(200,149)
    assert_equal(1, picked_result.size)
    picked_world_pos = picked_result[0].world_position
    assert_in_delta(-0.1, picked_world_pos.x, precision)
    assert_in_delta(0.3, picked_world_pos.y, precision)
    assert_in_delta(2.0, picked_world_pos.z, precision)
    assert_equal(1, picked_result[0].node_path_info.size)
    assert_equal(rect_node, picked_result[0].node_path_info[0].node)

    # translate more
    translate = Vector3.new(10, -3, 0.0)
    gl_view.camera.pre_translate = translate

    picked_result = gl_view.picker.pick(200,149)
    assert_equal(0, picked_result.size)
  end

  def test_pick_box
    gl_view = Disp3D::GLUTWindow.new(400, 300)
    box_geom = Box.new(Vector3.new(-1,-1,-1), Vector3.new(1,1,1))
    box_node = Disp3D::NodeTris.new(TriMesh.from_box(box_geom))
    gl_view.world_scene_graph.add(box_node)
    gl_view.fit

    picked_result = gl_view.picker.pick(200,149)
    assert_equal(1, picked_result.size)
    picked_world_pos = picked_result[0].world_position

    precision = 0.001
    assert_in_delta(0.0, picked_world_pos.x, precision)
    assert_in_delta(0.0, picked_world_pos.y, precision)
    assert_in_delta(1.0, picked_world_pos.z, precision)
    assert_equal(1, picked_result[0].node_path_info.size)
    assert_equal(box_node, picked_result[0].node_path_info[0].node)

    # rotate model
    angle_45 = 45.0*Math::PI/180.0
    gl_view.camera.rotate = Quat.from_axis(Vector3.new(1,0,0), angle_45)
    picked_result = gl_view.picker.pick(200,149)

    assert_equal(1, picked_result.size)
    picked_world_pos = picked_result[0].world_position
    assert_in_delta(0.0, picked_world_pos.x, precision)
    assert_in_delta(1.0, picked_world_pos.y, precision)
    assert_in_delta(1.0, picked_world_pos.z, precision)
    assert_equal(1, picked_result[0].node_path_info.size)
    assert_equal(box_node, picked_result[0].node_path_info[0].node)
  end

  def test_pick_multiple_objects
    gl_view = Disp3D::GLUTWindow.new(400, 300)
    box_geom = Box.new(Vector3.new(-1,-1,-1), Vector3.new(1,1,1))
    box_node = Disp3D::NodeTris.new(TriMesh.from_box(box_geom))
    rect_geom = Rectangle.new(Vector3.new(-1,-1,0.5), Vector3.new(2,0,0), Vector3.new(0,2,0))
    rect_node = Disp3D::NodeTris.new(TriMesh.from_rectangle(rect_geom))
    gl_view.world_scene_graph.add(box_node)
    gl_view.world_scene_graph.add(rect_node)
    gl_view.fit

    precision = 0.001
    picked_results = gl_view.picker.pick(200,149)
    assert_equal(2, picked_results.size)
    picked_results.each do |picked|
      assert_equal(1, picked.node_path_info.size)
      picked_world_pos = picked.world_position
      if( picked.node_path_info[0].node == rect_node)
        assert_in_delta(0.0, picked_world_pos.x, precision)
        assert_in_delta(0.0, picked_world_pos.y, precision)
        assert_in_delta(0.5, picked_world_pos.z, precision)
      elsif( picked.node_path_info[0].node == box_node)
        assert_in_delta(0.0, picked_world_pos.x, precision)
        assert_in_delta(0.0, picked_world_pos.y, precision)
        assert_in_delta(1.0, picked_world_pos.z, precision)
      end
    end
  end
end
