# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(item)
    raise TypeError, 'can only add Todo objects' unless item.instance_of? Todo
    @todos << item
  end
  alias_method :<<, :add

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def done!
    @todos.each_index do |index|
      mark_done_at(index)
    end
  end

  def item_at(index)
    raise IndexError, 'Index out of range' unless index < @todos.size
    @todos[index]
  end

  def remove_at(index)
    raise IndexError, 'Index out of range' unless index < @todos.size
    @todos.delete_at(index)
  end

  def mark_done_at(index)
    raise IndexError, 'Index out of range' unless index < @todos.size
    @todos[index].done!
  end

  def mark_undone_at(index)
    raise IndexError, 'Index out of range' unless index < @todos.size
    @todos[index].undone!
  end

  def to_s
    text = "---- #{title} ----\n"
    text = @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    @todos
  end

  def each
    @todos.each do |todo|
      yield(todo)
    end
    self
  end

  def select
    new_list = TodoList.new(title)
    each do |todo|
      new_list << todo if yield(todo)
    end
    new_list
  end

  def find_by_title(title)
    each do |todo|
      return todo if title == todo.title
    end
    nil
  end

  def all_done
    new_list = select do |todo|
      todo.done?
    end
    new_list
  end

  def all_not_done
    new_list = select do |todo|
      !todo.done?
    end
    new_list
  end

  # def mark_done(title)
  #   each do |todo|
  #     todo.done! if title == todo.title
  #   end
  # end

  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
    each do |todo|
      todo.done!
    end
  end

  def mark_all_undone
    each do |todo|
      todo.undone!
    end
  end  
end
