module Entities
  class Canva
    attr_accessor :boxes, :height, :length

    DEFAULT_HEIGTH = 50
    DEFAULT_LENGTH = 50

    def initialize(heigth:, length:)
      boxes = []
      self.heigth = heigth || DEFAULT_HEIGHT
      self.length = length || DEFAULT_LENGTH
    end
  end
end
