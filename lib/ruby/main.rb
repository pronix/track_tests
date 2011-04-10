require 'java'
require 'module/swing'
require 'module/awt'
require 'view/frame'
require "yaml"


include Swing

UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

begin
  themes = UIManager.getInstalledLookAndFeels
  prefTheme = Lang::System.getProperty('theme', '')
  themes.each do |theme|
    puts "theme name:  #{theme.name}"
    if theme.name == prefTheme
      UIManager.setLookAndFeel(theme.className)
    end    
  end
rescue Exception => e
end


_frame = JFrame.new("General Knowledge Test v1.0")
_frame.defaultCloseOperation = JFrame::EXIT_ON_CLOSE

puts "11111111111111"
_tour = Tour.new(I18N.new('translate'), 'generate')

_panel = MainFrame.new(_tour)
_panel.opaque = true

_frame.contentPane = _panel

_frame.minimumSize = Dimension.new(800, 600)
_frame.preferredSize = Dimension.new(800, 600)

_frame.pack()
_frame.visible = true
