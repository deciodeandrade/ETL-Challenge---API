class Number < ApplicationRecord
    validates :contents, presence: true
end
