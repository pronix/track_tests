require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'model/tour'

include Swing
include Awt

class StatisticPanel < JPanel

  def initialize(tour)
    super
    @tour = tour
    layout = GridLayout.new(0, 1)
    layout.setVgap(5)
    setLayout(layout)

    setBorder(BorderFactory.createCompoundBorder(BorderFactory.createTitledBorder(@tour.translate('results')),
                                                 BorderFactory.createEmptyBorder(5,5,5,5)))

    addCompForBorder("")
    addCompForBorder("")
    addCompForBorder("")
  end

  def update
    setText(0, "<html><font size=+1>#{@tour.translate('total')}: #{@tour.getPassedTaskCount()}</font>")
    setText(1, "<html><font size=+1 color=green>#{@tour.translate('right')}: #{@tour.getRightTaskCount()}</font>")
    setText(2, "<html><font size=+1 color=red>#{@tour.translate('wrong')}: #{@tour.getWrongTaskCount()}</font>")
  end

  private

  def addCompForBorder(text)
    panel = JPanel.new(GridLayout.new(0, 1), false)
    label = JLabel.new(text, JLabel::CENTER)
    panel.add(label)
    panel.setBorder(BorderFactory.createLoweredBevelBorder())

    dimension = Dimension.new(200, 40)
    panel.setMinimumSize(dimension)
    panel.setPreferredSize(dimension)
    panel.setMaximumSize(dimension)

    add(panel)
  end

  def setText(index, text)
    getComponent(index).getComponent(0).setText(text)
  end

end
