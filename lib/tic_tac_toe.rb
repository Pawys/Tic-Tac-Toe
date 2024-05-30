require_relative 'gameboard'
require_relative 'player'

class TicTacToe
  attr_accessor :current_player
  def initialize(round)
    @move = 0
    @round_ammount = round
    @rounds_played = 0
    @gameboard = Gameboard.new(3)
    @gameboard.draw()
    @player_one = Player.new("Player_One", "X")
    @player_two = Player.new("Player_Two", "O")
    @current_player = @player_two
  end

  def switch_player()
    @current_player = (@current_player == @player_one) ? @player_two : @player_one
  end

  def play(num)
    @move += 1
    @gameboard.choose_square(num,@current_player.symbol())
    @gameboard.draw()
    check_outcome()
  end

  def check_outcome()
    (@current_player.score += 1) && reset("win") if @gameboard.win? == true
    reset("tie") if @move >= @gameboard.size * @gameboard.size
  end

  def finished_game?()
    return true if @rounds_played >= @round_ammount
  end

  def reset(result)
    @rounds_played += 1
    return if finished_game?
    @move = 0
    @gameboard = Gameboard.new(3)
    system "clear"
    puts result == "tie" ? "It was a tie." : (result == "win" ? "#{@current_player.name} won this round." : nil)
    puts ""
    @gameboard.draw()
    @current_player = @player_two
  end
end
