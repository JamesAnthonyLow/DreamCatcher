class ApplicationController < ActionController::Base
  include Ransack::Helpers::FormHelper
  protect_from_forgery with: :exception
  helper_method :current_dreamer
  helper_method :calculate_lucidity
  helper_method :error
  layout proc { false if request.xhr? }

  before_filter :set_query

  def authenticate_dreamer
    redirect_to root_path unless current_dreamer
  end

  def current_dreamer
    @current_dreamer ||= Dreamer.find_by(id: session[:dreamer_id])
  end

  def set_query
    @query = params[:q]
    @dreams = Dream.ransack(title_or_story_cont: @query).result
    @dreamers = Dreamer.ransack(username_cont: @query).result
    @steps = Step.ransack(description_cont: @query).result
  end

  def error(full_messages)
    respond_to do |format|
      format.js { render :text => full_messages.join("<br>"), :status => 400 }
    end
  end

  def check_rank
    current_dreamer.save(validate: false)

    if current_dreamer.points >= 25
      current_dreamer.rank = "Novice"
      current_dreamer.save(validate: false)

    elsif current_dreamer.points >= 75
      current_dreamer.rank = "Apprentice"
      current_dreamer.save(validate: false)

    elsif current_dreamer.points >= 150
      current_dreamer.rank = "Daydreamer"
      current_dreamer.save(validate: false)

    elsif current_dreamer.points >= 300
      current_dreamer.rank = "Sandman"
      current_dreamer.save(validate: false)

    elsif current_dreamer.points > 500
      current_dreamer.rank = "Dream Master"
      current_dreamer.save(validate: false)
    end
  end
end
