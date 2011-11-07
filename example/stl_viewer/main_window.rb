$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'lib'))

require 'Qt'
require 'qt_widget_gl'
require 'qt_widget_controller'
require 'stl_viewer'

class STLViewerWindow < Qt::MainWindow
  attr_reader :gl_widget

  slots 'new()',
        'open()',
        'save()',
        'add_stl()',
        'about()',
        'aboutQt()'

  def initialize(parent = nil)
    super

    @gl_widget = QtWidgetGL.new(self)
    @gl_widget.width = 600
    @gl_widget.height = 400
    @gl_widget.setSizePolicy(Qt::SizePolicy::Expanding,Qt::SizePolicy::Expanding)

    @contoller_widget = QTWidgetController.new()
    @contoller_widget.setSizePolicy(Qt::SizePolicy::Fixed,Qt::SizePolicy::Expanding)

    setLayout()
    createActions()
    createMenus()

    setWindowTitle(tr("STL Viewer"))
    setMinimumSize(160, 160)

    # controllers
    @doc_ctrl = DocumentCtrl.new(self)
  end

  def setLayout()

    controller_dock_widget = Qt::DockWidget.new(tr("Controller"))
    controller_dock_widget.setWidget(@contoller_widget)
    controller_dock_widget.setAllowedAreas(Qt::RightDockWidgetArea)# | Qt::RightDockWidgetArea)
    addDockWidget(Qt::RightDockWidgetArea, controller_dock_widget)

    gl_view = Qt::VBoxLayout.new
    gl_view.margin = 5
    gl_view.addWidget(@gl_widget)

    main_layout = Qt::HBoxLayout.new
    main_layout.addLayout(gl_view)

    w = Qt::Widget.new
    setCentralWidget(w)
    w.layout = main_layout
  end

  def createActions()
    @newAct = Qt::Action.new(tr("&New..."), self)
    @newAct.shortcut = Qt::KeySequence.new( tr("Ctrl+N") )
    @newAct.statusTip = tr("Create new file")
    connect(@newAct, SIGNAL('triggered()'), self, SLOT('new()'))

    @openAct = Qt::Action.new(tr("&Open..."), self)
    @openAct.shortcut = Qt::KeySequence.new( tr("Ctrl+O") )
    @openAct.statusTip = tr("Open an existing file")
    connect(@openAct, SIGNAL('triggered()'), self, SLOT('open()'))

    @saveAct = Qt::Action.new(tr("&Save"), self)
    @saveAct.shortcut = Qt::KeySequence.new( tr("Ctrl+S") )
    @saveAct.statusTip = tr("Save the document to disk")
    connect(@saveAct, SIGNAL('triggered()'), self, SLOT('save()'))

    @addStlAct = Qt::Action.new(tr("&Add STL"), self)
    @addStlAct.shortcut = Qt::KeySequence.new( tr("Ctrl+A") )
    @addStlAct.statusTip = tr("Add STL file")
    connect(@addStlAct, SIGNAL('triggered()'), self, SLOT('add_stl()'))

    @aboutAct = Qt::Action.new(tr("&About"), self)
    @aboutAct.statusTip = tr("Show the application's About box")
    connect(@aboutAct, SIGNAL('triggered()'), self, SLOT('about()'))

    @aboutQtAct = Qt::Action.new(tr("About &Qt"), self)
    @aboutQtAct.statusTip = tr("Show the Qt library's About box")
    connect(@aboutQtAct, SIGNAL('triggered()'), $qApp, SLOT('aboutQt()'))
  end

  def createMenus()
    @fileMenu = menuBar().addMenu(tr("&File"))
    @fileMenu.addAction(@newAct)
    @fileMenu.addAction(@openAct)
    @fileMenu.addAction(@saveAct)
    @fileMenu.addAction(@addStlAct)

    @helpMenu = menuBar().addMenu(tr("&Help"))
    @helpMenu.addAction(@aboutAct)
    @helpMenu.addAction(@aboutQtAct)
  end

  def new()
    @doc_ctrl.new
  end

  def open()
    @doc_ctrl.open
  end

  def save()
    @doc_ctrl.save
  end

  def add_stl()
    @doc_ctrl.add_stl
  end

  def about()
    Qt::MessageBox.about(self, tr("About Menu"),
                   tr("STL Viewer, Demo application using <b>disp3D</b> library."))
  end
end
