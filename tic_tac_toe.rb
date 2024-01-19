class Gameboard
  attr_accessor :size
  def initialize(size)
    @size = size
    create()
  end

  def create()
    @rows = []
    (@size).times do |num|
      @rows.push([])
      for i in (((num + 1) * @size) - (@size - 1))..(@size * (num + 1))
        @rows[num].push(i)
      end
    end
    @columns = []
    (@size).times do |num|
      @columns.push([])
      @size.times do |n|
        @columns[num].push(@rows[n][num])
      end
    end
    @diagonals = [[1],[@size]]
    (@size - 1).times do |num|
      @diagonals[0].push(@diagonals[0][num] + @size + 1)
      @diagonals[1].push(@diagonals[1][num] + @size - 1)
    end
  end

  # Draw the board
  def draw()
    @size.times do |num|
      puts "| #{@rows[num].join(" | ")} |"
    end
  end

  def choose_square(num, symbol)
    system "clear"
    found = false
    return if check_validity(num, symbol)
    [@rows,@columns,@diagonals].each do |array|
      array.each do |array2|
        array2.map!.with_index do |item| 
          found = true if item == num
          # Replace the item with the symbol if the item is equal to num
          num == item ? symbol : item
        end
      end
    end
    #Ask the user to retry if the number wasn't found
    check_validity(0, symbol) if !found
  end

  def check_validity(num,symbol)
    while (num < 1) || (num > @size * @size)
      system "clear"
      valid = false
      puts "Incorrect value entered"
      draw()
      puts "Where to put the #{symbol}?"
      num = gets.to_i
      valid = true if (num > 0) || (num < @size * @size)
    end
    choose_square(num,symbol) if valid
    valid
  end

  def win?()
    [@rows,@columns,@diagonals].each do |array|
      array.each do |array2|
        return true if array2.uniq.size == 1
      end
    end
  end
end

class Player
  attr_accessor :name, :symbol, :score
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @score = 0
  end
end

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
