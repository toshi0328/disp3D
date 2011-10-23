$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

require 'Qt'

class TestQTGLWindow < Qt::Widget
  def initialize(parent = nil)
    super
    @gl_widget = QtWidgetGL.new(self)
    @gl_widget.width = 600
    @gl_widget.height = 400
    self.layout = Qt::HBoxLayout.new do |m|
      m.addWidget(@gl_widget)
    end
    self.windowTitle = tr("Hello GL")
  end
end

# start application
app = Qt::Application.new(ARGV)
window = TestQTGLWindow.new
window.show
app.exec

#TODO how to add node to scene graph...
