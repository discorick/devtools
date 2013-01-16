require_relative '../components.rb'

class Strip


  def self.matching_elements_from_hash(hash,each_key_or_value,ignore_list)
    hash.send(each_key_or_value) do |list|
      return delete_matching_string hash,ignore_list if each_key_or_value == :each_key
      list.delete_if{|element| ignore_list.find{|matcher|matcher =~ element}}
    end
  end

  def self.matching_elements_from_array(array, ignore_list)
    array.delete_if do |element|
      ignore_list.find do |matcher| 
        matcher =~ element
      end
    end
  end

  private
  def self.delete_matching_string hash,ignore_list
    hash.each_key do |key|
      hash.delete(key) if ignore_list.find{|matcher| matcher =~ key}
    end
  end
end

