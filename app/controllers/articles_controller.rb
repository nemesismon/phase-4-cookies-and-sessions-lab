class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    
    article = Article.find_by(id: params[:id])
    session[:page_views] ||= 0
    if article
      session[:page_views] += 1
      if session[:page_views] < 4
        render json: article, each_serializer: ArticleSerializer, status: :ok
      else session[:page_views] > 3
        render json: {error: 'Maximum pageview limit reached'}, status: :unauthorized
      end
    else
      render json: :record_not_found
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
