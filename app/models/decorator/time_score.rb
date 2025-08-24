module Decorator
  module TimeScore
    def score_txt
      # float型を "分:秒.ミリ秒" 形式にフォーマット
      Time.at(score).strftime("%M:%S.%3N")
    end
  end
end
