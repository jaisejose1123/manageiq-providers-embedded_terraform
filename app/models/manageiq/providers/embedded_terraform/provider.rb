class ManageIQ::Providers::EmbeddedTerraform::Provider < Provider
  has_one :automation_manager,
          :class_name => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager",
          :autosave   => true

  before_validation :ensure_managers

  private

  def ensure_managers
    build_automation_manager unless automation_manager
    automation_manager.name = _("%{name} Automation Manager") % {:name => name}
    if zone_id_changed?
      automation_manager.enabled = Zone.maintenance_zone&.id != zone_id
      automation_manager.zone_id = zone_id
    end
  end
end
