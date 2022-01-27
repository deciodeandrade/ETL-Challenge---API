require 'rest-client'
require 'json'

module RequestDienekesApi
    def self.call
        pages_failed = []
        numbers = []
        i = 1
        loop do
            begin
                response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{i}"
                new_array = JSON.parse(response.body)["numbers"]
                numbers += new_array
                puts i
                break if new_array == []
            rescue RestClient::ExceptionWithResponse => e
               e.response
               pages_failed.push(i)
               puts "Erro na page #{i}"
            end
            i += 1
        end
        
        File.open('pages_failed.txt', 'w') do |line|
            line.puts(pages_failed)
        end
        
        File.open('numbers.txt', 'w') do |line|
            line.puts(numbers)
        end                
    end
end