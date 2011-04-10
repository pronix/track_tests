require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'

require 'view/questpanel'
require 'view/statisticpanel'
require 'view/buttonpanel'
require 'view/statuspanel'
require 'view/resultpanel'
require 'view/authpanel'
require 'view/startpanel'
require 'view/translatepanel'

require 'model/tour'

include Swing
include Awt

class TourPanel < JPanel
  def initialize (parentFrame, tour)
    super BorderLayout.new(5,5)
    @tour = tour
    @tour.container = self
    
    @parentFrame = parentFrame
    @questPanel = QuestPanel.new(@tour)
    @statisticPanel = StatisticPanel.new(@tour)
    @buttonPanel = ButtonPanel.new(@tour)
    @statusPanel = StatusPanel.new(@tour)
    @translatepanel = TranslatePanel.new(@tour)

    add(@questPanel, BorderLayout::CENTER)

    panel = JPanel.new()
    panel.setLayout(BorderLayout.new())

    panel1 = JPanel.new()
    boxlayout = BoxLayout.new(panel1, BoxLayout::Y_AXIS)
    panel1.setLayout(boxlayout)
    panel1.add(@buttonPanel)
    panel1.add(Box.createRigidArea(Dimension.new(0, 5)))
    panel1.add(@statisticPanel)
    if @tour.translateTaskExists
      panel1.add(Box.createRigidArea(Dimension.new(0, 5)))
      panel1.add(@translatepanel)
    end

    panel.add(panel1, BorderLayout::PAGE_START)
    panel.add(Box.createGlue, BorderLayout::CENTER)

    add(panel, BorderLayout::LINE_END)
    add(@statusPanel, BorderLayout::SOUTH)
  end

  def getTour 
    @tour
  end

  def update
    @questPanel.update
    @buttonPanel.update
    @statisticPanel.update
    @statusPanel.update
  end

  def startTour
    @parentFrame.setTourPanel
    remove 0
    add(@questPanel, BorderLayout::CENTER, 0)
    @buttonPanel.setEnabled(true)
    @translatepanel.setEnabled(true)
    update
  end

  def showResult
    @parentFrame.setResultPanel
  end

  def showAuth
    showDialog AuthPanel.new(@tour)
  end

  def showStartWith
    showDialog StartPanel.new(@tour)
  end

  private

  def showDialog panel
    @parentFrame.setTourPanel
    remove 0
    @statisticPanel.update
    add(panel, BorderLayout::CENTER, 0)
    @buttonPanel.setEnabled(false)
    @translatepanel.setEnabled(false)
  end
end
