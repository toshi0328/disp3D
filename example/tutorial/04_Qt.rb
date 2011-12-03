$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'
require 'qt_widget_gl'

class TestQTGLWindow < Qt::Widget
  def initialize(parent = nil)
    super
    @gl_widget = QtWidgetGL.new(self, 300, 300)
    self.layout = Qt::HBoxLayout.new do |m|
      m.addWidget(@gl_widget)
    end
    self.windowTitle = tr("04_Qt")
    @is_first_show = true
  end

  def showEvent(eventArg)
    if( @is_first_show )
      @gl_widget.gl_view.world_scene_graph.open do
        add_new :type => :TeaPod,
                :material_color => [1,1,0,1],
                :size => 10.0
      end
      @gl_widget.gl_view.camera.projection = Disp3D::Camera::ORTHOGONAL
      @gl_widget.gl_view.fit
      @is_first_show = false
    end
  end
end

# start application
app = Qt::Application.new(ARGV)
window = TestQTGLWindow.new
window.show
app.exec
