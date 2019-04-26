class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user.subject_a")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.user.subject_r")
  end
end
