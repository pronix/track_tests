require 'java'
require 'yaml'

class I18N
  def initialize(fileName)
    puts "filename"
    puts fileName
    @hash = {}
    @langs = initLangs

    @langs = ["ru", "en"]


    @lang = @langs.last
    puts "44444444444444"
    puts @lang.inspect

    @langs.each do |lang|
      load(fileName, lang)
    end

  end

  def get(key, lang)
    @hash[lang][key]
  end

  def default(key)
    get(key, @lang)
  end

  def lang
    @lang
  end

  def langList
    @langs
  end

  private

  def initLangs
    langs = [Lang::System.getProperty('master.lang', 'en')]
    slaveLang = Lang::System.getProperty('slave.lang')
    if slaveLang != nil
      langs = langs << slaveLang
    end
    langs
  end
  
  def load (fileName, lang)
    @hash = YAML.load_file("../../res/#{fileName}_#{lang}.yml" )
  end
end  

