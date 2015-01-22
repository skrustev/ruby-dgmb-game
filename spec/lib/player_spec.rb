require 'rspec/its'
require 'player'

describe 'Player' do 
  subject(:player) { Player.new("Player", "color") }

  its(:name) { should eq("Player") }
  its(:color) { should eq("color") }
  its(:active_pawns) { should eq(0) }
  its(:finished_pawns) { should eq(0) }
  its(:last_roll) { should eq([0, 0])}
  
  context "can determine initial positions for pawn from color " do
    it "#black" do
      player.determine_positions("black")

      expect(player.start_pos).to eq([0, 5])
      expect(player.initial_pos).to eq([[0,0], [0,1], [1,0], [1,1]])
    end

    it "#yellow" do
      player.determine_positions("yellow")

      expect(player.start_pos).to eq([7, 0])
      expect(player.initial_pos).to eq([[10,0], [10,1], [11,0], [11,1]])
    end

    it "#green" do
      player.determine_positions("green")

      expect(player.start_pos).to eq([11, 7])
      expect(player.initial_pos).to eq([[11,10], [10,10], [11,11], [10, 11]])
    end

    it "#red" do
      player.determine_positions("red")

      expect(player.start_pos).to eq([5, 11])
      expect(player.initial_pos).to eq([[1,11], [1, 10], [0,10], [0,11]])
    end
  end

  it "can roll the dice" do
    expect(player.roll_dice).to be_within(3).of(4)
  end

end