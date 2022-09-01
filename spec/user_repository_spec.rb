require "user"
require "user_repository"

def reset_users_table
  seed_sql = File.read("spec/test_seeds/seeds_users.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "chitter_test" })
  connection.exec(seed_sql)
end

describe UserRepository do
  before(:each) { reset_users_table }

  context "#all method" do
    it "gets and returns all users" do
      repo = UserRepository.new
      users = repo.all
      expect(users.length).to eq 2
      expect(users.first.id).to eq 1
      expect(users.first.name).to eq "Phil"
      expect(users.first.email).to eq "phil@gmail.com"
    end

    context "#find method" do
      it "gets and returns a specific user given id" do
        repo = UserRepository.new
        user = repo.find(1)
        expect(user.id).to eq 1
        expect(user.name).to eq "Phil"
        expect(user.email).to eq "phil@gmail.com"

        user = repo.find(2)
        expect(user.id).to eq 2
        expect(user.name).to eq "Kat"
        expect(user.email).to eq "kat@gmail.com"
      end
    end
  end
end
