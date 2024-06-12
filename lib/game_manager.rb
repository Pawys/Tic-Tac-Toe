require_relative 'tic_tac_toe'

class GameManager
  def initialize()
    @game_loop = true
  end
  def get_rounds()
    system "clear"
    puts "Enter the desired number of rounds"
    round = gets.to_i
    while (round < 1) || (round > 100)
      puts "Enter the desired number of rounds"
      round = gets.to_i
    end
    round
  end
  def loop_game(game = @game)
    until game.finished_game? do
      game.switch_player()
      puts "Where to put the #{game.current_player.symbol}?"
      game.play(gets.to_i)
    end
  end
  def end_game(game = @game)
    system "clear"
    puts "Game finished"
    puts ""
    puts "#{game.current_player.name}'s score was #{game.current_player.score}"
    game.switch_player()
    puts "#{game.current_player.name}'s score was #{game.current_player.score}"
    puts ""
    puts "Do you want to play again? (y/n)"
    @game_loop = false if gets.chomp == "n"
    system "clear"
  end
  def play_game()
    until @game_loop == false do
      round = get_rounds()
      system "clear"
      @game = TicTacToe.new(round)
      loop_game(@game)
      end_game()
    end
  end
end
