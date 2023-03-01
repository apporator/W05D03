require 'sqlite3'
require 'singleton'
require 'byebug'

# module TableHelper
#     def self.result?(data)
#         if data.empty?
#             puts "No entry found."
#             return false
#         else
#             return true
#         end
#     end
# end

class PlayDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    # @@table_name = 'users'
    # include TableHelper

    attr_accessor :id, :fname, :lname, :table_name

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
        # debugger

        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM users
            WHERE id = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.find_by_name(fname, lname)
        data = PlayDBConnection.instance.execute(<<-SQL, fname, lname)
            SELECT
            *
            FROM users
            WHERE fname = ?
            AND lname = ?
        SQL

        User.new(data.first) if result?(data)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end
end

class Question
    # include TableHelper

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM questions")
        data.map {|element| Question.new(element)}
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def self.find_by_id(id)
        data = PlayDBConnection.instance.execute(<<-SQL, id)
            SELECT
            *
            FROM questions
            WHERE id = ?
        SQL

        Question.new(data.first) if result?(data)
    end

    def self.result?(data)
        if data.empty?
            puts "No entry found."
            return false
        else
            return true
        end
    end
end
