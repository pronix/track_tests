require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'

include Swing
include Awt
include Lang

class StatusPanel < JPanel
  include ActionListener

  def initialize tour
    super
    @tour = tour
    @label = JLabel.new("", JLabel::CENTER)
    
    setLayout(BorderLayout.new())
    setBorder(BorderFactory.createRaisedBevelBorder())

    panel1 = JPanel.new
    panel1.setBorder(BorderFactory.createEmptyBorder(5,5,5,5))
    panel1.add(@label)

    panel2 = JPanel.new
    panel2.setBorder(BorderFactory.createEmptyBorder(5,5,5,5))

    exitButton = JButton.new(@tour.translate('exit'))
    exitButton.addActionListener self
    exitButton.setFocusPainted(false)
    panel2.add(exitButton)

    add(panel1, BorderLayout::LINE_START)
    add(panel2, BorderLayout::LINE_END)

  end

  def actionPerformed(event)
    System.exit 0
  end

  def update
    @label.setText(formatDaysMessage(@tour.preferences.lastDay))
  end

  private

  def formatDaysMessage days
    message = @tour.translate('expire')
    day_message = 'huge_days'
    if days == 1
      day_message = 'day'
    elsif days < 5
      day_message = 'few_days'
    end
    message.gsub('{days}', "#{days} #{@tour.translate(day_message)}")
  end

end
