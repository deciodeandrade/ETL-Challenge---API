require 'rest-client'
require 'json'

module RequestDienekesApi

    def self.call
        if IO.readlines('map_to_continue.txt').blank?
            self.with_all_pages
            self.with_pages_failed if IO.readlines('pages_failed.txt').present? && !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
        else
            last_page_success = eval(IO.readlines('map_to_continue.txt')[0])[:last_page_success]
            if eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
                self.with_all_pages(last_page_success + 1)
                self.with_pages_failed if IO.readlines('pages_failed.txt').present? && !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
            else
                #self.with_pages_failed
                puts 'Olá mundo!'
            end
        end
        !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time] && IO.readlines('pages_failed.txt').blank?
    end

    private

    def self.with_all_pages (i = 1)
        begin
            last_page_success = i - 1
            loop do
                begin
                    response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{i}"
                    new_array = JSON.parse(response.body)["numbers"]
                    puts "#{i}"
                    if new_array == [] #|| i == 501 #é apenas para testarmos em desenvolvimento
                        self.write_map_to_continue(false)
                        break
                    end
                    File.open('numbers.txt', 'a') do |line|
                        line.puts(new_array)
                    end
                    last_page_success = i
                    puts "ok"
                rescue RestClient::ExceptionWithResponse => e
                    e.response
                    puts "Erro na page #{i}"
                    File.open('pages_failed.txt', 'a') do |line|
                        line.puts(i)
                    end
                    last_page_success = i
                    puts "registrado"
                end
                i += 1
            end
        rescue => exception
            self.write_map_to_continue(true, last_page_success)
        end               
    end

    def self.with_pages_failed
        begin
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
                        last_page_success = i
                        puts "ok"
                    rescue RestClient::ExceptionWithResponse => e
                        e.response
                        puts "Erro na page #{i} -> #{count}ª tentativa"
                        File.open('pages_failed.txt', 'a') do |line|
                            line.puts(i)
                        end
                        last_page_success = i
                        puts "registrado"
                    end
                end
            end
        rescue => exception
            self.write_map_to_continue(false, last_page_success)
        end
    end

    def self.write_map_to_continue(is_first_time = true, last_page_success = 0)
        File.open('map_to_continue.txt', 'w') do |line|
            line.print({is_first_time: is_first_time, last_page_success: last_page_success})
        end
    end
end