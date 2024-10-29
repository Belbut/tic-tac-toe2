require_relative '../lib/game'

# frozen_string_literal: true
describe 'Tic-Tac-Toe Game full setting spec:' do
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
          expect(basic_game.instance_variable_get(:@board)).to be grid_dbl
        end

        it 'displays the new game board' do
          expect(grid_dbl).to receive(:display_grid).once
          basic_game.clear_board
        end
      end
    end

    describe 'WinCondition' do
      describe '#winner' do
        subject(:game_winner) { described_class.new(String, String) }

        let(:vertical_winning_grid1) { [['x', 'x', 'x'], [' ', ' ', ' '], [' ', ' ', ' ']] }
        let(:vertical_winning_grid2) { [[' ', ' ', ' '], ['o', 'o', 'o'], [' ', ' ', ' ']] }
        let(:vertical_winning_grid3) { [[' ', ' ', ' '], [' ', ' ', ' '], ['?', '?', '?']] }
        let(:vertical_winning) { [vertical_winning_grid1, vertical_winning_grid2, vertical_winning_grid3] }

        let(:horizontal_winning_grid1) { [['x', ' ', ' '], ['x', ' ', ' '], ['x', ' ', ' ']] }
        let(:horizontal_winning_grid2) { [[' ', 'o', ' '], [' ', 'o', ' '], [' ', 'o', ' ']] }
        let(:horizontal_winning_grid3) { [[' ', ' ', '?'], [' ', ' ', '?'], [' ', ' ', '?']] }
        let(:horizontal_winning) { [horizontal_winning_grid1, horizontal_winning_grid2, horizontal_winning_grid3] }

        let(:diagonal_winning_grid1) { [['x', ' ', ' '], [' ', 'x', ' '], [' ', ' ', 'x']] }
        let(:diagonal_winning_grid2) { [[' ', ' ', 'o'], [' ', ' ', 'o'], [' ', ' ', 'o']] }
        let(:diagonal_winning) { [diagonal_winning_grid1, diagonal_winning_grid2] }

        let(:no_winner_grid1) { [%w[x o x], %w[x x o], %w[o x o]] }
        let(:no_winner_grid2) { [%w[o x o], %w[x o x], %w[x o x]] }
        let(:no_winner_grid3) { [%w[x x o], %w[o x x], %w[x o o]] }
        let(:no_winner_grid4) { [['x', 'o', 'x'], [' ', 'o', 'x'], ['x', ' ', 'o']] }
        let(:no_winner_grid5) { [['x', ' ', 'x'], [' ', 'o', ' '], ['x', 'o', ' ']] }
        let(:no_winner_grid6) { [['x', ' ', ' '], ['o', 'x', ' '], [' ', 'x', ' ']] }
        let(:no_winner_grid7) { [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']] }

        let(:no_winning) do
          [no_winner_grid1, no_winner_grid3, no_winner_grid4, no_winner_grid5, no_winner_grid6, no_winner_grid7]
        end

        context 'identifies a winning situation' do
          it 'when it is vertical' do
            vertical_winning.each do |board_condition|
              game_winner.board.instance_variable_set(:@grid, board_condition)
              expect(game_winner.winner).not_to be nil
            end
          end

          it 'when it is horizontal' do
            horizontal_winning.each do |board_condition|
              game_winner.board.instance_variable_set(:@grid, board_condition)
              expect(game_winner.winner).not_to be nil
            end
          end

          it 'when is is diagonal' do
            diagonal_winning.each do |board_condition|
              game_winner.board.instance_variable_set(:@grid, board_condition)
              expect(game_winner.winner).not_to be nil
            end
          end
        end

        context 'when there is no winner condition' do
          it "doesn't give a false positive" do
            no_winning.each do |board_condition|
              game_winner.board.instance_variable_set(:@grid, board_condition)
              expect(game_winner.winner).to be nil
            end
          end
        end
      end
    end
  end

  describe Grid do
    describe '#occupied_cell_count' do
      subject(:basic_grid) { described_class.new }
      context 'when its a brand new grid' do
        it 'returns zero' do
          expect(basic_grid.occupied_cell_count).to be_zero
        end
      end
    end

    describe '#is_full?' do
      subject(:basic_grid) { described_class.new }
      context 'with no blank spaces' do
        before do
          allow(basic_grid).to receive(:occupied_cell_count).and_return(basic_grid.size)
        end
        it do
          expect(basic_grid).to be_full
        end
      end
      context 'with some blank spaces' do
        before do
          allow(basic_grid).to receive(:occupied_cell_count).and_return(rand(basic_grid.size))
        end
        it do
          expect(basic_grid).to_not be_full
        end
      end

      describe 'GridManipulation' do
        subject(:basic_grid) { described_class.new }

        describe '#add_symbol' do
          before do
            # allow(basic_grid).to receive(:write_cell)
            allow(GridCoordinates).to receive(:raw_to_decomposed_coordinate)
          end

          it 'forwards the correct messages' do
            expect(GridCoordinates).to receive(:raw_to_decomposed_coordinate)
            expect(basic_grid).to receive(:write_cell).once
            basic_grid.add_symbol(String.new, String.new)
          end

          context 'if the target cell in on the grid' do
            let(:target_cell_x) { 0 }
            let(:target_cell_y) { 0 }
            let(:symbol) { 'x' }

            let(:target_cell_value) { -> { basic_grid.grid[target_cell_x][target_cell_y] } }
            before do
              allow(GridCoordinates).to receive(:raw_to_decomposed_coordinate).and_return({ x: target_cell_x,
                                                                                            y: target_cell_y })
            end

            context 'is empty' do
              it 'changes the target cell to the symbol' do
                expect { basic_grid.add_symbol(String.new, symbol) }.to change { target_cell_value.call }.to(symbol)
              end

              it 'leaves all the other cells has they were' do
                expect { basic_grid.add_symbol(String.new, symbol) }.to change { basic_grid.occupied_cell_count }.to(1)
              end
            end

            context 'is occupied' do
              before do
                basic_grid.add_symbol(String.new, 'occupied')
              end
              it 'raises InputError' do
                expect { basic_grid.add_symbol(String.new, symbol) }.to raise_error(InputError)
              end

              it "doesn't change the cell value" do
                expect { basic_grid.add_symbol(String.new, symbol) }.to raise_error(InputError)
                expect(target_cell_value.call).to eq 'occupied'
              end

              it 'leaves all the other cells has they were' do
                expect { basic_grid.add_symbol(String.new, symbol) }.to raise_error(InputError)
                expect(basic_grid.occupied_cell_count).to eq 1
              end
            end
          end

          context "if the target cell doesn't exist in the grid" do
            let(:impossible_cell_x) { Float::INFINITY }
            let(:impossible_cell_y) { Float::INFINITY }
            let(:symbol) { 'x' }
            before do
              allow(GridCoordinates).to receive(:raw_to_decomposed_coordinate).and_return({ x: impossible_cell_x,
                                                                                            y: impossible_cell_y })
            end
            it 'raises InputError' do
              expect { basic_grid.add_symbol(String.new, symbol) }.to raise_error(InputError)
            end
            it "doesn't change any value from the grid" do
              expect { basic_grid.add_symbol(String.new, symbol) }.to raise_error(InputError)
              expect(basic_grid.occupied_cell_count).to eq 0
            end
          end
        end
      end
    end
  end

  describe GridCoordinates do
    describe '::raw_to_decomposed_coordinate' do
      let(:random_raw_coordinate) { [[*'A'..'Z'].sample, [*'1'..'42'].sample].join }
      described_function = ->(raw) { described_class.raw_to_decomposed_coordinate(raw) }

      it 'returns an hash' do
        random_decomposed_coordinate = described_function.call(random_raw_coordinate)
        expect(random_decomposed_coordinate).to be_a Hash
      end

      it 'with correct structure' do
        random_decomposed_coordinate = described_function.call(random_raw_coordinate)
        keys = random_decomposed_coordinate.keys
        expect(keys).to eq %i[x y]
      end

      context 'returns the correct coordinate' do
        it 'when input is A1 returns [0,0]' do
          raw_coordinate = 'A1'
          expect(described_function.call(raw_coordinate)).to eq({ x: 0, y: 0 })
        end

        it 'when input is a1 returns [0,0]' do
          raw_coordinate = 'a1'
          expect(described_function.call(raw_coordinate)).to eq({ x: 0, y: 0 })
        end

        it 'when input is 1a returns [0,0]' do
          raw_coordinate = '1a'
          expect(described_function.call(raw_coordinate)).to eq({ x: 0, y: 0 })
        end

        it 'when input is 1aa returns [0,0]' do
          raw_coordinate = '1aa'
          expect(described_function.call(raw_coordinate)).to eq({ x: 0, y: 0 })
        end

        it 'when input is z1a returns [25,0]' do
          raw_coordinate = 'z1a'
          expect(described_function.call(raw_coordinate)).to eq({ x: 25, y: 0 })
        end

        it 'when input is D42 returns [3,41]' do
          raw_coordinate = 'D42'
          expect(described_function.call(raw_coordinate)).to eq({ x: 3, y: 41 })
        end

        it 'when input is Z42 returns [25,41]' do
          raw_coordinate = 'Z42'
          expect(described_function.call(raw_coordinate)).to eq({ x: 25, y: 41 })
        end
      end
    end
  end
end
