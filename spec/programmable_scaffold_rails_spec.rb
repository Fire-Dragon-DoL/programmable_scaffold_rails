require 'spec_helper'

require 'programmable_scaffold_rails/config'

describe ProgrammableScaffoldRails do

  it { described_class::BASE_OPTIONS.should_not be_nil        }
  it { described_class::BASE_OPTIONS.should have_key(:cancan) }
  it { described_class::BASE_OPTIONS[:cancan].should be_true  }

  it { described_class::CRUD_METHODS.should_not be_nil        }
  it { described_class::CRUD_METHODS.should include(:new)     }
  it { described_class::CRUD_METHODS.should include(:create)  }
  it { described_class::CRUD_METHODS.should include(:index)   }
  it { described_class::CRUD_METHODS.should include(:show)    }
  it { described_class::CRUD_METHODS.should include(:edit)    }
  it { described_class::CRUD_METHODS.should include(:update)  }
  it { described_class::CRUD_METHODS.should include(:destroy) }

end