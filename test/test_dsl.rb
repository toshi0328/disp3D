$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'helper'

include GMath3D

main_view = Disp3D::GLUTWindow.new(400,400)

main_view.start
