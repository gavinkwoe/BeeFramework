#!/usr/bin/env ruby -wKU
# encoding: UTF-8

require "rexml/document" 

file = File.new("TemplateInfo.xml","w+")    #新建XML文件， 将以下内容写入 。

file.puts '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'

doc = REXML::Document.new       #创建XML内容 

el = doc.add_element 'plist', { "version"=>"1.0"}


k1 = el.add_element 'key', {}
k1.add_text "Description"

k1_s = el.add_element 'string', {}
k1_s.add_text "This is a template description."


k2 = el.add_element 'key', {}
k2.add_text "Identifier"
k2_s = el.add_element 'string', {}
current_dir_name = Dir.pwd.split('/').last
id_name =current_dir_name[0,current_dir_name.index('.')] # 用当前文件名
k2_s.add_text "com.beeframework.#{id_name}.lib"

k3 = el.add_element 'key', {}
k3.add_text "Kind"
k3_s = el.add_element 'string', {}
k3_s.add_text "Xcode.Xcode3.ProjectTemplateUnitKind"


k4 = el.add_element 'key', {}
k4.add_text "Definitions"


# section 1
dict = el.add_element 'dict', {}

Dir["./**/*.h","./**/*.m"].each{
  |x|  

  x = x[2,x.length]
  # p x
  
  k = dict.add_element 'key', {}
  k.add_text x
  
  d = dict.add_element 'dict', {}
  
  d_key = d.add_element 'key', {}
  d_key.add_text "Group"
  
  d_array = d.add_element 'array', {}

  
  _d_array_x1 = d_array.add_element 'string', {}
  _d_array_x1.add_text 'libs'
  _d_array_x2 = d_array.add_element 'string', {}
  _d_array_x2.add_text id_name
  _d_array_x3 = d_array.add_element 'string', {}
  _d_array_x3.add_text 'src'
  
  
  d_key_2 = d.add_element 'key', {}
  d_key_2.add_text "Path"
  
  d_key_s2 = d.add_element 'string', {}
  d_key_s2.add_text x
  
  
  # .h文件多了TargetIndices
  if /\.h/ =~ x
    # p ".h=#{x}"
    d_key_3 = d.add_element 'key', {}
    d_key_3.add_text "TargetIndices"
  end
}


 
nodes = el.add_element 'key', {}
nodes.add_text "Nodes"
nodes_array = el.add_element 'array', {}

# section 2
Dir["./**/*.h","./**/*.m"].each{
  |x|  
  x = x[2,x.length]
  
  # p x
  me = nodes_array.add_element 'string', {}
  me.add_text x
}

# 
formatter = REXML::Formatters::Pretty.new

# Compact uses as little whitespace as possible
formatter.compact = true
formatter.write(doc, file)
# file.puts doc.write

#  plist = Nokogiri::PList(open('TemplateInfo.plist'))
#  
# p plist.to_plist_xml

# <key>libs/FMDB/FMResultSet.h</key>
# <dict>
#   <key>Group</key>
#   <array>
#     <string>libs</string>
#     <string>FMDB</string>
#     <string>src</string>
#   </array>
#   <key>Path</key>
#   <string>libs/FMDB/FMResultSet.h</string>
#   <key>TargetIndices</key>
#   <array/>
# </dict>
# <key>libs/FMDB/FMResultSet.m</key>
# <dict>
#   <key>Group</key>
#   <array>
#     <string>libs</string>
#     <string>FMDB</string>
#     <string>src</string>
#   </array>
#   <key>Path</key>
#   <string>libs/FMDB/FMResultSet.m</string>
# </dict>
# 
