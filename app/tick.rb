#####################
# tick.rb
#####################
# Given that =app/tick.rb= is the last ~require~ statement in =app/main.rb=, all classes should
# be available.

$game ||= Game.new

def tick(args)
  $game.inputs = args.inputs
  $game.state = args.state
  $game.grid = args.grid
  $game.args = args
  $game.outputs = args.outputs
  $game.tick
end
