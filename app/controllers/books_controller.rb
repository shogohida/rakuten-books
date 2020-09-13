require 'json'
require 'open-uri'

class BooksController < ApplicationController
  def index
    # @books = Book.all
    Book.destroy_all
    url = "https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404?format=json&keyword=kubernetes&booksGenreId=000&applicationId=1003225387995383165"
    books_serialized = open(url).read
    items = JSON.parse(books_serialized)
    items["Items"].each do |item|
      item = item["Item"]
      if item["publisherName"] != ""
        @author = Publisher.create(
          name: item["publisherName"]
        )
      else
        @author = Publisher.create(
          name: "不明"
        )
      end
      # @publisher = Publisher.create(
      #   name: item["publisherName"]
      # )
      if item["author"] != ""
        @author = Author.create(
          name: item["author"]
        )
      else
        @author = Author.create(
          name: "不明"
        )
      end
      Book.create(
        title: item["title"],
        image: item["mediumImageUrl"],
        price: item["itemPrice"],
        description: item["itemCaption"],
        author: @author,
        publisher: @publisher
      )
    end
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.saved?
      redirect_to books_path
    else
      render :new
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :image, :price, :description)
  end

end
