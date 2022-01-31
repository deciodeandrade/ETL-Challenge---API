require 'rest-client'
require 'json'

module RequestDienekesApi

    def self.call
        File.open('map_to_continue.txt', 'a')
        if IO.readlines('map_to_continue.txt').blank?
            self.first_way
        else
            puts "[1] - Continuar de onde parou"
            puts "[2] - Do início"
            option = gets.chomp

            puts '_________________________________________'
            
            case option
            when '1'
                self.other_way
            when '2'
                self.first_way
            else
                'Opção inexistente'
            end
        end
        !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time] && IO.readlines('pages_failed.txt').blank?
    end

    def self.clear_files
        File.open('map_to_continue.txt', 'w')
        File.open('numbers.txt', 'w')
        File.open('pages_failed.txt', 'w')
        File.open('pages_failed_copy.txt', 'w')
    end

    private

    def self.first_way
        self.clear_files
        self.with_all_pages
        self.with_pages_failed if IO.readlines('pages_failed.txt').present? && !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
    end

    def self.other_way
        last_page_success = eval(IO.readlines('map_to_continue.txt')[0])[:last_page_success]
        if eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
            self.with_all_pages(last_page_success + 1)
            self.with_pages_failed if IO.readlines('pages_failed.txt').present? && !eval(IO.readlines('map_to_continue.txt')[0])[:is_first_time]
        else
            self.continue_after_error_in_pages_failed(last_page_success)
            self.with_pages_failed
        end
    end

    def self.with_all_pages (page = 1)
        loop do
            begin
                response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{page}"
                new_array = JSON.parse(response.body)["numbers"]
                
                if new_array == []
                    self.write_map_to_continue(false)
                    break
                end
                
                self.register_numbers(page, new_array)

            rescue RestClient::ExceptionWithResponse => e
                e.response
                self.register_pages_failed(page)
            end
            page += 1
        end             
    end

    def self.with_pages_failed
        count = 1;
        loop do    
            pages_failed = IO.readlines('pages_failed.txt')
            pages_failed.map!{|page| page.to_i}
            break if pages_failed == []

            File.open('pages_failed_copy.txt', 'w') do |line|
                line.puts(pages_failed)
            end
            File.open('pages_failed.txt', 'w')

            count += 1;
            for page in pages_failed do
                begin
                    response = RestClient.get "http://challenge.dienekes.com.br/api/numbers?page=#{page}"
                    new_array = JSON.parse(response.body)["numbers"]

                    self.register_numbers(page, new_array, count, false)
                    
                rescue RestClient::ExceptionWithResponse => e
                    e.response
                    self.register_pages_failed(page, count, false)
                end
            end
        end
    end

    def self.register_numbers(page, new_array, count = 1, is_first_time = true)
        puts "|#{page} -> #{count}ª tentativa|"
        File.open('numbers.txt', 'a') do |line|
            line.puts(new_array)
        end
        self.write_map_to_continue(is_first_time, page)
        puts "ok"
    end

    def self.register_pages_failed(page, count = 1, is_first_time = true)
        puts "Erro na page #{page} -> #{count}ª tentativa"
        File.open('pages_failed.txt', 'a') do |line|
            line.puts(page)
        end
        self.write_map_to_continue(is_first_time, page)
        puts "registrado"
    end

    def self.write_map_to_continue(is_first_time = true, last_page_success = 0)
        File.open('map_to_continue.txt', 'w') do |line|
            line.print({is_first_time: is_first_time, last_page_success: last_page_success})
        end
    end

    def self.continue_after_error_in_pages_failed(last_page_success)
        pages_failed_copy = IO.readlines('pages_failed_copy.txt')
        pages_failed_copy.map!{|page| page.to_i}

        pages_failed = IO.readlines('pages_failed.txt')
        pages_failed.map!{|page| page.to_i}

        pages_missing = last_page_success != 0 ? pages_failed_copy[pages_failed_copy.index(last_page_success)+1..-1] : pages_failed_copy
        pages_failed = pages_failed.concat(pages_missing)

        File.open('pages_failed.txt', 'w') do |line|
            line.puts(pages_failed)
        end
    end
end