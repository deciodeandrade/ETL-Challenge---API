class Number < ApplicationRecord
    validates :contents, presence: true

    max_paginates_per 100
end
