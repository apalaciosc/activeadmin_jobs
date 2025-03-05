module AdminHelpers
  def self.jobs_url
    url = ["/"]

    if ActiveAdmin.application.default_namespace.present?
      url << "#{ActiveAdmin.application.default_namespace}/"
    end

    url << "jobs"
    url.join("")
  end
end

ActiveAdmin.application.load_paths += [File.join(ActiveadminJobs::Engine.root, "app", "admin")]

class ActiveAdmin::Views::Pages::Base
  alias_method :adj_build, :build

  def build(*args)
    adj_build(*args)
    current_user_method = ActiveAdmin.application.current_user_method

    if current_user_method && @body.present?
      admins_job_identifier = send(current_user_method)&.job_identifier
      @body.set_attribute("data-identifier", admins_job_identifier) if admins_job_identifier
      @body.set_attribute("data-root-url", "/")
      @body.set_attribute("data-jobs-url", AdminHelpers.jobs_url)
      @body.set_attribute("data-translations", I18nDictionary.translations.to_json)
    end
  end
end
