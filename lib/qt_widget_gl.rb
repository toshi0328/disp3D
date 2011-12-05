require 'Qt'
require 'disp3D'

include Disp3D
class QtWidgetGL < Qt::GLWidget
  attr_accessor :width
  attr_accessor :height

  attr_reader :load_proc

  def initialize(parent, width = 400, height = 400)
    super(parent)
    @width = width
    @height = height

    @min_width = 50
    @min_height = 50
  end

  def dispose()
    super
  end

  def gl_view
    @view
  end

  def set_load_proc(proc)
    @load_proc = proc
  end

  def initializeGL()
    @view = Disp3D::GLView.new(@width, @height)
  end

  def minimumSizeHint()
    return Qt::Size.new(@min_width, @min_height)
  end

  def sizeHint()
    return Qt::Size.new(@width, @height)
  end

  def get_GLUT_button(event)
    return GLUT::GLUT_RIGHT_BUTTON if( event.button == Qt::RightButton)
    return GLUT::GLUT_MIDDLE_BUTTON if( event.button == Qt::MidButton)
    return GLUT::GLUT_LEFT_BUTTON if( event.button == Qt::LeftButton)
    return nil
  end

  def mouseReleaseEvent(event)
    glut_button = get_GLUT_button(event)
    @view.mouse_release_process(glut_button, event.pos.x, event.pos.y)
  end

  def mousePressEvent(event)
    glut_button = get_GLUT_button(event)
    @view.mouse_press_process(glut_button, event.pos.x, event.pos.y)
  end

  def mouseMoveEvent(event)
    need_update = @view.mouse_move_process(event.pos.x,event.pos.y)
    if(need_update)
      updateGL()
    end
  end

  def paintGL
    @view.gl_display
  end

  def resizeGL(width, height)
    @view.reshape(width, height)
  end

  def idle_process(wait_msec = nil, &block)
    @idle_proc = block
    @idle_process_timer_id = startTimer(wait_msec)
  end

  def timerEvent(event)
    if( event.timerId == @idle_process_timer_id)
      @idle_proc.call
    end
  end

end

