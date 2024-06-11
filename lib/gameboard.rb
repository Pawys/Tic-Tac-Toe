class Gameboard
  attr_accessor :size
  def initialize(size=3)
    @size = size
    @rows = []
    @columns = []
    @diagonals = []
    create()
  end

  def create(rows=@rows,columns=@columns,diagonals=@diagonals)
    (@size).times do |num|
      rows.push([])
      for i in (((num + 1) * @size) - (@size - 1))..(@size * (num + 1))
        rows[num].push(i)
      end
    end
    (@size).times do |num|
      columns.push([])
      @size.times do |n|
        columns[num].push(rows[n][num])
      end
    end
    diagonals.push([1],[@size])
    (@size - 1).times do |num|
      diagonals[0].push(diagonals[0][num] + @size + 1)
      diagonals[1].push(diagonals[1][num] + @size - 1)
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
    if number_invalid?(num)
      num = get_number(num,symbol)
      choose_square(num,symbol)
      return
    end
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
    if !found
      num = get_number(0,symbol)
      choose_square(num,symbol)
      return
    end
  end
  def get_number(num,symbol="symbol")
    while num.class != Integer || (num < 1) || (num > @size * @size)
      system "clear"
      puts "Incorrect value entered"
      draw()
      puts "Where to put the #{symbol}?"
      num = gets.to_i
    end
    return num
  end
  def number_invalid?(num)
    invalid = false
    if num.class != Integer || (num < 1) || (num > @size * @size)
      invalid = true
    end
    invalid
  end

  def win?(rows=@rows,columns=@columns,diagonals=@diagonals)
    [rows,columns,diagonals].each do |array|
      array.each do |array2|
        return true if array2.uniq.size == 1
      end
    end
    false
  end
end
