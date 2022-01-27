require 'rest-client'
require 'json'

module RequestDienekesApi
    def self.call
        begin
            is_first_time = true
            last_page_success = 0

            i = 1
            loop do
                begin
                    response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{i}"
                    new_array = JSON.parse(response.body)["numbers"]
                    puts i
                    break if new_array == [] || i == 501    #'|| i == 501' é apenas para testarmos em desenvolvimento
                    File.open('numbers.txt', 'a') do |line|
                        line.puts(new_array)
                    end
                rescue RestClient::ExceptionWithResponse => e
                    e.response
                    puts "Erro na page #{i}"
                    File.open('pages_failed.txt', 'a') do |line|
                        line.puts(i)
                    end
                end
                last_page_success = i
                i += 1
            end
            is_first_time = false
            count = 1;
            loop do
                
                
                pages_failed = IO.readlines('pages_failed.txt')
                pages_failed.map!{|page| page.to_i}
                break if pages_failed == []

                File.open('pages_failed_copy.txt', 'w') do |line|   #salva páginas na cópia antes de apagar o arquivo original
                    line.puts(pages_failed)
                end
                File.open('pages_failed.txt', 'w') #limpar_arquivo()        #apaga arquivo original

                count += 1;
                for i in pages_failed do
                    begin
                        response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{i}"
                        new_array = JSON.parse(response.body)["numbers"]
                        puts "|#{i} -> #{count}ª tentativa|"
                        File.open('numbers.txt', 'a') do |line|
                            line.puts(new_array)
                        end
                    rescue RestClient::ExceptionWithResponse => e
                        e.response
                        puts "Erro na page #{i} -> #{count}ª tentativa"
                        File.open('pages_failed.txt', 'a') do |line|
                            line.puts(i)
                        end
                    end
                    last_page_success = i
                end
            end
        rescue => exception
            File.open('map_to_continue.txt', 'w') do |line|
                line.puts({is_first_time: is_first_time, last_page_success: last_page_success})
            end
        end               
    end
end