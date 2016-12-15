require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  
  test "should calculate visits count of a url" do
    short_url = ShortUrl.create!(original_url: "http://blah.com")
    ShortVisit.create!(short_url_id: short_url.id)
    assert_equal 0,short_url.visits_count

    short_url.calculate_visits_count
    assert_equal 1,short_url.visits_count
  end
end
