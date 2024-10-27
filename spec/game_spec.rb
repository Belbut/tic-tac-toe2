require_relative '../lib/game'

# frozen_string_literal: true

describe Game do
  describe '#play' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic game grid') }
    let(:player_dbl) { instance_double(Player, 'general player') }

    context "doesn't have a winner until" do
      before do
        allow(grid_dbl).to receive(:display_grid)
        allow(basic_game).to receive(:check_game_state)
        allow(basic_game).to receive(:current_player_turn).and_return(Player)
        allow(basic_game).to receive(:puts)
        allow(basic_game).to receive(:player_move)
        allow(basic_game).to receive(:display_board)
        allow(basic_game).to receive(:announce_winner)

        allow(player_dbl).to receive(:name).and_return String
      end

      it 'second try' do
        allow(basic_game).to receive(:check_game_state).and_return(nil, 'not nil')
        expect(basic_game).to receive(:current_player_turn).once
        allow(basic_game).to receive(:announce_winner).once
        basic_game.play
      end

      it 'third try' do
        allow(basic_game).to receive(:check_game_state).and_return(nil, nil, 'not nil')
        expect(basic_game).to receive(:current_player_turn).twice
        allow(basic_game).to receive(:announce_winner).once
        basic_game.play
      end
    end

    context 'when it has a winner' do
      before do
        allow(grid_dbl).to receive(:display_grid)
        allow(basic_game).to receive(:check_game_state).and_return('not nil')
        allow(basic_game).to receive(:announce_winner)
      end

      it 'it stops the game' do
        expect(basic_game).not_to receive(:turn)
        expect(basic_game).not_to receive(:player_move)
        expect(basic_game).not_to receive(:display_board)
        basic_game.play
      end

      it 'it announces the winner' do
        expect(basic_game).to receive(:announce_winner).once
        basic_game.play
      end
    end
  end

  describe '#current_player_turn' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic game grid') }
    let(:number) { instance_double(Integer, 'random turn') }
    context 'when the turn is' do
      before do
        allow(basic_game).to receive(:turn).and_return(number)
      end
      context 'even:' do
        it 'returns player1' do
          allow(number).to receive(:even?).and_return true
          player_returned = basic_game.current_player_turn
          player_expected = basic_game.instance_variable_get(:@player1)
          expect(player_returned).to be player_expected
        end
      end
      context 'odd:' do
        it 'returns player2' do
          allow(number).to receive(:even?).and_return false
          player_returned = basic_game.current_player_turn
          player_expected = basic_game.instance_variable_get(:@player2)
          expect(player_returned).to be player_expected
        end
      end
    end
  end

  describe '#player_move' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic game grid') }
    let(:player_dbl) { instance_double(Player, 'player') }

    context 'received an coordinate input that was' do
      context 'an invalid cell and after a valid' do
        before do
          allow(basic_game).to receive(:gets).and_return(String.new)
          allow(player_dbl).to receive(:symbol)
          @times_called = 0
          allow(grid_dbl).to receive(:add_symbol).with(any_args) do # .and_return do
            @times_called += 1
            return raise InputError if @times_called == 1

            []
          end

          allow(basic_game).to receive(:puts)
        end

        it 'should probe for player symbol twice' do
          expect(player_dbl).to receive(:symbol).twice
          basic_game.player_move(player_dbl)
        end

        it 'should send the message to add symbol to grid twice' do
          expect(grid_dbl).to receive(:add_symbol).twice
          basic_game.player_move(player_dbl)
        end

        context 'when trying to make the move in the grid' do
          let(:random_grid_add_symbol) { grid_dbl.add_symbol(String.new, String.new) }
          it 'first raise a InputError' do
            expect { random_grid_add_symbol }.to raise_error(InputError)
            basic_game.player_move(player_dbl)
          end

          it 'then execute the valid input' do
            # expect { grid_dbl }.to raise_error(InputError)
            expect { random_grid_add_symbol }.to raise_error(InputError)
            expect(random_grid_add_symbol).to be_a Array
            basic_game.player_move(player_dbl)
          end
        end

        it 'should print on terminal the error information' do
          expect(basic_game).to receive(:puts).twice
          basic_game.player_move(player_dbl)
        end
      end

      context 'valid cell' do
        before do
          allow(basic_game).to receive(:gets).and_return(String.new)
          allow(player_dbl).to receive(:symbol)
          allow(grid_dbl).to receive(:add_symbol).and_return([]) # @ts-ignore
        end
        it 'should probe for player symbol' do
          expect(player_dbl).to receive(:symbol).once
          basic_game.player_move(player_dbl)
        end

        it 'should send the message to add symbol to grid' do
          expect(grid_dbl).to receive(:add_symbol).once
          basic_game.player_move(player_dbl)
        end
      end
    end
  end

  describe '#check_game_state' do
    # no need for testing but method inside will when testing Grid class
  end

  describe '#turn' do
    # no need for testing but method inside will when testing Grid class
  end

  describe '#announce_winner' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic game grid') }
    context 'does it correctly identify the winner' do
      before do
        allow(basic_game).to receive(:puts)
      end

      it 'when it is player 1' do
        player1 = basic_game.instance_variable_get(:@player1)
        expect(basic_game).to receive(:puts).with("Congratulations #{player1.name}").once
        basic_game.announce_winner(player1.symbol)
      end

      it 'when it is player 2' do
        player2 = basic_game.instance_variable_get(:@player2)
        expect(basic_game).to receive(:puts).with("Congratulations #{player2.name}").once
        basic_game.announce_winner(player2.symbol)
      end
    end
  end

  describe '#display_board' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic game grid') }
    before do
      allow(basic_game).to receive(:puts)
      allow(grid_dbl).to receive(:display_grid)
    end

    it 'cleans the terminal' do
      expect(basic_game).to receive(:puts).with(`clear`).once
      basic_game.display_board
    end

    it 'displays the game board' do
      expect(grid_dbl).to receive(:display_grid).once
      basic_game.display_board
    end
  end

  describe '#reset_game' do
    # there is no need to test this method, only the methods that it calls
  end

  describe '#stalemate' do
    subject(:basic_game) { described_class.new(String, String, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic grid') }

    before do
      allow(basic_game).to receive(:display_board)
      allow(basic_game).to receive(:puts)
      allow(basic_game).to receive(:sleep)
    end

    context 'presents the last actions of the match' do
      it 'declaring the stalemate' do
        expect(basic_game).to receive(:puts).once
        basic_game.stalemate
      end

      it 'giving time to read the message' do
        expect(basic_game).to receive(:sleep).once
        basic_game.stalemate
      end
    end
  end

  describe '#change_player_order' do
    subject(:name_game) { described_class.new(name1, name2, grid_dbl) }
    let(:grid_dbl) { instance_double(Grid, 'basic grid') }
    let(:name1) { 'john' }
    let(:name2) { 'karen' }

    def get_players_names
      name_player1 = name_game.instance_variable_get(:@player1).name
      name_player2 = name_game.instance_variable_get(:@player2).name
      [name_player1, name_player2]
    end

    it 'correctly changes the order of the players' do
      expect(get_players_names).to eq [name1, name2]
      name_game.change_player_order
      expect(get_players_names).to eq [name2, name1]
    end
  end

  describe '#clear_board' do
    context 'it restarts the board for a new match' do
      subject(:basic_game) { described_class.new(String, String, grid_dbl) }
      let(:grid_dbl) { instance_double(Grid, 'basic grid') }

      before do
        allow(Grid).to receive(:new).and_return(grid_dbl)
        allow(grid_dbl).to receive(:display_grid)
      end

      it 'creates a new grid instance' do
        expect(Grid).to receive(:new).once
        basic_game.clear_board
        expect(basic_game.instance_variable_get(:@grid)).to be grid_dbl
      end

      it 'displays the new game board' do
        expect(grid_dbl).to receive(:display_grid).once
        basic_game.clear_board
      end
    end
  end
end
