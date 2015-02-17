class Complaint < ActiveRecord::Base
  
  has_many :taggings
  has_many :tags, through: :taggings

  validates :subject,:matter,:key_words, presence: true

  acts_as_taggable

  scope :with_tag_ids, lambda{ |tag_ids|
  # get a reference to the join table
  #role_assignments = Tagging.arel_table
  # get a reference to the filtered table
  #complaints = Complaint.arel_table
  # let AREL generate a complex SQL query
  #byebug
  #where(
    #Tagging \
      #.where(role_assignments[:taggable_id].eq(complaints[:id])) \
      #.where(role_assignments[:tag_id].in([*tag_ids].map(&:to_i))) \
      #.exists
  #)
    num_or_conds = 2
    item = tag_ids.downcase.split(/,/)
    item = item.map{|val| val.strip}
    #Tag.where(item.map{|tagid| "(name like ?)%"+tagid+"%"})
  #Tag.where(item.map{|tagid| "(name like ?)"}.join(' OR '),item.map{|e| '%'+e+'%'}.flatten)
    tag = Tag.where(item.map{|tagid| "(name like ?)"}.join(' OR '),*item.map{|e| '%'+e+'%'}.flatten)
    tagging = Tagging.where(tag_id: tag.map{|t|  t.id}).pluck(:taggable_id)
    where(id: tagging)
  }

  scope :search_query, lambda { |subject|
    return nil  if subject.blank?
    terms = subject.downcase.split(/\s+/)
    terms = terms.map { |e| '%'+e+'%'}
    num_or_conds = 2
    where(terms.map { |term| "(LOWER(complaints.subject) LIKE ? OR LOWER(complaints.subject) LIKE ?)" }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten)
  }

  scope :with_key_words, lambda { |key_words|
    where(key_words: [*key_words])
  }

  filterrific(
    # default_settings: { sorted_by: 'created_at_desc' },
    filter_names: [
      :search_query,
      :with_key_words,
      :with_tag_ids
    ]
  )
  
end
