class PostCategoryValidator < ActiveModel::Validator
  def validate(record)
    if record.category.has_children?
      record.errors[:category_id] << "子カテゴリを持つカテゴリ「#{record.category.full_name}」に記事を登録することはできません。"
    end
  end
end
