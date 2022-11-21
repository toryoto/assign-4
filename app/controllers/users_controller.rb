class UsersController < ApplicationController
  require 'open-uri'
  
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = Book.where(user_id: @user.id)
    @favorite = Favorite.new
    @book_comments = @book.book_comments
    @book_comment = BookComment.new
    p Refile.attachment_url(@user, :profile_image)
    p 'あいう'
    p @user.profile_image_id

    # imageIo = @user.profile_image.to_io
    # image = MiniMagick::Image.open(imageIo)
    # debugger
    #p image
    p 12345

    # File.open("aaaaa.jpg", "wb") do |file|
    #   image.write(file)
    # end
  end

  def index
    @user = current_user
    @users = User.all
    @book = Book.new
    @books = Book.all

    user2 = @users.find(2).dup
    p user2
    imageIo = @users.find(2).profile_image.to_io
    image = MiniMagick::Image.open(imageIo)
    #file = @user.profile_image
    File.open("aaaaa.jpg", "wb") do |file|
      image.write(file)
    end
    # File.open("aaaaa.jpg", "rb") do |file|
    # end
    #user2.save

    # p image.signature

  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
        render "edit"
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice]="You have updated user successfully."
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

end