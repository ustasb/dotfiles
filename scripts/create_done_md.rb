require 'json'
require 'time'

# task format: `<task description> { <optional update 1> | <optional update 2> }`
TASK_ITEM_REGEX =/^ (.*?) ({(.*)})? \s* $/x

Task = Struct.new(:task, :timestamp)
TimeState = Struct.new(:year, :month, :week, :day)

$done_log = File.open(ENV['USTASB_DOCS_DIR_PATH'] + '/ustasb/done.log', 'r')
$done_md = File.open(ENV['USTASB_DOCS_DIR_PATH'] + '/ustasb/done.md', 'w')

def print_header(txt, level:)
  $done_md.puts("\n#{'#' * level} #{txt}")
end

def print_task(task)
  match = TASK_ITEM_REGEX.match(task.task.strip)

  $done_md.puts("- #{match[1]}")

  if (updates = match[3])
    updates = updates.split('|')
    updates.each { |u| $done_md.puts("    - #{u.strip}") }
  end
end

# Sort tasks in reverse chronological order.
tasks = $done_log.each_line.map do |l|
  task = JSON.parse(l)
  task['timestamp'] = Time.parse(task['timestamp'])
  Task.new(*task.values)
end.sort_by do |t|
  [-t.timestamp.to_i, t.task]
end

state = TimeState.new

$done_md.puts("% Brian's Done Log")
$done_md.puts("\n**THIS FILE IS AUTOMATICALLY GENERATED. DON'T EDIT IT!**\n")

tasks.each do |task|
  if state.year != task.timestamp.year
    state.year = task.timestamp.year
    print_header(state.year, level: 1)
  end

  if state.month != task.timestamp.month
    state.month = task.timestamp.month
    header = "#{task.timestamp.strftime('%B')} (#{state.month}/12)"
    print_header(header, level: 2)
  end

  if state.week != task.timestamp.strftime('%U')
    state.week = task.timestamp.strftime('%U')
    header = "Week #{state.week} (#{state.week}/52)"
    print_header(header, level: 3)
  end

  if state.day != task.timestamp.day
    state.day = task.timestamp.day
    days_in_month = Date.new(state.year, state.month, -1).day
    header = task.timestamp.strftime("%A - %D (#{state.day}/#{days_in_month})\n\n")
    print_header(header, level: 4)
  end

  print_task(task)
end
