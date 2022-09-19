class ArticlesController < ApplicationController
    before_action :find_article, except: %i[ index ]


    # GET /articles
    def index
        @article = Article.all
        if @article.empty?
            list = Article.new.get_news
            list.each do |item| 
                # puts "#{item[0]}\n\n#{item[1]}\n\n#{item[2]}\n\n#{item[3]}\n\n#{item[4]}"
                title = item[0]
                subTitle = item[1]
                image = item[2]
                caption = item[3]
                paragraph = item[4]
                puts "#{title}\n\n#{subTitle}\n\n#{image}\n\n#{caption}\n\n#{paragraph}"
                @article = Article.new
                @article.title = title
                @article.subTitle = subTitle
                @article.image = image
                @article.caption = caption
                @article.paragraph = paragraph
                @article.save!
            end 
            @article = Article.all
            render json: @article, status: :ok
        else 
            @article = Article.all
            render json: @article, status: :ok
            # @article = Article.first
            # valor = @article.ranking
            # render json: valor, status: :ok
        end    
    end    
    # POST /articles
    def create
         
    end 
    
    # GET /articles/1
    def show
        @article.update("paraghaph": @article.paraghaph.split("\n"))
        if @article.like.active.true?
            rank = @article.ranking
            render json: [@article, rank], status: :ok
        else    
            render json: [@article], status: :ok
        end    
    end
  
  
    # PATCH/PUT /articles/1
    def update
        if @article.update(article_params)
            render json: @article
        else
            render json: @article.errors, status: :unprocessable_entity
        end
    end
  
    # DELETE /articles/1
    def destroy
        @article.destroy
    end
  
    private
    # Only allow a list of trusted parameters through.
    def article_params
        params.permit(:title, :subTitle, :image, :caption, :paragraph)
    end

    def find_article
        @article = Article.find_by_id!(params[:id])
    end
       
end

