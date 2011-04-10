require 'java'
require 'module/lang'

class Utils

  def self.get_jar_resource name
    Lang::ClassLoader.getSystemResource(name)
  end

  def self.diff_date (startDate, endDate)
    endMillis   = endDate.timeInMillis + endDate.timeZone.getOffset(endDate.timeInMillis)
    startMillis = startDate.timeInMillis + startDate.timeZone.getOffset(startDate.timeInMillis)
    (endMillis - startMillis) / 86400000
  end

  def self.crc32 string
    crc32 = java.util.zip.CRC32.new
    crc32.update(string.to_java_bytes)
    crc32.getValue
  end
end
