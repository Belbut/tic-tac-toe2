require './lib/grid'
# frozen_string_literal: true

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
