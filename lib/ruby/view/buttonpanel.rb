require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'model/tour'
require 'view/button'

include Swing
include Awt

class ButtonPanel < JPanel
  include ActionListener

  LAST_BUTTON_INDEX = 3

  def initialize(tour)
    gridLayout = GridLayout.new(0, 1)
    super gridLayout
    @tour = tour
    @buttonMap = java.util.Hashtable.new

    @timer = Timer.new(500, self)

    #gridLayout = GridLayout.new(0, 1)
    gridLayout.vgap = 2
    #setLayout(gridLayout)

    setBorder(BorderFactory.createCompoundBorder(BorderFactory.createTitledBorder(@tour.translate('variants')),
                                                 BorderFactory.createEmptyBorder(2,30,2,30)))

    (0..LAST_BUTTON_INDEX).each do |index|
      title = "#{(?A + index).chr}"
      button = Button.new(title)
      button.addActionListener(self)
      add(button)
      @buttonMap.put(title, button)
    end

  end
              
  def actionPerformed(event)
    if event.source == @timer
      @timer.stop
      @tour.nextTask
    else
      setEnabled(false)
      title = event.actionCommand
      rightVariant = @tour.getRightVariant()
      if (title != rightVariant)
        @buttonMap.get(rightVariant).enabled = true
        @buttonMap.get(rightVariant).startBlinking
        @buttonMap.get(title).enabled = true
        @buttonMap.get(title).background = Color::RED
        @tour.setBadResult
      elsif @tour.lastResult
        @buttonMap.get(title).enabled = true
        @buttonMap.get(title).background = Color::GREEN
        @timer.start
      else
        @tour.nextTask
      end
    end
  end

  def update
    (0..LAST_BUTTON_INDEX).each do |index|
      title = buttonTitle index
      button = @buttonMap.get(title)
      button.enabled = index < @tour.getVariantCount
      button.stopBlinking
    end
  end

  def setEnabled enabled
    super enabled
    (0..LAST_BUTTON_INDEX).each do |index|
      title = buttonTitle index
      button = @buttonMap.get(title)
      button.enabled = enabled
    end
  end

  private

  def buttonTitle index
    "#{(?A + index).chr}"
  end

end
