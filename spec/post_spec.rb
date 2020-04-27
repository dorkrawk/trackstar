require 'spec_helper'

describe Trackstar::Post do

  before do
    @log = Minitest::Mock.new
    @log.expect :fields, {}
    @log.expect :formatting, {}
  end

  it 'initializes a new post' do

    Trackstar::Log.stub :new, @log do
      new_post = Trackstar::Post.new
      puts new_post.fields

      _(new_post.values[:timestamp]).wont_be_empty
      _(new_post.values[:date]).wont_be_empty
    end
  end
end
