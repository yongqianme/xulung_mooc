module ApplicationHelper
include LetterAvatar::AvatarHelper

require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # yep, that's it.
end

  def icon_tag(name, opts = {})
    label = EMPTY_STRING
    if opts[:label]
      label = %(<span>#{opts[:label]}</span>)
    end
    raw "<i class='fa fa-#{name}'></i> #{label}"
  end

  def letter_avatar_url(name,size)
    path = LetterAvatar.generate(name, size).sub('public/','/')
    "#{root_url}#{path}"
  end

	def tag_cloud(tags, classes)
		max = tags.sort_by(&:count).last
		tags.each do |tag|
			index = tag.count.to_f / max.count * (classes.size - 1)
			yield(tag, classes[index.round])
		end
	end

	def current_controller?(names)
		names.include?(params[:controller]) unless params[:controller].blank? || false
	end

	def display_tag?
		return true if current_controller?('videos')
	end

	def is_active?(link_path)
		current_page?(link_path) ? "active" : ""
	end

	def route_name
		Rails.application.routes.router.recognize(request) do |route, _|
			if route.name="root"
				return nil
			else
				return route.name.to_sym
			end
		end
	end

	def set_locale(locale_value)
		# I18n.locale = locale_value
		cookies[:locale] = locale_value
		# current_user.save
		# redirect_to :back
	end

	def markdown(text)
		options = {
			# filter_html:     true,
			hard_wrap:       true,
			link_attributes: { rel: 'nofollow', target: "_blank" },
			space_after_headers: true,
			fenced_code_blocks: true,
			with_toc_data: 		true,
			# no_images: false,
		}

		extensions = {
			autolink:           true,
			superscript:        true,
			disable_indented_code_blocks: false
		}

    # renderer = Redcarpet::Render::HTML.new(options)
    renderer = HTML.new(options)
		markdown = Redcarpet::Markdown.new(renderer, extensions)
		pure_markdown=ReverseMarkdown.convert(text, unknown_tags: :raise)
		html = markdown.render(pure_markdown).html_safe

	end
	def markdown_toc(text)
		options = {
			filter_html:     true,
			hard_wrap:       true,
			link_attributes: { rel: 'nofollow', target: "_blank" },
			space_after_headers: true,
			fenced_code_blocks: true,
			with_toc_data: 		true
		}

		extensions = {
			autolink:           true,
			superscript:        true,
			disable_indented_code_blocks: true
		}

		renderer = Redcarpet::Render::HTML.new(options)
		html_toc = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
    pure_markdown=ReverseMarkdown.convert(text, unknown_tags: :raise)
		toc  = html_toc.render(pure_markdown).html_safe

	end
end
