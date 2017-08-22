require_relative "trackstar/version"
require_relative "trackstar/post"
require_relative "trackstar/log_helper"

module Trackstar
  def self.call(options)
    if options[:new]
      log_options = {}
      # log_options = Trackstar::LogHelper.presetup(options)
      Trackstar::LogHelper.setup_log(log_options)
    elsif options[:post]
      # extract this out...
      post = Trackstar::Post.new

      post.build

      post.preview
    end
  end
end
