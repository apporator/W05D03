require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM users")
        data.map {|element| User.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM users
            WHERE id = ?
        SQL

        User.new(data.first)
    end

    def self.find_by_name(fname, lname)
        data = PlayDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
            *
            FROM users
            WHERE fname = ?
            AND lname = ?
        SQL

        User.new(data.first)
    end
end