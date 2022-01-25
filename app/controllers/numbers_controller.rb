class NumbersController < ApplicationController

  # GET /numbers
  def index
    @numbers = Number.page(params[:page]).map{|number| number.contents}
  end
end
