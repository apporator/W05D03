require 'sqlite3'
require 'singleton'
require 'byebug'
require_relative 'questions.rb'
require_relative 'reply.rb'
require_relative 'user.rb'
require_relative 'question_follow.rb'

class PlayDBConnection < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end