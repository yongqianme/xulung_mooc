# config/initializers/friendly_id/slugged.rb
module FriendlyId
module Slugged
  # 重定义 friendly_id 方法，实现 slug 从中文到拼音，非中文不受影响
  def normalize_friendly_id(value)
    Pinyin.t(value.to_s).parameterize
  end
end
end
