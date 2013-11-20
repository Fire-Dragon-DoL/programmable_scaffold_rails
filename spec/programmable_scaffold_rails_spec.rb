require 'spec_helper'

require 'programmable_scaffold_rails/config'

describe ProgrammableScaffoldRails do
  subject(:base_options) { described_class::BASE_OPTIONS }

  it { base_options.should_not be_nil                                }
  it { base_options.should have_key(:cancan)                         }
  it { base_options.should have_key(:friendly_id)                    }
  it { base_options.should have_key(:strong_params)                  }
  it { base_options[:cancan].should be_true                          }
  it { base_options[:friendly_id].should be_false                    }
  it { base_options[:strong_params].should be_an_instance_of(Symbol) }

  it { described_class::CRUD_METHODS.should_not be_nil        }
  it { described_class::CRUD_METHODS.should include(:new)     }
  it { described_class::CRUD_METHODS.should include(:create)  }
  it { described_class::CRUD_METHODS.should include(:index)   }
  it { described_class::CRUD_METHODS.should include(:show)    }
  it { described_class::CRUD_METHODS.should include(:edit)    }
  it { described_class::CRUD_METHODS.should include(:update)  }
  it { described_class::CRUD_METHODS.should include(:destroy) }

end