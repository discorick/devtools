require_relative '../components.rb'

class Strip
  def self.matching_elements_from_array(array, ignore_list)
    array.delete_if do |element|
      ignore_list.include? element
    end
  end

  def self.matching_elements_from_hash(hash,each_key_or_value,ignore_list)
    hash.send(each_key_or_value) do |array|
      array.delete_if do |element|
        ignore_list.include? element
      end
    end
  end

end


