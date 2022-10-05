class Game
  attr_accessor :inputs, :state, :outputs, :grid, :args, :active_controller

  def goto_title
    @active_controller = ::Controllers::TitleController
  end

  def goto_game(args)
    @active_controller = ::Controllers::CanvaController
  end

  # Runs methods necessary for the game to function properly.
  def tick
    goto_title unless active_controller
    active_controller.tick(args)
    active_controller.render(inputs, state, outputs, grid, args)
  end
end
