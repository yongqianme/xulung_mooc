#encoding: UTF-8

xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @title
    xml.description @description
    xml.link pages_url

    for page in @pages
      xml.item do
        xml.title page.title
        xml.description page.content
        xml.pubDate page.pageed_at.to_s(:rfc822)
        xml.link page_url(page)
        xml.guid page_url(page)
      end
    end
  end
end