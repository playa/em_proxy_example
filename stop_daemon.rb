require 'fileutils'

files = Dir[File.expand_path('../tmp/*.pid',__FILE__)]
files.each do |f|
  if f
    pid = File.open(f) {|h| h.read}.to_i
    p "Pid File at '#{f}'"
    p "PID:#{pid}"
    begin
      Process.kill('TERM', pid) 
    rescue Errno => e
      puts "#{e} #{pid}"
      puts "deleting pid-file..."
      FileUtils.rm( f )
    end
  else
    p "No pid file"
  end
end
