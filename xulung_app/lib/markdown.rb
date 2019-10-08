require 'rails'
require 'rails_autolink'
require 'redcarpet'
require 'singleton'
require 'rouge/plugins/redcarpet'

module Redcarpet
  module Render
    class HTMLwithSyntaxHighlight < HTML
      include Rouge::Plugins::Redcarpet

      def initialize(extensions = {})
        super(extensions.merge(xhtml: true,
                               no_styles: true,
                               escape_html: true,
                               hard_wrap: true,
                               link_attributes: { target: '_blank' }))
      end

      def block_code(code, language)
        language.downcase! if language.is_a?(String)
        html = super(code, language)
        # 将最后行的 "\n\n" 替换成回 "\n", rouge 0.3.2 的 Bug 导致
        html.gsub!(%r{([\n]+)</code>}, '</code>')
        html
      end

      def table(header, body)
        %(<table class="table table-bordered table-striped">#{header}#{body}</table>)
      end

      def autolink(link, link_type)
        # return link
        if link_type.to_s == 'email'
          link
        else
          begin
            # 防止 C 的 autolink 出来的内容有编码错误，万一有就直接跳过转换
            # 比如这句:
            # 此版本并非线上的http://yavaeye.com的源码.
            link.match(/.+?/)
          rescue
            return link
          end
          # Fix Chinese neer the URL
          bad_text = link.match(%r{[^\w:@/\-~,$!.=?&#+|%]+}im).to_s
          link.gsub!(bad_text, '')
          %(<a href="#{link}" rel="nofollow" target="_blank">#{link}</a>#{bad_text})
        end
      end
    end
  end
end

class MarkdownConverter
  include Singleton

  def self.convert(text)
    instance.convert(text)
  end

  def convert(text)
    @converter.render(text)
  end

  private

  def initialize
    highlight = Redcarpet::Render::HTMLwithSyntaxHighlight.new
    @converter = Redcarpet::Markdown.new(highlight, autolink: true,
                                                    fenced_code_blocks: true,
                                                    no_intra_emphasis: true)
  end
end

class MarkdownPostConverter < MarkdownConverter
  def self.format(raw)
    instance.format(raw)
  end

  def format(raw)
    text = raw.clone
    return '' if text.blank?

    # 如果 ``` 在刚刚换行的时候 Redcapter 无法生成正确，需要两个换行
    text.gsub!("\n```", "\n\n```")

    result = convert(text)

    doc = Nokogiri::HTML.fragment(result)

    return doc.to_html.strip
  rescue => e
    Rails.logger.error "MarkdownPostConverter.format ERROR: #{e}"
    return text
  end

  private

  def image_alt(src)
    File.basename(src, '.*').capitalize
  end

  NORMALIZE_USER_REGEXP = /(^|[^a-zA-Z0-9_!#\$%&*@＠])@([a-zA-Z0-9_]{1,20})/io
  LINK_USER_REGEXP = /(^|[^a-zA-Z0-9_!#\$%&*@＠])@(user[0-9]{1,6})/io
  def initialize
    @converter = Redcarpet::Markdown.new(Redcarpet::Render::HTMLwithTopic.new,         autolink: true,
                                                                                       fenced_code_blocks: true,
                                                                                       strikethrough: true,
                                                                                       tables: true,
                                                                                       space_after_headers: true,
                                                                                       disable_indented_code_blocks: true,
                                                                                       no_intra_emphasis: true)

  end
end

MARKDOWN_DOC = %(# Guide

这是一篇讲解如何正确使用 Ruby China 的 **Markdown** 的排版示例，学会这个很有必要，能让你的文章有更佳清晰的排版。

> 引用文本：Markdown is a text formatting syntax inspired

## 语法指导

### 普通内容

这段内容展示了在内容里面一些小的格式，比如：

- **加粗** - `**加粗**`
- *倾斜* - `*倾斜*`
- ~~删除线~~ - `~~删除线~~`
- `Code 标记` - `\`Code 标记\``
- [超级链接](http://github.com) - `[超级链接](http://github.com)`
- [huacnlee@gmail.com](mailto:huacnlee@gmail.com) - `[huacnlee@gmail.com](mailto:huacnlee@gmail.com)`

### 提及用户

@huacnlee @rei @lgn21st ... 通过 @ 可以在发帖和回帖里面提及用户，信息提交以后，被提及的用户将会收到系统通知。以便让他来关注这个帖子或回帖。

### 表情符号 Emoji

Ruby China 支持表情符号，你可以用系统默认的 Emoji 符号（无法支持 Chrome 以及 Windows 用户）。
也可以用图片的表情，输入 `:` 将会出现智能提示。

#### 一些表情例子

:smile: :laughing: :dizzy_face: :sob: :cold_sweat: :sweat_smile:  :cry: :triumph: :heart_eyes:  :satisfied: :relaxed: :sunglasses: :weary:

:+1: :-1: :100: :clap: :bell: :gift: :question: :bomb: :heart: :coffee: :cyclone: :bow: :kiss: :pray: :shit: :sweat_drops: :exclamation: :anger:

更多表情请访问：[http://www.emoji-cheat-sheet.com](http://www.emoji-cheat-sheet.com)

### 大标题 - Heading 3

你可以选择使用 H2 至 H6，使用 ##(N) 打头，H1 不能使用，会自动转换成 H2。

> NOTE: 别忘了 # 后面需要有空格！

#### Heading 4

##### Heading 5

###### Heading 6

### 代码块

#### 普通

```
*emphasize*    **strong**
_emphasize_    __strong__
@a = 1
```

#### 语法高亮支持

如果在 \`\`\` 后面更随语言名称，可以有语法高亮的效果哦，比如:

##### 演示 Ruby 代码高亮

```ruby
class PostController < ApplicationController
  def index
    @posts = Post.desc("id).limit(10)
  end
end
```

##### 演示 Rails View 高亮

```erb
<%= @posts.each do |post| %>
<div class="post"></div>
<% end %>
```

##### 演示 YAML 文件

```yml
zh-CN:
  name: 姓名
  age: 年龄
```

> Tip: 语言名称支持下面这些: `ruby`, `python`, `js`, `html`, `erb`, `css`, `coffee`, `bash`, `json`, `yml`, `xml` ...

### 有序、无序列表

#### 无序列表

- Ruby
  - Rails
    - ActiveRecord
- Go
  - Gofmt
  - Revel
- Node.js
  - Koa
  - Express

#### 有序列表

1. Node.js
  1. Express
  2. Koa
  3. Sails
2. Ruby
  1. Rails
  2. Sinatra
3. Go

### 表格

如果需要展示数据什么的，可以选择使用表格哦

| header 1 | header 3 |
| -------- | -------- |
| cell 1   | cell 2   |
| cell 3   | cell 4   |
| cell 5   | cell 6   |

### 段落

留空白的换行，将会被自动转换成一个段落，会有一定的段落间距，便于阅读。

请注意后面 Markdown 源代码的换行留空情况。)
