class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @user = @books.user
    @u_image = @books.user
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    flash[:notice] = "The book was successfully deleted."
    redirect_to books_path
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update(book_params)
    if @book.save
      flash[:notice] = "You have update book successfully."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end
    def is_matching_login_user
      book = Book.find(params[:id])
      user = book.user
      unless user.id == current_user.id
        redirect_to books_path
      end
    end
end