class Api::V1::RankingNamesController < Api::V1::ApplicationController
  before_action :authenticate!, only: [:update]

  def update
    rank_item.update!(name: permitted_params[:name])

    head :no_content
  end

  def permitted_params
    @permitted_params ||= params.permit(
      :project_code,
      :board_num,
      :uid,
      :name,
    )
  end

  def project
    @project ||= Project.find_by!(code: permitted_params[:project_code])
  end

  def ranking
    @ranking ||= project.ranking_boards.find_by!(num: permitted_params[:board_num])
  end

  def rank_item
    @rank_item = ranking.rank_items.find_by!(uid: permitted_params[:uid])
  end

  def authenticate!
    auth = {
      pj: params[:project_code],
      uid: params[:uid],
      arg_str: params[:name],
      digest: params[:d]
    }

    head :forbidden unless LniGamesAuth.valid?(**auth)
  end
end
