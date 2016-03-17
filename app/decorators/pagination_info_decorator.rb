module PaginationInfoDecorator
  def page_entries_info(target = self)
    if target.total_pages > 1
      first = target.offset_value + 1
      last  = target.last_page? ? target.total_count : target.offset_value + target.limit_value

      "#{first}〜#{last}/#{target.total_count}件"
    else
      "#{target.total_count}件"
    end
  end
end
