class KrippReportsController < ApplicationController
  
  def show_image
    #next 6 lines use R to plot a histogram
    @r = InitR()
    @d = @r.rnorm(1000)
    @l = @r.range(-4,4,@d)
    @r.png "/tmp/plot.png"
    @r.par(:bg => "cornsilk")
    @r.hist(@d, :range => @l, :col => "lavender", :main => "My Plot")
    @r.eval_R("dev.off()")  #required for png output
    # then read the png file and deliver it to the browser
    @g = File.open("/tmp/plot.png", "rb") {|@f| @f.read}
    send_data @g, :type=>"image/png", :disposition=>'inline'
  end
  
  def index
    @r = InitR()
    @r.library("concord")
    #@r.kripp_alpha( parameters )
    
    @r.matrix.autoconvert(RSRuby::NO_CONVERSION)
    @a = [1,1,2,1,1,1,3,2,3,3,3,3,3,1,3,3,2,2,2,2,1,2,3,4,4,4,4,4,1,1,2,1,2,2,2,2,1,5,5,5,2,5,1,1,3,2,3,3]
    @m = @r.matrix(@a,:nrow=>4,:ncol=>4) 
    #p @r.kripp_alpha(@m)
    @data = @r.kripp_alpha(@m)
    @kripp = @r.kripp_alpha(@m)['statistic']
  end

end
