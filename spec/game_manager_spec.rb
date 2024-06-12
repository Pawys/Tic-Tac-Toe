require_relative '../lib/game_manager'

describe GameManager do
  subject(:game_manager) {described_class.new()}
  let(:tic_tac_toe) {instance_double(TicTacToe)}
  let(:player) {instance_double(Player)}
  before do
    allow(game_manager).to receive(:system)
    allow(game_manager).to receive(:puts)
    allow(tic_tac_toe).to receive(:current_player).and_return(player)
    allow(player).to receive(:symbol).and_return("X")
    allow(player).to receive(:name).and_return("player")
    allow(player).to receive(:score).and_return(1)
    allow(tic_tac_toe).to receive (:switch_player)
  end
  describe '#get_rounds' do
    message = "Enter the desired number of rounds"
    describe 'when player input is correct' do
      it 'sends the message asking for input once' do
        allow(game_manager).to receive(:gets).and_return(1)
        expect(game_manager).to receive(:puts).with(message)
        game_manager.get_rounds()
      end
    end
    describe 'when the player enters incorrect input and then correct input' do
      it 'sends the message asking for input once' do
        allow(game_manager).to receive(:gets).and_return(123,1)
        expect(game_manager).to receive(:puts).with(message).twice
        game_manager.get_rounds()
      end
    end
  end
  describe '#loop_game' do
    describe 'when game is not finished' do
      before do
        allow(tic_tac_toe).to receive(:finished_game?).and_return(false,true)
        allow(tic_tac_toe).to receive(:play)
        allow(game_manager).to receive(:gets).and_return(1)
      end
      it 'sends .play once' do
        expect(tic_tac_toe).to receive(:play).once
        game_manager.loop_game(tic_tac_toe)
      end
      it 'switches the player' do
        expect(tic_tac_toe).to receive(:switch_player).once
        game_manager.loop_game(tic_tac_toe)
      end
    end
    describe 'when game is finished' do
      before do
        allow(tic_tac_toe).to receive(:finished_game?).and_return(true)
      end
      it 'doesnt send .play once' do
        expect(tic_tac_toe).to receive(:play).never
        game_manager.loop_game(tic_tac_toe)
      end
      it 'doesnt switch the player' do
        expect(tic_tac_toe).to receive(:switch_player).never
        game_manager.loop_game(tic_tac_toe)
      end
    end
  end
  describe '#end_game' do
    it 'switches the player' do
      allow(game_manager).to receive(:gets).and_return("y")
      expect(tic_tac_toe).to receive(:switch_player).once
      game_manager.end_game(tic_tac_toe)
    end
    describe 'when player says y' do
      it 'doesnt change the game loop' do
      allow(game_manager).to receive(:gets).and_return("y")
      expect{game_manager.end_game(tic_tac_toe)}.to_not change{game_manager.instance_variable_get(:@game_loop)}
      end
    end
    describe 'when player says n' do
      it 'changes game_loop to false' do
        allow(game_manager).to receive(:gets).and_return("n")
        expect{game_manager.end_game(tic_tac_toe)}.to change{game_manager.instance_variable_get(:@game_loop)}.to (false)
      end
    end
  end
  describe '#play_game' do
    describe 'when game loop is true' do
      before do
        allow(game_manager).to receive(:game_over?).and_return(false,true)
        allow(game_manager).to receive(:get_rounds).and_return(1)
        allow(game_manager).to receive(:loop_game)
        allow(game_manager).to receive(:end_game)
      end
      it 'calls get_rounds' do
        expect(game_manager).to receive(:get_rounds).once
        game_manager.play_game()
      end
      it 'calls loop_game' do
        expect(game_manager).to receive(:loop_game).once
        game_manager.play_game()
      end
      it 'calls end_game' do
        expect(game_manager).to receive(:end_game).once
        game_manager.play_game()
      end
      it 'creats game' do
        expect(TicTacToe).to receive(:new).with(1)
        game_manager.play_game()
      end
    end
    describe 'when game_loop is false' do
      before do
        allow(game_manager).to receive(:game_over?).and_return(true)
      end
      it 'doesnt call get_rounds' do
        expect(game_manager).to receive(:get_rounds).never
        game_manager.play_game()
      end
      it 'doesnt call loop_game' do
        expect(game_manager).to receive(:loop_game).never
        game_manager.play_game()
      end
      it 'doesnt call end_game' do
        expect(game_manager).to receive(:end_game).never
        game_manager.play_game()
      end
      it 'doesnt call game' do
        expect(TicTacToe).to receive(:new).with(1).never
        game_manager.play_game()
      end
    end
  end
end
