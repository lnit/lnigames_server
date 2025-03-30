class RankItem < ApplicationRecord
  belongs_to :ranking_board

  attribute :name, :string, default: "No Name"

  validates :name, length: { maximum: 10 }

  def name=(val)
    val = val.to_s
    super(val.gsub(/[\r\n\f]/, "").strip)
  end
end
