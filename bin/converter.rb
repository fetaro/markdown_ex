# -*- coding: utf-8 -*-
require 'kramdown'
require 'rexml/document'
require 'nokogiri'

# parse argument 
if ARGV[0].nil? 
  STDERR.puts "USAGE: ruby #{$0} target.md"
  exit 1
end
target = ARGV[0]

# markdown to html
body = Kramdown::Document.new(File.read(target)).to_html

id_map = {}

# split body to chapters
c_no = 0
capters = []
buffer = ""

body.split("\n").each do | line |
  if line =~ /\<h1\s/
    capters[c_no] = buffer
    c_no += 1
    doc = Nokogiri::XML(line)
    doc.child["no"] = c_no
    doc.child.child.content = doc.child["no"] +"." + doc.child.child.content
    doc.encoding = "utf-8"
    buffer = doc.to_html({:encoding => 'UTF-8'}) + "\n"
  else
    buffer += line + "\n"
  end
end
capters[c_no] = buffer


# cahpter tranform
new_body = ""
capters.each_with_index do |chapter,capter_no|
  doc = Nokogiri::HTML.parse(chapter)
  doc.xpath("//table").each_with_index do |ele,index|
    ele["no"] = "#{capter_no}-#{index + 1}"
    ele["cited"] = "表" + ele["no"]
    ele["title"] = "表" + ele["no"] + "."+ ele["title"]
    tmp = Nokogiri::XML::Node.new( "p",doc )
    tmp.content = ele["title"] 
    ele.add_child(tmp)
  end

  doc.xpath("//img").each_with_index do |ele,index|
    ele["no"] = "#{capter_no}-#{index + 1}"
    ele["cited"] = "図" + ele["no"]
    ele["alt"] = "図" + ele["no"] + "."+ ele["alt"]
    tmp = Nokogiri::XML::Node.new( "p",doc )
    tmp.content = ele["alt"] 
    ele.add_next_sibling(tmp)
  end

  doc.xpath("//pre").each_with_index do |ele,index|
    begin
      ele["no"] = "#{capter_no}-#{index + 1}"
      ele["cited"] = "リスト" + ele["no"]
      if ele["title"].nil?
        ele["title"] = "リスト" + ele["no"]
      else
        ele["title"] = "リスト" + ele["no"] + "."+ ele["title"]
      end
      ele.child.child.content = ele["title"] +"\n\n"+ ele.child.child.content 
    rescue => e
      p ele
      raise e
    end
  end

  doc.xpath("//div[@class='note']").each_with_index do |ele,index|
    begin
      ele["no"] = "#{capter_no}-#{index + 1}"
      ele["cited"] = "ノート" + ele["no"]
      ele["title"] = "ノート" + ele["no"] + "."+ ele["title"]
      tmp = Nokogiri::XML::Node.new( "pre",doc )
      tmp.content = ele["title"] +"\n\n"+ ele.child.content
      ele.child.content = ""
      ele.add_child(tmp)
    rescue => e
      p ele
      raise e
    end
  end

  doc.xpath("//div[@class='column']").each_with_index do |ele,index|
    begin
      ele["no"] = "#{capter_no}-#{index + 1}"
      ele["cited"] = "コラム" + ele["no"]
      ele["title"] = "コラム" + ele["no"] + "."+ ele["title"]
      tmp = Nokogiri::XML::Node.new( "pre",doc )
      tmp.content = ele["title"] +"\n\n"+ ele.child.content 
      ele.child.content = ""
      ele.add_child(tmp)
    rescue => e
      p ele
      raise e
    end
  end


  doc.xpath("//*").each_with_index do |ele,index|
    id_map[ele["id"]] = {:cited => ele["cited"], :id => ele["id"]} unless ele["id"].nil?
  end

  tmp_body = doc.to_html({:encoding => 'UTF-8'})

  # calc chapter number

  h1_ct = capter_no
  h2_ct = 0
  h3_ct = 0
  h4_ct = 0
  h5_ct = 0
  img_ct = 0
  table_ct = 0
  ref_map = {}
  
  tmp_body.split("\n").each do | line | 
    if line =~ /\<h\d\s/
      doc = Nokogiri::XML(line)
      if line =~ /\<h2\s/
        h2_ct += 1
        doc.child["no"] = "#{h1_ct}-#{h2_ct}"
        h3_ct = 0
        h4_ct = 0
        h5_ct = 0
      elsif line =~ /\<h3\s/
        h3_ct += 1
        doc.child["no"] = "#{h1_ct}-#{h2_ct}-#{h3_ct}"
        h4_ct = 0
        h5_ct = 0
      elsif line =~ /\<h4\s/
        h4_ct += 1
        doc.child["no"] = "#{h1_ct}-#{h2_ct}-#{h3_ct}-#{h4_ct}"
        h5_ct = 0
      elsif line =~ /\<h5\s/
        h5_ct += 1
        doc.child["no"] = "#{h1_ct}-#{h2_ct}-#{h3_ct}-#{h4_ct}-#{h5_ct}"
      end
      doc.child.child.content = doc.child["no"] +"." + doc.child.child.content
      doc.encoding = "utf-8"
      new_body += doc.to_html({:encoding => 'UTF-8'}) + "\n"
    else
      new_body += line + "\n"
    end
  end
  
end

## resolve reference
id_map.each_key do |key|  
  new_body.gsub!("\[\[#{key}\]\]","<a href=\##{id_map[key][:id]}>#{id_map[key][:cited]}</a>") unless id_map[key].nil?
end


html = <<EOL

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <link rel="stylesheet" type="text/css" href="main.css" media="all">
</head>
<body>
#{new_body}
</body>
</html>
EOL


puts html
