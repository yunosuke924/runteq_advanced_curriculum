class Admin::AttachmentsController < ApplicationController
  def destroy
    @site = Site.find(current_site.id)
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_admin_site_path
  end
end
