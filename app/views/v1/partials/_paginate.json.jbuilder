# frozen_string_literal: true

json.metadata do
  json.total_count records.total_count
  json.count records.count
  json.current_page records.current_page
  json.total_pages records.total_pages
  json.next_page  records.next_page
  json.prev_page  records.prev_page
end
