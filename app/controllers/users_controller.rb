class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash.now[:success] = "Your new account has been created!"
      log_in user
      redirect_to user_path(user)
    else
      render 'new'
    end
  end

  def show
    @categories = Category.all
    @authors = []
    @user = User.find params[:id]
    @reviews = @user.received_reviews

    @reviews.each do |review|
      @authors.push(review.author)
    end

    @authorsneg = []
    @reviewsneg = Review.where({receiver_id: @user.id, positive: false})

    @reviewsneg.each do |review|
      @authorsneg.push(review.author)
    end

    @received = []
    @reviewswritten = Review.where({author_id: @user.id})

    @reviewswritten.each do |review|
      @received.push(review.receiver)
    end
  end

  private # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end