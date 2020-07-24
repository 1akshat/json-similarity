require "json"

module JsonSimilarityHelper
    
    def similarity_score
        (@matched_values.to_f / (@matched_values + @unmatched_values))
    end
    
    def compare_hashes(hash1, hash2)

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
    
        if hash1_keys.length > hash2_keys.length
            iterable_hash = hash1
            comparable_hash = hash2
        else
            iterable_hash = hash2
            comparable_hash = hash1
        end
        iterable_hash.each do |key, value|
    
            if (value.kind_of? (String) or value.kind_of? (Integer) or value.kind_of? (Float) or value.kind_of? (TrueClass) or value.kind_of? (FalseClass))
                compare_primitives(key, value, comparable_hash)
            end
    
            if value.kind_of? (Array)
                compare_arrays(key, value, hash1, hash2)
            end
    
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
                compare_hashes(comparable_hash1, comparable_hash2)
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
        if array_to_loop.nil?
            array_to_loop = {}
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

    # def compare_files(file1, file2)
    #     file1_data = read_file(file1)
    #     file2_data = read_file(file2)
    
    #     compare_hashes(file1_data, file2_data)
    # end

end
