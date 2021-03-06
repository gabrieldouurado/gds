class SurveysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_survey, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :create]

  # GET /surveys  
  # GET user related surveys
  def index
    @surveys = Survey.filter_by_user(current_user.id)

    render json: @surveys
  end

  # GET /all_surveys
  def all_surveys
    @surveys = Survey.all
    
    render json: @surveys
  end
  # GET /surveys/1
  def show
    render json: @survey
  end

  # POST /surveys
  def create
    @survey = Survey.new(survey_params)
    
    @survey.user_id = @user.id

    if @survey.save
      render json: @survey, status: :created, location: user_survey_path(:id => @user)
    else
      render json: @survey.errors, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1
  def destroy
    @survey.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    def set_user
      @user = User.find(current_user.id)
    end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(
        :user_id,
        :household_id, 
        :latitude, 
        :longitude, 
        :bad_since, 
        :traveled_to,
        :street, 
        :city, 
        :state, 
        :country,
        :went_to_hospital,
        :contact_with_symptom,
        symptom: []
      ) 
    end
end
