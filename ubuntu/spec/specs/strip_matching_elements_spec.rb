require_relative "../spec_helper.rb"
require_relative "../../components.rb"

describe Strip do
  context "\n - When Stripping an array of elements containing X number of matching elements" do

    it "Removes the items matching the ignore list from a Hash" do
      ignore_list = [/git/,/\.thisfile/,/\.alsothisfile/]
      array_to_strip_from_hash = {"hash" => ["git",".thisfile",".alsothisfile", ".notthisfile", "orthisone"]}
      Strip.matching_elements_from_hash(array_to_strip_from_hash,:each_value, ignore_list)
      array_to_strip_from_hash.should == {"hash" => [".notthisfile", "orthisone"]}
    end

    it "\n - Removes the items matching the ignore list from an Array" do
      ignore_list = [/git/,/\.thisfile/,/\.alsothisfile/]
      array_to_strip = ["git",".thisfile",".alsothisfile", ".notthisfile", "orthisone", "hello"]
      Strip.matching_elements_from_array(array_to_strip, ignore_list)
      array_to_strip.should == [".notthisfile", "orthisone", "hello"]
    end
  end

end

