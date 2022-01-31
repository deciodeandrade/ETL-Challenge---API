require 'algorithm'
include Algorithm

module MakeSort
    def self.sort
        numbers = IO.readlines("#{RequestDienekesApi::files_path}/numbers.txt")
        numbers.map!{|number| number.to_f}

        puts 'Ordenando números...'
        quicksort(numbers)
        
        puts 'Salvando números no banco de dados...'
        numbers.each do |number|
            Number.create(contents: number)
        end    
    end
end