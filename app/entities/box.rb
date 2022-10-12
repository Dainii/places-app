module Entities
  class Box
    attr_accessor :x, :y, :color

    def initialize(x:, y:, color:)
      self.x = x
      self.y = y
      self.color = color
    end
  end
end
