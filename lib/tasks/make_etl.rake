require 'request_dienekes_api'
require 'make_sort'

namespace :make_etl do
    desc "Realizar processo de ETL (Extract, Transform and Load)"
    task do: :environment do
        ActiveRecord::Base.transaction do
            puts "Processo ETL iniciado..."
            if (MakeSort::sort if RequestDienekesApi::call)
                puts "Processo ETL finalizado com sucesso!!!" 
            else
                puts "Processo interrompido!!!"
            end
        end
    end
end