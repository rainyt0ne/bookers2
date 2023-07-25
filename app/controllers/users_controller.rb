class UsersController < ApplicationController

  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @users = User.find(params[:id])
    @user = @users
    @book = Book.new
    @books = @users.books.all
  end

  def edit
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def index
    @user = current_user
    @admins = User.all
    @book = Book.new
    @books = Book.all
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have update user successfully."
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @user = current_user.id
      @books = Book.all
      render :index
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def book_params
    params.require(:book).permit(:title, :opinion)
  end

  def is_matching_login_user
    a = User.find(params[:id])
    unless a.id == current_user.id
      redirect_to user_path(current_user.id)
    end
  end
end
