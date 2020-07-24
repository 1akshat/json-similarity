require 'test_helper'

class JsonSimilarityControllerTest < ActionDispatch::IntegrationTest

  include JsonSimilarityHelper

  test "should raise an error for invalid json input" do
    hash1 = [] # Array instead of Hash
    hash2 = [] # Array instead of Hash
    assert_raises RuntimeError do 
      compare_hashes(hash1, hash2)
    end
  end

  test "should not raise an error for valid json input" do
    hash1 = {}
    hash2 = {}
    @matched_values = 0 
    @unmatched_values = 0
    assert_nothing_raised do 
      compare_hashes(hash1, hash2)
    end
  end

  test "should raise an error for stringified json" do
    hash1 = '{"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }'
    hash2 = '{"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }'
    @matched_values = 0 
    @unmatched_values = 0
    assert_raises RuntimeError do 
      compare_hashes(hash1, hash2)
    end
  end

  test "should return 1 for completely identical json" do
    hash1 = {"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }}
    hash2 = {"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }}
    @matched_values = 0 
    @unmatched_values = 0
    similarity_score = compare_hashes(hash1, hash2)
    assert_equal 1, similarity_score
  end

  test "should return 0 for completely non-identical json" do
    hash1 = {"widget": {
      "debug": "off",
      "window": {
          "title": "Window &",
          "name": "Vista",
          "width": 100,
          "height": 200
      }
    }}
    hash2 = {"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }}
    @matched_values = 0 
    @unmatched_values = 0
    similarity_score = compare_hashes(hash1, hash2)
    assert_equal 0, similarity_score
  end

  test "should return a value between 0-1 for partially identical json" do
    hash1 = {"widget": {
      "debug": "on",
      "window": {
          "title": "Window &",
          "name": "Vista",
          "width": 500,
          "height": 200
      }
    }}
    hash2 = {"widget": {
      "debug": "on",
      "window": {
          "title": "Sample Konfabulator Widget",
          "name": "main_window",
          "width": 500,
          "height": 500
      }
    }}
    @matched_values = 0 
    @unmatched_values = 0
    similarity_score = compare_hashes(hash1, hash2)
    assert_includes 0..1, similarity_score
  end

end
