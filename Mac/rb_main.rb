# FillzoneSolver
# A simple solver for the Fillzone game
# Sijmen Mulder, April 2010
#
# I, the copyright holder of this work, hereby release it into the public
# domain. This applies worldwide.
#
# In case this is not legally possible: I grant anyone the right to use this
# work for any purpose, without any conditions, unless such conditions are
# required by law.

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
