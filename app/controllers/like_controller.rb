class LikeController < ApplicationController
    before_action :find_favorite, except: %i[listFavoriteByUser index]
    
    def create
        if @favorite.nil?
            @favorite = Favorite.new(user_id: @current_user.id, system_id: params[:system_id])
            if @favorite.save!
                render json: @favorite, status: :created
            else
                render json: @favorite.errors, status: :unprocessable_entity
            end     
        else
            @favorite.delete
        end    
    end
    
    def index
        @favorite = Favorite.all
        render json: @favorite, status: :ok
    end
    

    private  

    def find_favorite
        array = Favorite.where(article_id: article_id.id)
        if array.empty?
            @favorite = nil 
        else  
            @favorite = array[0]    
        end   
    end

end
