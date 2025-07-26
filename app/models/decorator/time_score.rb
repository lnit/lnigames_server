module Decorator
  module TimeScore
    def score_txt
      # ミリ秒を "分:秒.ミリ秒" 形式にフォーマット
      # 例: 123456ms -> 02:03.456
      Time.at(score / 1000.0).strftime("%M:%S.") + format("%03d", score % 1000)
    end
  end
end
