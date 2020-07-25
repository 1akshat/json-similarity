require "json"

module JsonSimilarityHelper

    def compare_hashes(hash1, hash2)
        # Should through an error if parameters are not HASH
        if !hash1.kind_of? (Hash) or !hash2.kind_of? (Hash)
            raise "Expected Hash Type."
        end

        hash1_keys = hash1.keys
        hash2_keys = hash2.keys
    
        if hash1_keys.nil?
            hash1_keys = []
        end
    
        if hash2_keys.nil?
            hash2_keys = []
        end
        # Computing Iterable Hash: The Hash which is having greater number of keys
        if hash1_keys.length > hash2_keys.length
            iterable_hash = hash1
            comparable_hash = hash2
        else
            iterable_hash = hash2
            comparable_hash = hash1
        end

        iterable_hash.each do |key, value|
            # Check for Primitive Value in iterable Hash
            if (value.kind_of? (String) or value.kind_of? (Integer) or value.kind_of? (Float) or value.kind_of? (TrueClass) or value.kind_of? (FalseClass))
                compare_primitives(key, value, comparable_hash)
            end
            # Check for array value in iterable Hash
            if value.kind_of? (Array)
                compare_arrays(key, value, hash1, hash2)
            end
    
            # Check for Hash value in iterable Hash
            if value.kind_of? (Hash)
                if hash1[key].nil?
                    comparable_hash1 = {}
                else
                    comparable_hash1 = hash1[key]
                end
    
                if hash2[key].nil?
                    comparable_hash2 = {}
                else
                    comparable_hash2 = hash2[key]
                end
                # Recursive Call
                compare_hashes(comparable_hash1, comparable_hash2)
            end
        end
        parse_final_data
    end
    
    # The parameters are key and value from the first hash and complete second hash
    # variables with @ are global vars.
    def compare_primitives(key, value, hash2)
        unless hash2.nil?
            # Check if Second Hash is containing the same key and value
            @matched_values += 1 if hash2[key] == value
            if hash2[key] != value
                @unmatched_values += 1 
                @reason << {
                    'key': key,
                    'value_one': hash2[key],
                    'value_two': value
                }
            end
        else
            @unmatched_values += 1
        end
    end
    
    def compare_arrays(key, value, hash1, hash2)
        array_to_loop = []
        other_array = []
        # value is an Array type, containing multiple hashes.
        value.each do |individual_obj|
            # Individual obj is a hash
            if individual_obj.kind_of? (Hash)
                # Possibility: Inside a hash there can be key with value type as Array
                if hash1[key].kind_of? Array and hash2[key].kind_of? Array
                    # Finding the array with greater length to loop with so that keys hashes are not missed while comparing
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
        if array_to_loop.nil?
            array_to_loop = {}
        end
        array_to_loop.each_with_index do |deep_object, index|
            if other_array and !other_array[index].nil?
                # Finally got the hashes so now can compare those
                compare_hashes(deep_object, other_array[index])
            else
                # If one key value is missing in other hash then assuming that to be empty Hash
                compare_hashes(deep_object, {})
            end
        end
    end
    
    # This function expects a file path to get passed and return the json
    def read_file(file_name)
        file = File.open(file_name)
        data = JSON.load file
        return data
    end

    def similarity_score
        # Algo: Truthy/(Truthy + Falsy)
        (@matched_values.to_f / (@matched_values + @unmatched_values)).round(4)
    end

    def parse_final_data
        {
            score: similarity_score,
            diff: @reason
        }
    end

end
