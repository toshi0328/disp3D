$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../../', 'lib'))

require 'disp3D'
require 'qt_widget_gl'

class TestQTGLWindow < Qt::Widget
  def initialize(parent = nil)
    super
    @gl_widget1 = QtWidgetGL.new(self, 300, 300)
    @gl_widget2 = QtWidgetGL.new(self, 300, 300)
    self.layout = Qt::HBoxLayout.new do |m|
      m.addWidget(@gl_widget1)
      m.addWidget(@gl_widget2)
    end
    self.windowTitle = tr("11_MultiView")
    @is_first_show = true
  end

  def showEvent(eventArg)
    if( @is_first_show )
      @gl_widget1.world_scene_graph.open do
        add_new :type => :TeaPod,
                :material_color => [1,1,0,1],
                :size => 10.0,
                :name => :pod
      end
      @gl_widget2.sync_to @gl_widget1
      @gl_widget1.camera.projection = Disp3D::Camera::ORTHOGONAL
      @gl_widget1.fit
      @gl_widget2.camera.projection = Disp3D::Camera::PERSPECTIVE
      @gl_widget2.fit
      @is_first_show = false
    end
  end
end

# start application
app = Qt::Application.new(ARGV)
window = TestQTGLWindow.new
window.show
app.exec
