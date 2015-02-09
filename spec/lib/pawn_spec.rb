require 'rspec/its'
require 'pawn'

describe 'Pawn' do
  subject(:pawn) { Pawn.new("name", "player", [7,6]) }


  its(:name) { should eq("name")}
  its(:player_name) { should eq("player") }
  its(:pos) { should eq([7,6])}
  its(:path_pos) { should eq(-1) }
  its(:initial_pos) {should eq([7,6]) }
  its(:is_active) { should eq(false) }
  its(:is_finished) { should eq(false) }
  its(:can_be_moved) { should eq(false) }

  it "can be activated " do
    pawn.activate([1,3])

    expect(pawn.pos).to eq([1,3])
    expect(pawn.path_pos).to eq(0)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be moved" do
    pawn.activate([0,4])
    pawn.move(5, [4,3])
    
    expect(pawn.pos).to eq([4,3])
    expect(pawn.path_pos).to eq(5)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(true)
    expect(pawn.is_finished).to eq(false)
    expect(pawn.can_be_moved).to eq(true)
  end

  it "can be destroyed" do
    pawn.activate([0,4])
    pawn.move(4, [4,4])
    pawn.destroy
    
    expect(pawn.pos).to eq(pawn.initial_pos)
    expect(pawn.path_pos).to eq(-1)
    expect(pawn.is_active).to eq(false)
    expect(pawn.can_be_moved).to eq(false)
  end

  it "can finish" do
    pawn.activate([0,5])
    pawn.move(1, [1, 5])
    pawn.destroy
    pawn.finish

    expect(pawn.pos).to eq([-1, -1])
    expect(pawn.path_pos).to eq(-1)
    expect(pawn.player_name).to eq("player")
    expect(pawn.initial_pos).to eq([7,6])
    expect(pawn.is_active).to eq(false)
    expect(pawn.is_finished).to eq(true)
    expect(pawn.can_be_moved).to eq(false)
  end

  context "can compare" do
    subject(:pawn1) { Pawn.new("b:1", "player2", [2,6]) }
    subject(:pawn2) { Pawn.new("b:1", "player2", [2,6]) }
    subject(:pawn3) { Pawn.new("b:2", "player2", [4,6]) }

    it "similar pawns" do
      expect(pawn1 == pawn2).to eq(true)
    end

    it "different pawns" do
      expect(pawn1 == pawn3).to eq(false)
      expect(pawn2 == pawn3).to eq(false)
    end
  end

  context "can be reset " do
    subject(:pawn4) { Pawn.new("b:1", "player2", [2,6]) }

    it "when active" do
      pawn4.activate([1,3])
      pawn4.move(5, [4,3])
      pawn4.reset

      expect(pawn4.pos).to eq(pawn4.initial_pos)
      expect(pawn4.path_pos).to eq(-1)
      expect(pawn4.player_name).to eq("player2")
      expect(pawn4.initial_pos).to eq([2,6])
      expect(pawn4.is_active).to eq(false)
      expect(pawn4.is_finished).to eq(false)
      expect(pawn4.can_be_moved).to eq(false)
    end

    it "when finished" do
      pawn4.activate([0,5])
      pawn4.move(1, [1, 5])
      pawn4.destroy
      pawn4.finish
      pawn4.reset

      expect(pawn4.pos).to eq(pawn4.initial_pos)
      expect(pawn4.path_pos).to eq(-1)
      expect(pawn4.player_name).to eq("player2")
      expect(pawn4.initial_pos).to eq([2,6])
      expect(pawn4.is_active).to eq(false)
      expect(pawn4.is_finished).to eq(false)
      expect(pawn4.can_be_moved).to eq(false)
    end
  end
end