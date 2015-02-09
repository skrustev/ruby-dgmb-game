require 'rspec/its'
require 'player'

describe 'Player' do 
  subject(:player) { Player.new("Player", "color") }

  its(:name) { should eq("Player") }
  its(:color) { should eq("color") }
  its(:active_pawns) { should eq(0) }
  its(:finished_pawns) { should eq(0) }
  its(:last_roll) { should eq(0)}
  
  context "blue colored player " do
    let(:blue_player) { Player.new("Player", "blue") }

    it "can determine initial positions for pawns" do
      blue_player.determine_positions("blue")

      expect(blue_player.start_pos).to eq([0,6])
      expect(blue_player.initial_pos).to eq([[2,11], [2,12], [3,11], [3,12]])
    end
    
    it "can set initial name/position on pawns" do
      blue_pos = [[2,11], [2,12], [3,11], [3,12]]

      expect(blue_player.pawns[:"b:0"].name).to eq("b:0")
      expect(blue_player.pawns[:"b:0"].pos).to eq(blue_pos[0])

      expect(blue_player.pawns[:"b:1"].name).to eq("b:1")
      expect(blue_player.pawns[:"b:1"].pos).to eq(blue_pos[1])
      
      expect(blue_player.pawns[:"b:2"].name).to eq("b:2")
      expect(blue_player.pawns[:"b:2"].pos).to eq(blue_pos[2])
      
      expect(blue_player.pawns[:"b:3"].name).to eq("b:3")
      expect(blue_player.pawns[:"b:3"].pos).to eq(blue_pos[3])
    end

    it "can activate pawn" do
      blue_player.activate_pawn("b:1")

      expect(blue_player.pawns[:"b:1"].pos).to eq(blue_player.start_pos)
      expect(blue_player.active_pawns).to eq(1)

      blue_player.activate_pawn("b:3")
      expect(blue_player.pawns[:"b:3"].pos).to eq(blue_player.start_pos)
      expect(blue_player.active_pawns).to eq(2)
    end

    it "can move pawn" do
      blue_player.activate_pawn("b:1")


      blue_player.move_pawn("b:1", 4)
      expect(blue_player.pawns[:"b:1"].pos).to eq([4, 6])
      expect(blue_player.pawns[:"b:1"].path_pos).to eq(4)

      blue_player.move_pawn("b:1", 5)
      expect(blue_player.pawns[:"b:1"].pos).to eq([6, 3])
      expect(blue_player.pawns[:"b:1"].path_pos).to eq(9)
    end

    it "can finish pawns" do
      blue_player.activate_pawn("b:3")
      blue_player.activate_pawn("b:1")
      blue_player.finish_pawn("b:3")

      expect(blue_player.active_pawns).to eq(1)
      expect(blue_player.finished_pawns).to eq(1)
      expect(blue_player.pawns[:"b:3"].pos).to eq([-1,-1])
      expect(blue_player.pawns[:"b:1"].pos).to eq(blue_player.start_pos)

      blue_player.finish_pawn("b:1")

      expect(blue_player.active_pawns).to eq(0)
      expect(blue_player.finished_pawns).to eq(2)
      expect(blue_player.pawns[:"b:1"].pos).to eq([-1,-1])
    end

    it "can get destroy active pawn" do
      blue_player.activate_pawn("b:1")
      blue_player.move_pawn("b:1", 4)
      blue_player.move_pawn("b:1", 5)

      blue_player.destroy_pawn("b:1")
      expect(blue_player.active_pawns).to eq(0)
      expect(blue_player.pawns[:"b:1"].pos).to eq([2, 12])
      expect(blue_player.pawns[:"b:1"].path_pos).to eq(-1)
    end

    it "cannot destroy inactive pawn again" do
      blue_player.destroy_pawn("b:1")
      expect(blue_player.active_pawns).to eq(0)
      expect(blue_player.pawns[:"b:1"].pos).to eq([2, 12])
      expect(blue_player.pawns[:"b:1"].path_pos).to eq(-1)
    end

    it "cannot destroy finished pawn" do
      blue_player.activate_pawn("b:3")
      blue_player.finish_pawn("b:3")

      blue_player.destroy_pawn("b:3")
      expect(blue_player.active_pawns).to eq(0)
      expect(blue_player.finished_pawns).to eq(1)
      expect(blue_player.pawns[:"b:3"].pos).to eq([-1, -1])
      expect(blue_player.pawns[:"b:3"].path_pos).to eq(-1)
    end
  end

  context "yellow colored player " do
    let(:yellow_player) { Player.new("Player", "yellow") }

    it "can determine initial positions for pawns" do
      yellow_player.determine_positions("yellow")

      expect(yellow_player.start_pos).to eq([14, 8])
      expect(yellow_player.initial_pos).to eq([[11,2], [11,3], [12,2], [12,3]])
    end

    it "can set initial name/position on pawns" do
      yellow_pos = [[11,2], [11,3], [12,2], [12,3]]

      expect(yellow_player.pawns[:"y:0"].name).to eq("y:0")
      expect(yellow_player.pawns[:"y:0"].pos).to eq(yellow_pos[0])

      expect(yellow_player.pawns[:"y:1"].name).to eq("y:1")
      expect(yellow_player.pawns[:"y:1"].pos).to eq(yellow_pos[1])
      
      expect(yellow_player.pawns[:"y:2"].name).to eq("y:2")
      expect(yellow_player.pawns[:"y:2"].pos).to eq(yellow_pos[2])
      
      expect(yellow_player.pawns[:"y:3"].name).to eq("y:3")
      expect(yellow_player.pawns[:"y:3"].pos).to eq(yellow_pos[3])
    end

    it "can activate pawn" do
      yellow_player.activate_pawn("y:1")

      expect(yellow_player.pawns[:"y:1"].pos).to eq(yellow_player.start_pos)
      expect(yellow_player.active_pawns).to eq(1)

      yellow_player.activate_pawn("y:3")
      expect(yellow_player.pawns[:"y:3"].pos).to eq(yellow_player.start_pos)
      expect(yellow_player.active_pawns).to eq(2)
    end

    it "can move pawn" do
      yellow_player.activate_pawn("y:1")


      yellow_player.move_pawn("y:1", 4)
      expect(yellow_player.pawns[:"y:1"].pos).to eq([10, 8])
      expect(yellow_player.pawns[:"y:1"].path_pos).to eq(4)

      yellow_player.move_pawn("y:1", 5)
      expect(yellow_player.pawns[:"y:1"].pos).to eq([8, 11])
      expect(yellow_player.pawns[:"y:1"].path_pos).to eq(9)
    end

    it "can finish pawns" do
      yellow_player.activate_pawn("y:3")
      yellow_player.activate_pawn("y:1")
      yellow_player.finish_pawn("y:3")

      expect(yellow_player.active_pawns).to eq(1)
      expect(yellow_player.finished_pawns).to eq(1)
      expect(yellow_player.pawns[:"y:3"].pos).to eq([-1,-1])
      expect(yellow_player.pawns[:"y:1"].pos).to eq(yellow_player.start_pos)

      yellow_player.finish_pawn("y:1")

      expect(yellow_player.active_pawns).to eq(0)
      expect(yellow_player.finished_pawns).to eq(2)
      expect(yellow_player.pawns[:"y:1"].pos).to eq([-1,-1])

    end
  end

  context "green colored player " do
    let(:green_player) { Player.new("Player", "green") }

    it "can determine initial positions for pawns" do
      green_player.determine_positions("green")

      expect(green_player.start_pos).to eq([6, 14])
      expect(green_player.initial_pos).to eq([[11,11], [11,12], [12,11], [12, 12]])
    end


    it "can set initial name/position on pawns"do
      green_pos = [[11,11], [11,12], [12,11], [12, 12]]

      expect(green_player.pawns[:"g:0"].name).to eq("g:0")
      expect(green_player.pawns[:"g:0"].pos).to eq(green_pos[0])

      expect(green_player.pawns[:"g:1"].name).to eq("g:1")
      expect(green_player.pawns[:"g:1"].pos).to eq(green_pos[1])
      
      expect(green_player.pawns[:"g:2"].name).to eq("g:2")
      expect(green_player.pawns[:"g:2"].pos).to eq(green_pos[2])
      
      expect(green_player.pawns[:"g:3"].name).to eq("g:3")
      expect(green_player.pawns[:"g:3"].pos).to eq(green_pos[3])
    end
  end

  context "red colored player " do
    let(:red_player) { Player.new("Player", "red") }

    it "can determine initial positions for pawns" do
      red_player.determine_positions("red")

      expect(red_player.start_pos).to eq([8,0])
      expect(red_player.initial_pos).to eq([[2,2], [2,3], [3,2], [3,3]])
    end

    it "can set initial name/position on pawns" do
      red_pos = [[2,2], [2,3], [3,2], [3,3]]

      expect(red_player.pawns[:"r:0"].name).to eq("r:0")
      expect(red_player.pawns[:"r:0"].pos).to eq(red_pos[0])

      expect(red_player.pawns[:"r:1"].name).to eq("r:1")
      expect(red_player.pawns[:"r:1"].pos).to eq(red_pos[1])
      
      expect(red_player.pawns[:"r:2"].name).to eq("r:2")
      expect(red_player.pawns[:"r:2"].pos).to eq(red_pos[2])
      
      expect(red_player.pawns[:"r:3"].name).to eq("r:3")
      expect(red_player.pawns[:"r:3"].pos).to eq(red_pos[3])

    end
  end

  it "can roll the dice" do
    expect(player.roll_dice).to be_within(3).of(4)
  end
end