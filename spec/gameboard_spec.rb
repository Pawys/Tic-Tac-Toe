require './lib/gameboard.rb'

describe Gameboard do

  subject(:gameboard) {described_class.new()}
  let(:rows) {gameboard.instance_variable_get(:@rows)}
  let(:columns) {gameboard.instance_variable_get(:@columns)}
  let(:diagonals) {gameboard.instance_variable_get(:@diagonals)}
  
  describe '#create' do
    it 'creates and ads value to rows' do
      empty_rows = []
      expect{gameboard.create(empty_rows)}.to change { empty_rows }.to [[1,2,3],[4,5,6],[7,8,9]]
    end
    it 'creates and ads value to columnss' do
      empty_columns = []
      expect{gameboard.create(rows,empty_columns)}.to change { empty_columns }.to [[1,4,7],[2,5,8],[3,6,9]]
      diagonals = gameboard.instance_variable_get(:@diagonals)
    end
    it 'creates and ads value to diagonals' do
      empty_diagonals = []
      expect{gameboard.create(rows,columns,empty_diagonals)}.to change { empty_diagonals }.to [[1,5,9],[3,5,7]]
    end
  end
  describe '#number_invalid?' do
    describe 'number is not smaller than 1' do 
      it 'returns false' do
        result = gameboard.number_invalid?(1)
        expect(result).to eq(false)
      end
    end
    describe 'number is smaller than @size*@size' do 
      it 'returns false' do
        result = gameboard.number_invalid?(5)
        expect(result).to eq(false)
      end
    end
    describe 'num is not a integer' do 
      it 'returns true' do
        result = gameboard.number_invalid?('d')
        expect(result).to eq(true)
      end
    end
    describe 'number is smaller than 1' do
      it 'returns true' do
        result = gameboard.number_invalid?(-1)
        expect(result).to eq(true)
      end
    end
    describe 'number is bigger than @size*size' do 
      it 'returns false' do
        result = gameboard.number_invalid?(123)
        expect(result).to eq(true)
      end
    end
  end
  describe '#win?' do
    describe 'when one of the rows are full' do
      it 'returns true' do 
        winning_rows = [['x','x','x']]
        result = gameboard.win?(winning_rows,columns,diagonals)
        expect(result).to eq(true)
      end
    end
    describe 'when one of the columns are full' do
      it 'returns true' do 
        winning_columns = [['x','x','x']]
        result = gameboard.win?(rows,winning_columns,diagonals)
        expect(result).to eq(true)
      end
    end
    describe 'when one of the diaganals are full' do
      it 'returns true' do 
        winning_diagonals = [['x','x','x']]
        result = gameboard.win?(rows,columns,winning_diagonals)
        expect(result).to eq(true)
      end
    end
    describe 'when none of the arrays are full' do
      it 'returns false' do
        result = gameboard.win?(rows,columns,diagonals)
        expect(result).to eq(false)
      end
    end
  end
end
