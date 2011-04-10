require 'java'
require 'module/swing'

include Swing

class NumberFilter < PlainDocument
  def initialize (textField, minValue, maxValue)
    super()
    @minValue = minValue
    @maxValue = maxValue
    @textField = textField
  end
  
  def insertString (offs, str, attrSet)
    current = (@textField.text+ str).to_i
    if current >= @minValue && current <= @maxValue
      super(offs, str, attrSet)
    end
  end
end

