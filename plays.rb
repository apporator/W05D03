require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already in database" if self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id, self.id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end

  # def self.find_by_title(title)
  #   PlayDBConnection.instance.execute(<<-SQL, title)
  #     select * from plays where title = ?
  #   SQL
  #   )
  # end

  # def self.find_by_playwright(name)
  #   PlayDBConnection.instance.execute(<<-SQL, name)
  #     select
  #     from plays as p
  #     join playwrights as pw on pw.id = p.playwright_id
  #     where pw.name = ?
  #   SQL
  #   )
  # end
end

class Playwright

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM playwrights")
    data.map {|datum| Play.new(datum)}
  end

  def initialize(options)
    @name = options['name']
    @birth_year = options['birth_year']
    @id = options['id']
  end

  def self.find_by_name(name)
    PlayDBConnection.instance.execute(<<-SQL, name)
      select * from playwrights as p where p.name = ?
    SQL
  end

  def update
    raise "not in db yet" if self.id.nil?

    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year, self.id)
      UPDATE
        playwrights
      SET
        name = ?, birth_year = ?
      WHERE
        id = ?
    SQL
  end

  def create
    raise "already in db" if self.id

    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year)
    INSERT INTO
      playwrights (name, birth_year)
    VALUES
      (??)
    SQL
  end 

  def get_plays()
    raise "playrwight not in db" if self.id.nil?
    PlayDBConnection.instance.execute(<<-SQL, self.id)
    SELECT * from plays
    WHERE playwright_id = ?
    SQL
  end

  attr_accessor :birth_year, :name

  private

  attr_reader :id
end


