module PostsHelper

def tag_links(tags)
  tags.reject(&:empty?).map{|tag| link_to tag.strip, posttag_path(tag.strip) }.join(",") 
end

end
