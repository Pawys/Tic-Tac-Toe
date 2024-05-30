require_relative 'lib/tic_tac_toe'

def play_tic_tac_toe()
  game_loop = true
  while game_loop do 
    system "clear"
    game_loop = false 
    puts "Enter the desired number of rounds"
    round = gets.to_i
    while (round < 1) || (round > 100)
      puts "Enter the desired number of rounds"
      round = gets.to_i
    end
    system "clear"
    test = TicTacToe.new(round)
    until test.finished_game? do
      test.switch_player()
      puts "Where to put the #{test.current_player.symbol}?"
      test.play(gets.to_i)
    end
    system "clear"
    puts "Game finished"
    puts ""
    puts "#{test.current_player.name}'s score was #{test.current_player.score}"
    test.switch_player()
    puts "#{test.current_player.name}'s score was #{test.current_player.score}"
    puts ""
    puts "Do you want to play again? (y/n)"
    game_loop = true if gets.chomp == "y"
  end
end

play_tic_tac_toe()
