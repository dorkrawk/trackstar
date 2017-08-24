require_relative "trackstar/version"
require_relative "trackstar/post"
require_relative "trackstar/log_helper"

module Trackstar
  def self.call(options)
    if options[:new]
      Trackstar::LogHelper.setup_log
    elsif options[:post]
      if Trackstar::LogHelper.check_for_existing_log(Dir.pwd)
        Trackstar::LogHelper.create_post
      else
        Trackstar::LogHelper.missing_log
      end
    end
  end
end
