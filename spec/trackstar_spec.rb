require 'spec_helper'

describe Trackstar do

  it 'works' do
    _(true).must_equal true
  end

  it 'has a version number' do
    _(Trackstar::VERSION).wont_be_nil
  end

end
