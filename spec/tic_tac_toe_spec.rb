require './lib/tic_tac_toe.rb'

describe TicTacToe do
  let(:gameboard) {instance_double(Gameboard)}
  before do
    allow(gameboard).to receive(:draw)
    allow(gameboard).to receive(:choose_square)
    allow(gameboard).to receive(:system).with('clear')
    allow(gameboard).to receive(:win?).and_return(false)
    allow(gameboard).to receive(:size).and_return(3)
  end
  describe '#switch_player' do
    subject(:tic_switch_player) {described_class.new(1,gameboard)}

    let(:player_one) {tic_switch_player.instance_variable_get(:@player_one)}
    let(:player_two) {tic_switch_player.instance_variable_get(:@player_two)}
    describe 'when current player is player_one' do
      it 'changes the current player to player_two' do
        tic_switch_player.instance_variable_set(:@current_player, player_one)
        expect{tic_switch_player.switch_player}.to change{tic_switch_player.instance_variable_get(:@current_player)}.from(player_one).to(player_two)
      end
    end
    describe 'when current player is player_two' do
      it 'changes the current player to player_one' do
        tic_switch_player.instance_variable_set(:@current_player, player_two)
        expect{tic_switch_player.switch_player}.to change{tic_switch_player.instance_variable_get(:@current_player)}.from(player_two).to(player_one)
      end
    end
  end
  describe '#play' do
    subject(:tic_play) {described_class.new(1,gameboard)}
    let(:current_player) {tic_play.instance_variable_get(:@current_player)}
    describe 'when num is 3' do
      it 'increments move by one' do
        expect{tic_play.play(3)}.to change{tic_play.instance_variable_get(:@move)}.by(1)
      end
      it 'it calls gameboard.choose_square with 3' do
        expect(gameboard).to receive(:choose_square).with(3, current_player.symbol)

        tic_play.play(3)
      end
      it 'calls check_outcome' do
        expect(tic_play).to receive(:check_outcome).once

        tic_play.play(3)
      end
    end
  end
  describe '#check_outcome' do
    subject(:tic_outcome) {described_class.new(1,gameboard)}
    describe 'when it is a win' do
      it 'send a win message to reset' do
        allow(gameboard).to receive(:win?).and_return(true)
        expect(tic_outcome).to receive(:reset).with("win")

        tic_outcome.check_outcome()
      end
    end
    describe 'when it is a tie' do
      it 'sends a tie message to reset' do
        allow(gameboard).to receive(:win?).and_return(false)
        allow(gameboard).to receive(:size).and_return(3)
        tic_outcome.instance_variable_set(:@move,9)

        expect(tic_outcome).to receive(:reset).with("tie")
        tic_outcome.check_outcome()
      end
    end
    describe 'when its not a tie or win' do
      it 'doesnt send a message to reset' do
        allow(gameboard).to receive(:win?).and_return(false)
        allow(gameboard).to receive(:size).and_return(3)
        tic_outcome.instance_variable_set(:@move,1)

        expect(tic_outcome).to receive(:reset).never
        tic_outcome.check_outcome()
      end
    end
  end
  describe '#finished_game?' do
    subject(:tic_finished) {described_class.new(5,gameboard)}
    describe 'when game is finished' do
      it 'returns true' do
        tic_finished.instance_variable_set(:@rounds_played, 10)

        result = tic_finished.finished_game?
        expect(result).to eq(true)
      end
    end
    describe 'when game isnt finished' do
      it 'returns false' do
        tic_finished.instance_variable_set(:@rounds_played, 4)

        result = tic_finished.finished_game?
        expect(result).to eq(false)
      end
    end
  end
  describe '#reset' do
    subject(:tic_reset) {described_class.new(2,gameboard)}
    before do
      allow(tic_reset).to receive(:system)
      allow(tic_reset).to receive(:puts)
      allow_any_instance_of(Gameboard).to receive(:draw)
    end
    describe 'when the game is won' do
      it 'sends a win message' do
        current_player = tic_reset.instance_variable_get(:@current_player)
        win_message = "#{current_player.name} won this round."
        expect(tic_reset).to receive(:puts).with(win_message)
        tic_reset.reset("win")
      end
      it 'resets the gameboard' do
        expect(Gameboard).to receive(:new).with(3).and_return(gameboard)
        tic_reset.reset("win")
      end
      it 'resets the move count to 0' do
        tic_reset.instance_variable_set(:@move, 5)
        tic_reset.reset("win")
        expect(tic_reset.instance_variable_get(:@move)).to eq(0)
      end

      it 'resets the current player to player two' do
        tic_reset.instance_variable_set(:@current_player, tic_reset.instance_variable_get(:@player_one))
        tic_reset.reset("win")
        expect(tic_reset.instance_variable_get(:@current_player)).to eq(tic_reset.instance_variable_get(:@player_two))
      end

      it 'increments the rounds_played' do
        initial_rounds = tic_reset.instance_variable_get(:@rounds_played)
        tic_reset.reset("win")
        expect(tic_reset.instance_variable_get(:@rounds_played)).to eq(initial_rounds + 1)
      end
    end
    describe 'when the game is a tie' do
      it 'sends a tie message' do
        tie_message = "It was a tie."
        expect(tic_reset).to receive(:puts).with(tie_message)
        tic_reset.reset("tie")
      end
    end
  end
end

