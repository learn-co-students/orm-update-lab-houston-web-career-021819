require_relative "../config/environment.rb"
require 'pry'
class Student

  attr_accessor :name, :grade
  attr_reader :id
  def initialize(name, grade, id = nil)
    @id = id
    self.name = name
    self.grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"

    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name,grade) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      new_id = DB[:conn].last_insert_row_id

      @id = new_id
    end
  end

  def self.create(name, grade, id = nil)
    new_student = Student.new(name, grade, id)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    Student.create(row[1],row[2],row[0])
  end 

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    result_row = DB[:conn].execute(sql, name)[0]
    
    found_student = Student.new_from_db(result_row)
  end
end
