require './tic_tac_toe.rb'

describe Gameboard do
  subject(:gameboard) {described_class.new()}

  describe '#win?' do
    let(:rows) {gameboard.instance_variable_get(:@rows)}
    let(:columns) {gameboard.instance_variable_get(:@columns)}
    let(:diagonals) {gameboard.instance_variable_get(:@diagonals)}
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
