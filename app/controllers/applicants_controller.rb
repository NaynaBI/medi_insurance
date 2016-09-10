class ApplicantsController < ApplicationController
  before_action :authenticate_agent!, except: [:new, :create]

  def index
  end

  def new
    @applicant = Applicant.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def show
  end

  def delete
  end
end
