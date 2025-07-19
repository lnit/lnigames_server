class Api::V1::RankingItemsController < Api::V1::ApplicationController
  before_action :authenticate!, only: [:create]

  def index
    render json: ranking.display_ranking(uid: permitted_params[:uid])
  end

  def create
    ranking.add_item!(ranking_params)

    head :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages } , status: :unprocessable_entity
  end

  def permitted_params
    @permitted_params ||= params.permit(
      :project_code,
      :board_num,
      :score,
      :uid,
      :name,
    )
  end

  def ranking_params
    permitted_params.slice(:score, :uid, :name)
  end

  def project
    @project ||= Project.find_by!(code: permitted_params[:project_code])
  end

  def ranking
    @ranking ||= project.ranking_boards.find_by!(num: permitted_params[:board_num])
  end

  def authenticate!
    auth = {
      pj: params[:project_code],
      uid: params[:uid],
      arg_str: params[:score],
      digest: params[:d]
    }

    head :forbidden unless LniGamesAuth.valid?(**auth)
  end
end
