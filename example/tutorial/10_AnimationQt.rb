$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'
require 'qt_widget_gl'

class TestQTGLWindow < Qt::Widget
  def initialize(parent = nil)
    super
    @gl_widget = QtWidgetGL.new(self, 600, 400)
    self.layout = Qt::HBoxLayout.new do |m|
      m.addWidget(@gl_widget)
    end
    self.windowTitle = tr("10_AnimationQt")
    @is_first_show = true

    define_idle_process
  end

  def define_idle_process
    @gl_widget.idle_process 100 do
      node = Disp3D::NodeDB.find_by_name(:pod)
      if(!node.nil?)
        rot_quat = Quat::from_axis(Vector3.new(0,1,0), 10.0/180.0*Math::PI)
        if(node.rotate.nil?)
          node.rotate = rot_quat
        else
          node.rotate += rot_quat
        end
      end
      @gl_widget.update
    end
  end

  def showEvent(eventArg)
    if( @is_first_show )
      @gl_widget.world_scene_graph.open do
        add_new :type => :TeaPod,
                :material_color => [1,1,0,1],
                :size => 10.0,
                :name => :pod
      end
      @gl_widget.camera.projection = Disp3D::Camera::ORTHOGONAL
      @gl_widget.fit
      @is_first_show = false
    end
  end
end

# start application
app = Qt::Application.new(ARGV)
window = TestQTGLWindow.new
window.show
app.exec
