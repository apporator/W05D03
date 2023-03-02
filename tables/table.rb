class Table

    def self.all
        data = PlayDBConnection.instance.execute("SELECT * FROM #{@@table_name}")
        data.map {|element| Question.new(element)}
    end

end