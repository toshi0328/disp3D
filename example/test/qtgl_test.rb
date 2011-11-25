$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'
require 'qt_widget_gl'

class TestQTGLWindow < Qt::Widget
  def initialize(parent = nil)
    super
    @gl_widget = QtWidgetGL.new(self)
#    @gl_widget.width = 600
#    @gl_widget.height = 400
    self.layout = Qt::HBoxLayout.new do |m|
      m.addWidget(@gl_widget)
    end
    self.windowTitle = tr("Hello GL")
    @is_first_show = true
  end

  def showEvent(eventArg)
    if( @is_first_show )
      node_tea_pod = Disp3D::NodeTeaPod.new(10)
      @gl_widget.gl_view.world_scene_graph.add(node_tea_pod)
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
