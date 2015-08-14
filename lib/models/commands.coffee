class Commands
  @all = {
    LDA: {
      arity: 1, errors: {
        wrongArity: 'LDA must be given a location to load from.'
      }
    },

    LDC: {
      arity: 1, errors: {
        wrongArity: 'LDC must be given a constant value to load.'
      }
    },

    STA: {
      arity: 1, errors: {
        wrongArity: 'STA must be given a location to store the ' +
          'accumulator value in.'
      }
    },

    INP: {
      arity: 1, errors: {
        wrongArity: 'INP must be given a location to store the ' +
          'user inputted value.'
      }
    },

    OUT: {
      arity: 1, errors: {
        wrongArity: 'OUT must be given the location of the value ' +
          'to print.'
      }
    },

    ADC: {
      arity: 1, errors: {
        wrongArity: 'ADC must be given a constant value to add to ' +
          'the accumulator.'
      }
    },

    ADD: {
      arity: 1, errors: {
        wrongArity: 'ADD must be given the location of the value ' +
          'to add to the accumulator.'
      }
    },

    SUB: {
      arity: 1, errors: {
        wrongArity: 'SUB must be given the location of the value ' +
          'to subtract from the accumulator.'
      }
    },

    MUL: {
      arity: 1, errors: {
        wrongArity: 'MUL must be given the location of the value to '+
          'subtract from the accumulator.'
      }
    },

    DIV: {
      arity: 1, errors: {
        wrongArity: 'DIV must be given the location of the value to ' +
          'subtract from the accumulator.'
      }
    },

    BRU: {
      arity: 1, errors: {
        wrongArity: 'BRU must be given the location to branch to.'
      }
    },

    BNA: {
      arity: 1, errors: {
        wrongArity: 'BNA must be given the location to branch to.'
      }
    },

    BPA: {
      arity: 1, errors: {
        wrongArity: 'BPA must be given the location to branch to.'
      }
    },

    BZA: {
      arity: 1, errors: {
        wrongArity: 'BZA must be given the location to branch to.'
      }
    },

    STP: {
      arity: 0, errors: {
        wrongArity: 'STP does not accept any arguments.'
      }
    }
  }

  @get = (name) ->
    @all[name]
