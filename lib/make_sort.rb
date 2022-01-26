require 'algorithm'
include Algorithm
module MakeSort
    def self.sort
        numbers = IO.readlines('numbers.txt')
        numbers.map!{|number| number.to_f}

        numbers = quicksort(numbers)
        
        numbers.each do |number|
            Number.create(contents: number)
        end    
    end
end