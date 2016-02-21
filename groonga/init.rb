require_relative '../config/environment'

Groonga::Schema.define do |schema|
  schema.create_table('Sites',
                      type: :hash,
                      key_type: :uint32) do |table|
    table.short_text 'name'
  end

  schema.create_table('Categories',
                      type: :hash,
                      key_type: :uint32) do |table|
    table.short_text 'name'
  end

  schema.create_table('Participants',
                      type: :hash,
                      key_type: :uint32) do |table|
    table.short_text 'name'
  end

  schema.create_table('Posts',
                      type: :hash,
                      key_type: :uint32) do |table|
    table.short_text 'title'
    table.text 'content'
    table.time 'published_at'
    table.reference 'site', 'Sites'
    table.reference 'category', 'Categories'
    table.reference 'participants', 'Participants', type: :vector
    table.uint32 'public_id'
  end
end

if Post.table_exists?
  indexer = PostIndexer.new
  Post.includes(:category, credits: [:participant]).find_each do |post|
    indexer.add(post)
  end
end

Groonga::Schema.define do |schema|
  schema.create_table('Words',
                      type: :patricia_trie,
                      key_type: :short_text,
                      normalizer: 'NormalizerAuto',
                      default_tokenizer: 'TokenMecab') do |table|
    table.index 'Posts.title'
    table.index 'Posts.content'
  end

  schema.create_table('Terms',
                      type: :patricia_trie,
                      key_type: :short_text,
                      normalizer: 'NormalizerAuto',
                      default_tokenizer: 'TokenBigram') do |table|
    table.index 'Posts.title'
    table.index 'Posts.content'
  end

  schema.create_table('Times',
                      type: :patricia_trie,
                      key_type: :time) do |table|
    table.index 'Posts.published_at'
  end
end
