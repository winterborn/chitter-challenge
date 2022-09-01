require "peep"
require "peep_repository"

def reset_peeps_table
  seed_sql = File.read("spec/test_seeds/seeds_peeps.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "chitter_test" })
  connection.exec(seed_sql)
end

describe PeepRepository do
  before(:each) { reset_peeps_table }

  context "#all method" do
    it "gets and returns all peeps" do
      repo = PeepRepository.new
      peeps = repo.all
      expect(peeps.length).to eq 2
      expect(peeps.first.id).to eq 1
      expect(peeps.first.message_content).to eq "Eating breakfast!"
      expect(peeps.first.time_created).to eq "2022-09-01 10:00:00"
      expect(peeps.first.user_id).to eq 1
    end
  end

  context "#reverse_chronological_order method" do
    it "gets and returns all peeps in reverse chronological order" do
      repo = PeepRepository.new
      peeps = repo.all
      most_recent_peeps = repo.reverse_chronological_order
      expect(most_recent_peeps.length).to eq 2
      expect(most_recent_peeps.first.time_created).to eq "2022-09-10 06:00:00"
      expect(most_recent_peeps.last.time_created).to eq "2022-09-01 10:00:00"
    end
  end

  context "#find method" do
    it "gets and returns a specific peep given id" do
      repo = PeepRepository.new
      peep = repo.find(1)
      expect(peep.message_content).to eq "Eating breakfast!"
      expect(peep.time_created).to eq "2022-09-01 10:00:00"
      expect(peep.user_id).to eq 1

      peep = repo.find(2)
      expect(peep.message_content).to eq "Going on holiday!"
      expect(peep.time_created).to eq "2022-09-10 06:00:00"
      expect(peep.user_id).to eq 2
    end
  end
end
