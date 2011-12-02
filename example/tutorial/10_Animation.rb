$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

main_view.world_scene_graph.open do
  add_new :type => :Rectangle,
          :geom =>  Rectangle.new(Vector3.new(-50,0,0), Vector3.new(100,0,0), Vector3.new(0,100,0)),
          :name => :plane

  add_new :type => :Rectangle,
          :geom =>  Rectangle.new(Vector3.new(-50,0,-40), Vector3.new(100,0,0), Vector3.new(0,100,0)),
          :name => :plane2,
          :colors => [1,0,0,1]
end

main_view.idle_process 0.05 do
  node = Disp3D::NodeDB.find_by_name(:plane)
  if(!node.nil?)
    node.post_translate = Vector3.new() if(node.post_translate.nil?)
    node.post_translate += Vector3.new(3,0,0)
  end
  main_view.update
end

main_view.start
