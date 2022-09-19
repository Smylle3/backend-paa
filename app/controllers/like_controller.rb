class LikeController < ApplicationController
    before_action :find_like, except: %i[ index]
    
    def create
        puts @like
        if @like.empty?
            @like = Like.new(article: params[:article_id], active: true)
            if @like.save!
                render json: @like, status: :created
            else
                render json: @like.errors, status: :unprocessable_entity
            end     
        else
            @like.delete
        end    
    end
    
    def index
        @like = Like.all
        render json: @like, status: :ok
    end
    

    private  

    def find_like
        array = Like.where(article: params[:article_id])
        if array.empty?
            puts "vazio"
            @like = []
        else  
            puts "te algo"
            @like = array[0]    
        end   
    end

end
