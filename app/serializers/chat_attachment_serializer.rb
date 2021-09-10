# == Schema Information
#
# Table name: chat_attachments
#
#  id              :bigint           not null, primary key
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chat_message_id :bigint
#
# Indexes
#
#  index_chat_attachments_on_chat_message_id  (chat_message_id)
#
class ChatAttachmentSerializer

  include JSONAPI::Serializer

  attributes :id

  attribute :url, &:attachment_url

  attribute :type do |obj|
    obj.attachment.mime_type
  end

  attribute :name do |obj|
    obj.attachment['filename']
  end

end
