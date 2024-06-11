require './lib/gameboard.rb'

describe Gameboard do

  subject(:gameboard) {described_class.new()}
  let(:rows) {gameboard.instance_variable_get(:@rows)}
  let(:columns) {gameboard.instance_variable_get(:@columns)}
  let(:diagonals) {gameboard.instance_variable_get(:@diagonals)}
  before do
    allow(gameboard).to receive(:puts)
    allow(gameboard).to receive(:system).with("clear")
  end
  
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
  describe '#get_number' do

    invalid_input = 999
    valid_input = 1

    describe 'when user input is valid' do
      it 'stops the loop and print error message once' do
        allow(gameboard).to receive(:gets).and_return(valid_input)
        expect(gameboard).to receive(:puts).with('Incorrect value entered').once
        gameboard.get_number(invalid_input)
      end
    end
    describe 'when the user inputs an invalid value, then a valid value' do
      before do
        allow(gameboard).to receive(:gets).and_return(invalid_input,valid_input)
      end
      it 'stops the loop and print error message twice' do
        expect(gameboard).to receive(:puts).with('Incorrect value entered').twice
        gameboard.get_number(invalid_input)
      end
    end
    describe 'when the user inputs an invalid value five times, then a valid value' do
      before do
        allow(gameboard).to receive(:gets).and_return(invalid_input,invalid_input,invalid_input,invalid_input,invalid_input,valid_input)
      end
      it 'stops the loop and print error message once' do
        expect(gameboard).to receive(:puts).with('Incorrect value entered').exactly(6).times
        gameboard.get_number(invalid_input)
      end
    end
  end
  describe '#choose_square' do
    describe 'if num is valid and untaken' do
      it 'changes the given square to the symbol' do
        expect{gameboard.choose_square(1,'X')}.to change{rows[0][0]}.to 'X'
      end
    end
    describe 'if num is valid but taken' do
      before do
        gameboard.choose_square(1,'X')
      end
      it 'calls the choose_square function again' do
        allow(gameboard).to receive(:choose_square)
        expect(gameboard).to receive(:choose_square).once
        gameboard.choose_square(1,'X')
      end
    end
    describe 'if num is not valid' do
      it 'calls the get_number function and then itself' do
        allow(gameboard).to receive(:choose_square).and_call_original
        allow(gameboard).to receive(:get_number).and_return(2)

        expect(gameboard).to receive(:get_number).once
        expect(gameboard).to receive(:choose_square).with(2,'X')

        gameboard.choose_square(123,'X')
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
