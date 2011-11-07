$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'main_window'

# start application
app = Qt::Application.new(ARGV)
window = STLViewerWindow.new
window.show
app.exec

