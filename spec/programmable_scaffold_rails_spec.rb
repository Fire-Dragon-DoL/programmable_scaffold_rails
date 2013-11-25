require 'spec_helper'

require 'programmable_scaffold_rails/config'

describe ProgrammableScaffoldRails do

  subject(:base_options) { described_class::BASE_OPTIONS }
    specify { base_options.should_not be_nil                                }
    specify { base_options.should have_key(:cancan)                         }
    specify { base_options.should have_key(:friendly_id)                    }
    specify { base_options.should have_key(:strong_params)                  }
    specify { base_options.should have_key(:formats)                        }
    specify { base_options.should have_key(:after_create_action)            }
    specify { base_options.should have_key(:after_update_action)            }
    specify { base_options.should have_key(:after_create_url)               }
    specify { base_options.should have_key(:after_update_url)               }
    specify { base_options.should have_key(:after_destroy_url)              }
    specify { base_options[:cancan].should be_true                          }
    specify { base_options[:friendly_id].should be_false                    }
    specify { base_options[:strong_params].should be_an_instance_of(Symbol) }
    specify { base_options[:formats].should match_array([:html, :json])     }
    specify { base_options[:after_create_action].should be :show            }
    specify { base_options[:after_update_action].should be :show            }
    specify { base_options[:after_create_url].should be_nil                 }
    specify { base_options[:after_update_url].should be_nil                 }
    specify { base_options[:after_destroy_url].should be_nil                }

  subject(:crud_methods) { described_class::CRUD_METHODS }
    specify { crud_methods.should_not be_nil        }
    specify { crud_methods.should include(:new)     }
    specify { crud_methods.should include(:create)  }
    specify { crud_methods.should include(:index)   }
    specify { crud_methods.should include(:show)    }
    specify { crud_methods.should include(:edit)    }
    specify { crud_methods.should include(:update)  }
    specify { crud_methods.should include(:destroy) }

end