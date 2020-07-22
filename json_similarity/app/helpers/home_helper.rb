require "json"

module HomeHelper

    def similarity_score
        1 - (@unmatched_values.to_f / (@matched_values + @unmatched_values))
    end
    
    def compare_hashes(hash1, hash2)
        hash1.each do |key, value|
            if (value.kind_of? (String) or value.kind_of? (Integer) or value.kind_of? (Float) or value.kind_of? (TrueClass) or value.kind_of? (FalseClass))
                compare_primitives(key, value, hash2)
            end
    
            if value.kind_of? (Array)
                compare_arrays(key, value, hash1, hash2)
            end
    
            if value.kind_of? (Hash)
                compare_hashes(hash1[key], hash2[key])
            end
        end
        similarity_score
    end
    
    def compare_primitives(key, value, hash2)
        unless hash2.nil?
            @matched_values += 1 if hash2[key] == value
            @unmatched_values += 1 if hash2[key] != value
        else
            @unmatched_values += 1
        end
    end
    def compare_arrays(key, value, hash1, hash2)
        array_to_loop = []
        other_array = []
        # value is an array
        value.each do |individual_obj|
            if individual_obj.kind_of? (Hash)
                if hash1[key].kind_of? Array and hash2[key].kind_of? Array
                    array1_length = hash1[key].length
                    array2_length = hash2[key].length
                    if array1_length > array2_length
                        array_to_loop = hash1[key]
                        other_array = hash2[key]
                    elsif array2_length > array1_length
                        array_to_loop = hash2[key]
                        other_array = hash1[key]
                    else
                        array_to_loop = hash1[key]
                        other_array = hash2[key]
                    end
                else
                    array_to_loop = hash1[key]
                    other_array = hash2[key]
                end
            end
        end
        array_to_loop.each_with_index do |deep_object, index|
            if other_array and !other_array[index].nil?
                compare_hashes(deep_object, other_array[index]) 
            else
                compare_hashes(deep_object, {})
            end
        end
    end
    
    def read_file(file_name)
        file = File.open(file_name)
        data = JSON.load file
        return data
    end

end
