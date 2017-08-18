class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
    @profiles = Profile.all
  end

  def create
    user = User.new(user_params)
    if user.save
      user.create_profile(avatar: 'default_avatar.jpg')
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
    @profile = Profile.where({user_id: @user.id})
    @review_categories = []
    @review_profiles = []
    @neg_reviews = Review.where({receiver_id: @user.id, positive: false})
    @neg_review_profiles = []
    @neg_review_categories = []
    @rebuttals = {}
    @written_rebutted = {}
    @written_review_profiles = []
    @written_review_categories = []
    @authorsneg = []
    @received = []
    @reviewswritten = Review.where({author_id: @user.id})

    @reviews.each do |review|
      @authors.push(review.author)
      @review_categories.push(@categories.where({id: review.category_id}))
      @review_profiles.push(Profile.where({id: review.author_id}))
    end

    @neg_reviews.each do |review|
      @authorsneg.push(review.author)
      @neg_review_categories.push(@categories.where({id: review.category_id}))
      @rebuttals[review.id] = Rebuttal.where({review_id: review.id})
      @neg_review_profiles.push(Profile.where({id: review.author_id}))
    end


    @reviewswritten.each do |review|
      @received.push(review.receiver)
      @written_review_categories.push(@categories.where({id: review.category_id}))
      @written_rebutted[review.id] = Rebuttal.where({review_id: review.id})
      @written_review_profiles.push(Profile.where({id: review.receiver_id}))
    end

  end

  private # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end