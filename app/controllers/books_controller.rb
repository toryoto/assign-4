class BooksController < ApplicationController
  
  before_action :authenticate_user!
  
  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @favorite = Favorite.new
    @book_comment = BookComment.new
  end

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @user = current_user
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]="You have creatad book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
        render "edit"
    else
        redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    @book.user_id = current_user.id
    if @book.update(book_params)
      flash[:notice]="Book was successfully updated."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    if @book.destroy
      flash[:notice]="Book was successfully destroyed."
      redirect_to books_path
    end
  end

  def copy
    @old_book = Book.find_by(id: params[:book_id])
    @copy_book = @old_book.deep_clone
    downloadImage = @old_book.image.download  # 画像を一時的に保存（refile backendのメソッド）
    @copy_book.image_id = "" # cloneした画像idとの繋がりを切る
    @copy_book.image = downloadImage # 新しく画像をアタッチ
    @copy_book.title = "[COPY]#{@old_book.title}"
    @copy_book.save
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body, :image)
    end
    
    def user_params
        params.require(:user).permit(:name,:profile_image,:introduction)
    end
    
    def  ensure_current_user
      @book = Book.find(params[:id])
      if @book.user_id != current_user.id
        redirect_to books_path
      end
    end
end
