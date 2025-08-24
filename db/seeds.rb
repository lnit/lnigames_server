# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding initial data..."
PT, TM = PointRankingBoard, TimeRankingBoard
projects = [
  { code: "TsumugiStep", board_klass: PT },
  { code: "AkariFlyHigh", board_klass: TM },
  { code: "MeshiCatch", board_klass: TM },
  { code: "AkariSoba", board_klass: PT },
]

projects.each do |project_data|
  project = Project.find_or_create_by!(code: project_data[:code])

  if project.ranking_boards.blank?
    project_data[:board_klass].create!(project: project)
    puts "Created ranking board for project: #{project.code} with class: #{project_data[:board_klass]}"
  end
end
