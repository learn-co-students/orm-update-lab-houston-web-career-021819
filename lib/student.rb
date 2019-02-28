require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade)
    self.name = name
    self.grade = grade
    self.id = nil
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1],row[2])
    new_student.id = row[0]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|student_row| self.new_from_db(student_row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    found = DB[:conn].execute(sql,name)
    Student.new_from_db(found[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    if self.id
      self.update
    else
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].last_insert_row_id
    end
  end

  def self.create (name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    results = DB[:conn].execute(sql,self.name,self.grade,self.id)
  end
end
