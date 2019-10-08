require 'test_helper'

class InviteMailerTest < ActionMailer::TestCase
  test "send_invitation" do
    mail = InviteMailer.send_invitation
    assert_equal "Send invitation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
