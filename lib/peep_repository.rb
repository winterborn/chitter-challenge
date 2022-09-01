require_relative "peep"
require_relative "peep_repository"
require "time"

class PeepRepository
  def initialize
    @peeps = []
  end

  def all
    sql = "SELECT id, message_content, time_created, user_id FROM peeps;"
    result_set = DatabaseConnection.exec_params(sql, [])
    # Result set is an array of hashes.

    # Loop through result_set to create a model object for each record hash.
    result_set.each do |record|
      # Create a new model object with the record data.
      peep = Peep.new
      peep.id = record["id"].to_i
      peep.message_content = record["message_content"]
      peep.time_created = (record["time_created"])
      peep.user_id = record["user_id"].to_i

      #   Time.parse(peep.time_created)

      @peeps << peep
    end

    return @peeps
  end

  def reverse_chronological_order
    return(
      @peeps.sort_by { |attribute| Time.parse(attribute.time_created) }.reverse
    )
  end

  def find(id)
    sql =
      "SELECT id, message_content, time_created, user_id FROM peeps WHERE id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [id])

    peep = Peep.new
    peep.id = result_set[0]["id"].to_i
    peep.message_content = result_set[0]["message_content"]
    peep.time_created = (result_set[0]["time_created"])
    peep.user_id = result_set[0]["user_id"].to_i

    return peep
  end
end
