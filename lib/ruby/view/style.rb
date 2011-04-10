require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'


include Swing
include Awt

class Style

  def self.button button
    if UIManager.lookAndFeel.name == "Windows"
      # setUI(javax.swing.plaf.metal.MetalButtonUI.new)
      button.setUI(com.sun.java.swing.plaf.motif.MotifButtonUI.new)
      button.setBorder(BorderFactory.createLineBorder(button.background.darker, 1))
    end
  end

end
