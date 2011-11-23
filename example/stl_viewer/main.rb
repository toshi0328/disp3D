$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'stl_viewer'

require 'qt_widget_gl'
require 'qt_widget_controller'

class STLViewerWindow < Qt::MainWindow
  attr_reader :gl_widget
  attr_reader :ctrl_widget

  slots 'open()',
        'about()',
        'aboutQt()'

  def initialize(parent = nil)
    super

    # init view, widgets
    @width = 800
    @height = 500

    createActions()
    createMenus()

    setupWidgets
    setupLayout

    setWindowTitle(tr("STL Viewer"))
    setMinimumSize(160, 160)

    # init controllers
    @doc_ctrl = DocumentCtrl.new(self)
  end

  def sizeHint()
    return Qt::Size.new(@width, @height)
  end

  def setupWidgets
    @gl_widget = QtWidgetGL.new(self)
    @gl_widget.width = 600
    @gl_widget.height = 400
    @gl_widget.setSizePolicy(Qt::SizePolicy::Expanding,Qt::SizePolicy::Expanding)

    @ctrl_widget = QTWidgetController.new(@gl_widget)
    @ctrl_widget.setSizePolicy(Qt::SizePolicy::Fixed,Qt::SizePolicy::Expanding)
  end

  def setupLayout()
    splitter = Qt::Splitter.new(Qt::Horizontal)
    splitter.addWidget(@gl_widget)
    splitter.addWidget(@ctrl_widget)
    setCentralWidget(splitter)
  end

  def createActions()
    @openAct = Qt::Action.new(tr("&Open..."), self)
    @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O") )
    @openAct.statusTip = tr("Open an stl file")
    connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))

    @aboutAct = Qt::Action.new(tr("&About"), self)
    @aboutAct.statusTip = tr("Show the application's About box")
    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))

    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
  end

  def createMenus()
    @fileMenu = menuBar().addMenu(tr("&File"))
    @fileMenu.addAction(@openAct)

    @helpMenu = menuBar().addMenu(tr("&Help"))
    @helpMenu.addAction(@aboutAct)
    @helpMenu.addAction(@aboutQtAct)
  end

  def open()
    @doc_ctrl.open
  end

  def about()
    Qt::MessageBox.about(self, tr("About Menu"),
                   tr("STL Viewer, Demo application using <b>disp3D</b> library."))
  end
end

#########################################
# MAIN start application
app = Qt::Application.new(ARGV)
window = STLViewerWindow.new
window.show
app.exec

#########################################
