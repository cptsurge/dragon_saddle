def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
