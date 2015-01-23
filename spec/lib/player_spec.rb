require 'rspec/its'
require 'player'

describe 'Player' do 
  subject(:player) { Player.new("Player", "color") }

  its(:name) { should eq("Player") }
  its(:color) { should eq("color") }
  its(:active_pawns) { should eq(0) }
  its(:finished_pawns) { should eq(0) }
  its(:last_roll) { should eq([0, 0])}
  
  context "black colored player " do
    let(:black_player) { Player.new("Player", "black") }

    it "can determine initial positions for pawns" do
      black_player.determine_positions("black")

      expect(black_player.start_pos).to eq([0, 5])
      expect(black_player.initial_pos).to eq([[0,0], [0,1], [1,0], [1,1]])
    end
    
    it "can set initial name/position on pawns" do
      black_pos = [[0,0], [0,1], [1,0], [1,1]]
      black_player.pawns.each do |key, pawn|
        index = key[-1].to_i
        expect(pawn.name).to eq("p:b:#{index}")
        expect(pawn.player_name).to eq(black_player.name)
        expect(pawn.initial_pos).to eq(black_pos[index])
      end
    end
  end

  context "yellow colored player " do
    let(:yellow_player) { Player.new("Player", "yellow") }

    it "can determine initial positions for pawns" do
      yellow_player.determine_positions("yellow")

      expect(yellow_player.start_pos).to eq([7, 0])
      expect(yellow_player.initial_pos).to eq([[10,0], [10,1], [11,0], [11,1]])
    end

    it "can set initial name/position on pawns" do
      yellow_pos = [[10,0], [10,1], [11,0], [11,1]]
      yellow_player.pawns.each do |key, pawn|
        index = key[-1].to_i
        expect(pawn.name).to eq("p:y:#{index}")
        expect(pawn.player_name).to eq(yellow_player.name)
        expect(pawn.initial_pos).to eq(yellow_pos[index])
      end
    end
  end

  context "green colored player " do
    let(:green_player) { Player.new("Player", "green") }

    it "can determine initial positions for pawns" do
      green_player.determine_positions("green")

      expect(green_player.start_pos).to eq([11, 7])
      expect(green_player.initial_pos).to eq([[11,10], [10,10], [11,11], [10, 11]])
    end


    it "can set initial name/position on pawns"do
      green_pos = [[11,10], [10,10], [11,11], [10, 11]]
      green_player.pawns.each do |key, pawn|
        index = key[-1].to_i
        expect(pawn.name).to eq("p:g:#{index}")
        expect(pawn.player_name).to eq(green_player.name)
        expect(pawn.initial_pos).to eq(green_pos[index])
      end
    end
  end

  context "red colored player " do
    let(:red_player) { Player.new("Player", "red") }

    it "can determine initial positions for pawns" do
      red_player.determine_positions("red")

      expect(red_player.start_pos).to eq([5, 11])
      expect(red_player.initial_pos).to eq([[1,11], [1, 10], [0,10], [0,11]])
    end

    it "can set initial name/position on pawns" do
      red_pos = [[1,11], [1, 10], [0,10], [0,11]]
      red_player.pawns.each do |key, pawn|
        index = key[-1].to_i
        expect(pawn.name).to eq("p:r:#{index}")
        expect(pawn.player_name).to eq(red_player.name)
        expect(pawn.initial_pos).to eq(red_pos[index])
      end
    end
  end

  it "can roll the dice" do
    expect(player.roll_dice).to be_within(3).of(4)
  end
end