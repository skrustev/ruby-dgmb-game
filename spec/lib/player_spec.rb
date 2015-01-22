require 'rspec/its'
require 'player'

describe 'Player' do 
  subject(:player) { Player.new("Player", "color") }

  its(:name) { should eq("Player") }
  its(:color) { should eq("Color") }
  its(:start_pos) { should eq("x:y") }
  its(:activePawns) { should eq(0) }
  its(:finishedPawns) { should eq(0) }
  its(:last_dices) { shuld eq([0, 0])}
  
  it 'can roll the dice' do
    expect(player.roll_dice).to be_within(3).of(4)
  end

end