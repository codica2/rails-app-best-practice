# == Schema Information
#
# Table name: chat_messages
#
#  id              :bigint           not null, primary key
#  messageble_type :string
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_id         :bigint
#  messageble_id   :bigint
#
# Indexes
#
#  index_chat_messages_on_chat_id     (chat_id)
#  index_chat_messages_on_messageble  (messageble_type,messageble_id)
#
class ChatMessageSerializer

  include JSONAPI::Serializer

  attributes :id, :messageble_type, :messageble_id, :sender_full_name, :text, :created_at

  has_many :attachments, serializer: ChatAttachmentSerializer

end
