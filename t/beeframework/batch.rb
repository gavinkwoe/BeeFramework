#!/usr/bin/env ruby -wKU
# encoding: UTF-8

dest_dir = '/Users/dudan/work/BeeFramework/templates/Xcode4_templates'

Dir.foreach('.') do |f|  
  if /lib/ =~ f
    p f
    `cd #{f} &&ruby t.rb && cp -f TemplateInfo.xml #{dest_dir}/#{f}/TemplateInfo.plist &&cp -f TemplateInfo.xml #{dest_dir}/#{f}/TemplateInfo.plist`
  end
end  