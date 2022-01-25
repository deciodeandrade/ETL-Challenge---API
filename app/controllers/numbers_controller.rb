class NumbersController < ApplicationController

  # GET /numbers
  def index
    @numbers = Number.all.map{|number| number.contents}
  end
end
