require 'test_helper'
require 'better_html/tokenizer/location'

module BetterHtml
  module Tokenizer
    class LocationTest < ActiveSupport::TestCase
      test "location start out of bounds" do
        e = assert_raises(ArgumentError) do
          Location.new("foo", 5, 6)
        end
        assert_equal "start location 5 is out of range for document of size 3", e.message
      end

      test "location stop out of bounds" do
        e = assert_raises(ArgumentError) do
          Location.new("foo", 2, 6)
        end
        assert_equal "stop location 6 is out of range for document of size 3", e.message
      end

      test "location stop < start" do
        e = assert_raises(ArgumentError) do
          Location.new("aaaaaa", 5, 2)
        end
        assert_equal "end of range must be greater than start of range (2 < 5)", e.message
      end

      test "location calulates start and stop line and column" do
        loc = Location.new("foo\nbar\nbaz", 5, 9)

        assert_equal "ar\nba", loc.source
        assert_equal 2, loc.start_line
        assert_equal 1, loc.start_column
        assert_equal 3, loc.stop_line
        assert_equal 1, loc.stop_column
      end

      test "line_source_with_underline" do
        loc = Location.new("ui_helper(foo)", 10, 12)

        assert_equal "foo", loc.source
        assert_equal <<~EOL.strip, loc.line_source_with_underline
          ui_helper(foo)
                    ^^^
        EOL
      end

      test "line_source_with_underline removes empty spaces" do
        loc = Location.new("   \t   ui_helper(foo)", 17, 19)

        assert_equal "foo", loc.source
        assert_equal <<~EOL.strip, loc.line_source_with_underline
          ui_helper(foo)
                    ^^^
        EOL
      end
    end
  end
end
