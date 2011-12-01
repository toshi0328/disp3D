$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))
require 'disp3D'

main_view = Disp3D::GLUTWindow.new(600,400)

# load images
file_path1 = File.dirname(__FILE__) + '/data/test.png'
file_path2 = File.dirname(__FILE__) + '/data/test2.jpg'

image1 = Magick::Image.read(file_path1).first
image2 = Magick::Image.read(file_path2).first

length = 100

main_view.world_scene_graph.open do
  add_new :type => :Rectangle,
          :geom =>  Rectangle.new(Vector3.new(-200,0,0), Vector3.new(length,0,0), Vector3.new(0,length,0)),
          :image => image1

  add_new :type => :Rectangle,
          :geom =>  Rectangle.new(Vector3.new(0,0,0), Vector3.new(length,0,0), Vector3.new(0,length,0))

  add_new :type => :Rectangle,
          :geom =>  Rectangle.new(Vector3.new(200,0,0), Vector3.new(length,0,0), Vector3.new(0,length,0)),
          :image => image2
end

main_view.start
