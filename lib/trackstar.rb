require_relative "trackstar/version"
require_relative "trackstar/post"

module Trackstar
  def self.call(options)
    if options[:post]
      # extract this out...
      post = Trackstar::Post.new

      post.build

      post.preview
    end
  end
end
