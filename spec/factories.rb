FactoryGirl.define do
  factory :tag, class: Tag do
    name "This is a tag"
  end

  factory :note, class: Note do
    title "first"
    content "This is a note"
  end
end
