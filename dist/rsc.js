(function() {
  var AccumulatorView, AddressOutOfBoundsError, Button, Command, CommandList, CommandListItemView, CommandListView, Commands, ContainerView, ControlsView, Events, Instruction, Interpreter, KeyboardView, Memory, MonitorView, NotExecutableError, NotStorableError, PeripheralsView, Rsc, Session, SteppingInterpreter, StorageLocation, TestRunner, Utils, root,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  NotExecutableError = (function(superClass) {
    extend(NotExecutableError, superClass);

    function NotExecutableError(message) {
      this.name = 'NotExecutableError';
      this.message = message;
      this.stack = (new Error()).stack;
    }

    return NotExecutableError;

  })(Error);

  NotStorableError = (function(superClass) {
    extend(NotStorableError, superClass);

    function NotStorableError(message) {
      this.name = 'NotStorableError';
      this.message = message;
      this.stack = (new Error()).stack;
    }

    return NotStorableError;

  })(Error);

  AddressOutOfBoundsError = (function(superClass) {
    extend(AddressOutOfBoundsError, superClass);

    function AddressOutOfBoundsError(message) {
      this.name = 'AddressOutOfBoundsError';
      this.message = message;
      this.stack = (new Error()).stack;
    }

    return AddressOutOfBoundsError;

  })(Error);

  Instruction = (function() {
    Instruction.fromCommand = function(command) {
      return new Instructions[command.command](command);
    };

    function Instruction(command1) {
      this.command = command1;
    }

    Instruction.prototype.isExecutable = function() {
      return true;
    };

    Instruction.prototype.getLocation = function(memory) {
      var address, location;
      address = this.command.arg1 - 1;
      if (address >= memory.values.length) {
        throw new AddressOutOfBoundsError("Attempted to access memory address " + (this.command.arg1 + ", which doesn't exist."));
      } else {
        location = memory.getStorageLocationAtIndex(address);
        if (location) {
          return location;
        } else {
          throw new NotStorableError(("Attempted to write a value to location " + this.command.arg1 + ", ") + "which already contains an instruction.");
        }
      }
    };

    return Instruction;

  })();

  var Instructions = {};

  Instructions.LDA = (function(superClass) {
    extend(LDA, superClass);

    function LDA() {
      return LDA.__super__.constructor.apply(this, arguments);
    }

    LDA.prototype.execute = function(session, memory, peripherals) {
      debugger;
      session.accumulator = this.getLocation(memory).value;
      return session.incrementProgramCounter();
    };

    return LDA;

  })(Instruction);

  Instructions.LDC = (function(superClass) {
    extend(LDC, superClass);

    function LDC() {
      return LDC.__super__.constructor.apply(this, arguments);
    }

    LDC.prototype.execute = function(session, memory, peripherals) {
      session.accumulator = this.command.arg1;
      return session.incrementProgramCounter();
    };

    return LDC;

  })(Instruction);

  Instructions.STA = (function(superClass) {
    extend(STA, superClass);

    function STA() {
      return STA.__super__.constructor.apply(this, arguments);
    }

    STA.prototype.execute = function(session, memory, peripherals) {
      this.getLocation(memory).value = session.accumulator;
      return session.incrementProgramCounter();
    };

    return STA;

  })(Instruction);

  Instructions.INP = (function(superClass) {
    extend(INP, superClass);

    function INP() {
      return INP.__super__.constructor.apply(this, arguments);
    }

    INP.prototype.execute = function(session, memory, peripherals) {
      session.waitingForInput = true;
      return session["continue"] = false;
    };

    INP.prototype.resumeWithInput = function(input, session, memory, peripherals) {
      this.getLocation(memory).value = input;
      session.waitingForInput = false;
      session["continue"] = true;
      return session.incrementProgramCounter();
    };

    return INP;

  })(Instruction);

  Instructions.OUT = (function(superClass) {
    extend(OUT, superClass);

    function OUT() {
      return OUT.__super__.constructor.apply(this, arguments);
    }

    OUT.prototype.execute = function(session, memory, peripherals) {
      peripherals.monitor.displayValue(this.getLocation(memory).value);
      return session.incrementProgramCounter();
    };

    return OUT;

  })(Instruction);

  Instructions.ADC = (function(superClass) {
    extend(ADC, superClass);

    function ADC() {
      return ADC.__super__.constructor.apply(this, arguments);
    }

    ADC.prototype.execute = function(session, memory, peripherals) {
      session.accumulator += this.command.arg1;
      return session.incrementProgramCounter();
    };

    return ADC;

  })(Instruction);

  Instructions.ADD = (function(superClass) {
    extend(ADD, superClass);

    function ADD() {
      return ADD.__super__.constructor.apply(this, arguments);
    }

    ADD.prototype.execute = function(session, memory, peripherals) {
      session.accumulator += this.getLocation(memory).value;
      return session.incrementProgramCounter();
    };

    return ADD;

  })(Instruction);

  Instructions.SUB = (function(superClass) {
    extend(SUB, superClass);

    function SUB() {
      return SUB.__super__.constructor.apply(this, arguments);
    }

    SUB.prototype.execute = function(session, memory, peripherals) {
      session.accumulator -= this.getLocation(memory).value;
      return session.incrementProgramCounter();
    };

    return SUB;

  })(Instruction);

  Instructions.MUL = (function(superClass) {
    extend(MUL, superClass);

    function MUL() {
      return MUL.__super__.constructor.apply(this, arguments);
    }

    MUL.prototype.execute = function(session, memory, peripherals) {
      session.accumulator *= this.getLocation(memory).value;
      return session.incrementProgramCounter();
    };

    return MUL;

  })(Instruction);

  Instructions.DIV = (function(superClass) {
    extend(DIV, superClass);

    function DIV() {
      return DIV.__super__.constructor.apply(this, arguments);
    }

    DIV.prototype.execute = function(session, memory, peripherals) {
      session.accumulator /= this.getLocation(memory).value;
      return session.incrementProgramCounter();
    };

    return DIV;

  })(Instruction);

  Instructions.BRU = (function(superClass) {
    extend(BRU, superClass);

    function BRU() {
      return BRU.__super__.constructor.apply(this, arguments);
    }

    BRU.prototype.execute = function(session, memory, peripherals) {
      return session.programCounter = this.command.arg1 - 1;
    };

    return BRU;

  })(Instruction);

  Instructions.BPA = (function(superClass) {
    extend(BPA, superClass);

    function BPA() {
      return BPA.__super__.constructor.apply(this, arguments);
    }

    BPA.prototype.execute = function(session, memory, peripherals) {
      if (session.accumulator > 0) {
        return session.programCounter = this.command.arg1 - 1;
      } else {
        return session.incrementProgramCounter();
      }
    };

    return BPA;

  })(Instruction);

  Instructions.BNA = (function(superClass) {
    extend(BNA, superClass);

    function BNA() {
      return BNA.__super__.constructor.apply(this, arguments);
    }

    BNA.prototype.execute = function(session, memory, peripherals) {
      if (session.accumulator < 0) {
        return session.programCounter = this.command.arg1 - 1;
      } else {
        return session.incrementProgramCounter();
      }
    };

    return BNA;

  })(Instruction);

  Instructions.BZA = (function(superClass) {
    extend(BZA, superClass);

    function BZA() {
      return BZA.__super__.constructor.apply(this, arguments);
    }

    BZA.prototype.execute = function(session, memory, peripherals) {
      if (session.accumulator === 0) {
        return session.programCounter = this.command.arg1 - 1;
      } else {
        return session.incrementProgramCounter();
      }
    };

    return BZA;

  })(Instruction);

  Instructions.STP = (function(superClass) {
    extend(STP, superClass);

    function STP() {
      return STP.__super__.constructor.apply(this, arguments);
    }

    STP.prototype.execute = function(session, memory, peripherals) {
      session["continue"] = false;
      session.stopped = true;
      return session.incrementProgramCounter();
    };

    return STP;

  })(Instruction);

  Interpreter = (function() {
    function Interpreter(commands1, peripherals1, session1) {
      this.commands = commands1;
      this.peripherals = peripherals1;
      this.session = session1;
      this.memory = this.buildMemory(this.commands);
      this.peripherals.keyboard.onInputReceived((function(_this) {
        return function(input) {
          var currentInstruction, e;
          if (_this.session.isWaitingForInput()) {
            try {
              currentInstruction = _this.getCurrentInstruction();
              currentInstruction.resumeWithInput(input, _this.session, _this.memory, _this.peripherals);
              return Events.fireIfDefined(_this, 'onProgramStepCallback');
            } catch (_error) {
              e = _error;
              return Events.fireIfDefined(_this, 'onErrorCallback', e);
            }
          }
        };
      })(this));
    }

    Interpreter.prototype.onProgramStep = function(callback) {
      return this.onProgramStepCallback = callback;
    };

    Interpreter.prototype.onProgramStop = function(callback) {
      return this.onProgramStopCallback = callback;
    };

    Interpreter.prototype.onError = function(callback) {
      return this.onErrorCallback = callback;
    };

    Interpreter.prototype.getCurrentInstruction = function() {
      var instruction;
      instruction = this.memory.getInstructionAtIndex(this.session.programCounter);
      if (instruction == null) {
        throw new NotExecutableError(("The instruction on line " + (this.session.programCounter + 1) + " ") + "is not executable.");
      }
      return instruction;
    };

    Interpreter.prototype.buildMemory = function(commands) {
      var command, list;
      list = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = commands.length; j < len; j++) {
          command = commands[j];
          if (command != null) {
            results.push(Instruction.fromCommand(command));
          } else {
            results.push(new StorageLocation());
          }
        }
        return results;
      })();
      return new Memory(list);
    };

    return Interpreter;

  })();

  Memory = (function() {
    function Memory(values) {
      this.values = values;
    }

    Memory.prototype.getInstructionAtIndex = function(index) {
      var instruction;
      instruction = this.values[index];
      if ((instruction != null) && instruction.isExecutable()) {
        return instruction;
      } else {
        return null;
      }
    };

    Memory.prototype.getStorageLocationAtIndex = function(index) {
      var location;
      location = this.values[index];
      if ((location != null) && !location.isExecutable()) {
        return location;
      } else {
        return null;
      }
    };

    Memory.prototype.eachStorageLocation = function(callback) {
      var i, j, location, ref, results;
      results = [];
      for (i = j = 0, ref = this.values.length; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        location = this.getStorageLocationAtIndex(i);
        if (location != null) {
          results.push(callback(i, location));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    return Memory;

  })();

  Session = (function() {
    function Session() {
      this.accumulator = (Math.round(Math.random() * Math.pow(10, 6)) / 100) * (Math.random() > 0.5 ? -1 : 1);
      this.reset();
    }

    Session.prototype.reset = function() {
      this.programCounter = 0;
      this["continue"] = true;
      this.waitingForInput = false;
      return this.stopped = false;
    };

    Session.prototype.incrementProgramCounter = function() {
      return this.programCounter += 1;
    };

    Session.prototype.shouldContinue = function() {
      return this["continue"] && !this.stopped;
    };

    Session.prototype.isWaitingForInput = function() {
      return this.waitingForInput;
    };

    Session.prototype.hasStopped = function() {
      return this.stopped;
    };

    return Session;

  })();

  SteppingInterpreter = (function(superClass) {
    extend(SteppingInterpreter, superClass);

    function SteppingInterpreter() {
      return SteppingInterpreter.__super__.constructor.apply(this, arguments);
    }

    SteppingInterpreter.prototype.start = function() {};

    SteppingInterpreter.prototype.resume = function() {
      var e;
      try {
        if (this.session.shouldContinue()) {
          this.getCurrentInstruction().execute(this.session, this.memory, this.peripherals);
          Events.fireIfDefined(this, 'onProgramStepCallback');
        }
        if (this.session.hasStopped()) {
          return Events.fireIfDefined(this, 'onProgramStopCallback');
        }
      } catch (_error) {
        e = _error;
        return Events.fireIfDefined(this, 'onErrorCallback', e);
      }
    };

    SteppingInterpreter.prototype.requiresManualStepping = function() {
      return true;
    };

    return SteppingInterpreter;

  })(Interpreter);

  StorageLocation = (function() {
    function StorageLocation(value1) {
      this.value = value1 != null ? value1 : null;
    }

    StorageLocation.prototype.isExecutable = function() {
      return false;
    };

    return StorageLocation;

  })();

  Rsc = (function() {
    Rsc.defaultNumColumns = 3;

    Rsc.defaultNumRows = 15;

    function Rsc(selector, options) {
      if (options == null) {
        options = {};
      }
      this.container = new ContainerView(options);
      $(selector).replaceWith(this.container.elem);
      this.session = new Session();
      this.refreshAccumulator();
      this.container.controls.onRunProgramButtonClicked((function(_this) {
        return function() {
          var interpreter;
          if (_this.container.commandList.getErrors().length > 0) {
            alert('Your program contains one or more syntax errors. ' + 'Please fix them before running.');
            return;
          }
          _this.session.reset();
          _this.container.controls.runProgramButton.disable();
          _this.container.controls.clearMemButton.disable();
          _this.container.controls.stopButton.enable();
          _this.container.commandList.disable();
          interpreter = new SteppingInterpreter(_this.container.commandList.getCommands(), _this.container.peripherals, _this.session);
          interpreter.onProgramStep(function() {
            return _this.refreshInterface(interpreter);
          });
          interpreter.onProgramStop(function() {
            return _this.resetInterface();
          });
          _this.container.controls.onStepButtonClicked(function() {
            if (_this.session.isWaitingForInput()) {
              return alert('Waiting for input...');
            } else if (_this.session.shouldContinue()) {
              return interpreter.resume();
            }
          });
          _this.container.controls.onStopButtonClicked(function() {
            return _this.resetInterface();
          });
          interpreter.onError(function(e) {
            return _this.handleError(e);
          });
          _this.refreshInterface(interpreter);
          if (interpreter.requiresManualStepping()) {
            _this.container.controls.stepButton.enable();
          }
          return interpreter.start();
        };
      })(this));
      this.container.controls.onClearMemButtonClicked((function(_this) {
        return function() {
          if (confirm('Are you sure you want to clear the memory? Your program will be erased.')) {
            return _this.container.commandList.clear();
          }
        };
      })(this));
    }

    Rsc.prototype.refreshInterface = function(interpreter) {
      this.refreshExecutionLine();
      this.refreshAccumulator();
      this.refreshMemoryUI(interpreter);
      if (this.session.isWaitingForInput()) {
        this.container.peripherals.keyboard.enable();
        this.container.peripherals.keyboard.showIndicator();
        return this.container.peripherals.keyboard.focus();
      } else {
        this.container.peripherals.keyboard.disable();
        return this.container.peripherals.keyboard.hideIndicator();
      }
    };

    Rsc.prototype.refreshMemoryUI = function(interpreter) {
      return interpreter.memory.eachStorageLocation((function(_this) {
        return function(line, location) {
          if (Utils.isNumeric(location.value)) {
            return _this.container.commandList.setFieldValueAtIndex(line, location.value);
          } else {
            return _this.container.commandList.clearFieldValueAtIndex(line);
          }
        };
      })(this));
    };

    Rsc.prototype.refreshExecutionLine = function() {
      return this.container.commandList.indicateExecutionForLine(this.session.programCounter);
    };

    Rsc.prototype.refreshAccumulator = function() {
      return this.container.peripherals.accumulator.setValue(this.session.accumulator);
    };

    Rsc.prototype.resetInterface = function() {
      this.container.commandList.reset();
      return this.container.controls.reset();
    };

    Rsc.prototype.handleError = function(e) {
      switch (e.constructor) {
        case NotExecutableError:
        case NotStorableError:
        case AddressOutOfBoundsError:
          alert(e.message + " Program halted.");
          return this.resetInterface();
        default:
          this.resetInterface();
          throw e;
      }
    };

    return Rsc;

  })();

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.Rsc = Rsc;

  TestRunner = (function() {
    function TestRunner(programText) {}

    return TestRunner;

  })();

  Command = (function() {
    Command.parse = function(text) {
      var tokens;
      tokens = this.tokenize(this.sanitize(text));
      return new Command(tokens[0], tokens[1]);
    };

    Command.sanitize = function(text) {
      return text.trim().replace(/\s+/g, ' ').toUpperCase();
    };

    Command.tokenize = function(text) {
      return text.split(' ');
    };

    function Command(command1, arg1) {
      this.command = command1;
      this.properties = Commands.get(this.command);
      if (arg1 != null) {
        this.arg1 = parseFloat(arg1);
      }
      this.resetErrors();
    }

    Command.prototype.isValid = function() {
      this.setErrors();
      return this.errors.length === 0;
    };

    Command.prototype.resetErrors = function() {
      return this.errors = [];
    };

    Command.prototype.setErrors = function() {
      this.resetErrors();
      return this.checkCommandExists() && this.checkValidArity() && this.checkArgNumericality();
    };

    Command.prototype.checkCommandExists = function() {
      if (this.properties == null) {
        this.errors.push("'" + this.command + "' is not a valid command.");
        return false;
      } else {
        return true;
      }
    };

    Command.prototype.checkValidArity = function() {
      if (!this.hasValidArity()) {
        this.errors.push(this.properties.errors.wrongArity);
        return false;
      } else {
        return true;
      }
    };

    Command.prototype.checkArgNumericality = function() {
      if (this.arity() > 0) {
        if (Utils.isNumeric(this.arg1)) {
          return true;
        } else {
          this.errors.push("The argument following " + this.command + " must be a number.");
          return false;
        }
      } else {
        return true;
      }
    };

    Command.prototype.arity = function() {
      if (this.arg1 != null) {
        return 1;
      } else {
        return 0;
      }
    };

    Command.prototype.hasValidArity = function() {
      return this.properties.arity === this.arity();
    };

    return Command;

  })();

  CommandList = (function() {
    function CommandList() {}

    CommandList.parse = function(text) {
      var chunk, chunks, j, len, ref, results;
      if (chunk.trim().length > 0) {
        ref = text.split("\n");
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          chunk = ref[j];
          results.push(chunks = Command.parse(chunk.trim()));
        }
        return results;
      }
    };

    return CommandList;

  })();

  Commands = (function() {
    function Commands() {}

    Commands.all = {
      LDA: {
        arity: 1,
        errors: {
          wrongArity: 'LDA must be given a location to load from.'
        }
      },
      LDC: {
        arity: 1,
        errors: {
          wrongArity: 'LDC must be given a constant value to load.'
        }
      },
      STA: {
        arity: 1,
        errors: {
          wrongArity: 'STA must be given a location to store the ' + 'accumulator value in.'
        }
      },
      INP: {
        arity: 1,
        errors: {
          wrongArity: 'INP must be given a location to store the ' + 'user inputted value.'
        }
      },
      OUT: {
        arity: 1,
        errors: {
          wrongArity: 'OUT must be given the location of the value ' + 'to print.'
        }
      },
      ADC: {
        arity: 1,
        errors: {
          wrongArity: 'ADC must be given a constant value to add to ' + 'the accumulator.'
        }
      },
      ADD: {
        arity: 1,
        errors: {
          wrongArity: 'ADD must be given the location of the value ' + 'to add to the accumulator.'
        }
      },
      SUB: {
        arity: 1,
        errors: {
          wrongArity: 'SUB must be given the location of the value ' + 'to subtract from the accumulator.'
        }
      },
      MUL: {
        arity: 1,
        errors: {
          wrongArity: 'MUL must be given the location of the value to ' + 'multiply the accumulator by.'
        }
      },
      DIV: {
        arity: 1,
        errors: {
          wrongArity: 'DIV must be given the location of the value to ' + 'divide from accumulator by.'
        }
      },
      BRU: {
        arity: 1,
        errors: {
          wrongArity: 'BRU must be given the location to branch to.'
        }
      },
      BNA: {
        arity: 1,
        errors: {
          wrongArity: 'BNA must be given the location to branch to.'
        }
      },
      BPA: {
        arity: 1,
        errors: {
          wrongArity: 'BPA must be given the location to branch to.'
        }
      },
      BZA: {
        arity: 1,
        errors: {
          wrongArity: 'BZA must be given the location to branch to.'
        }
      },
      STP: {
        arity: 0,
        errors: {
          wrongArity: 'STP does not accept any arguments.'
        }
      }
    };

    Commands.get = function(name) {
      return this.all[name];
    };

    return Commands;

  })();

  Events = (function() {
    function Events() {}

    Events.fireIfDefined = function() {
      var args, callbackName, obj;
      obj = arguments[0], callbackName = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      if (obj[callbackName] != null) {
        return obj[callbackName].apply(this, args);
      }
    };

    return Events;

  })();

  Utils = (function() {
    function Utils() {}

    Utils.isNumeric = function(num) {
      return !isNaN(parseFloat(num)) && isFinite(num);
    };

    return Utils;

  })();

  AccumulatorView = (function() {
    AccumulatorView.template = '<div class=\'rsc-peripheral-accumulator rsc-computer-font\'>\n  Accumulator: <span class=\'rsc-accumulator-value\'></span>\n</div>';

    function AccumulatorView() {
      this.elem = $(AccumulatorView.template);
      this.valueField = $('.rsc-accumulator-value', this.elem);
    }

    AccumulatorView.prototype.setValue = function(val) {
      return this.valueField.text(val.toFixed(1));
    };

    AccumulatorView.prototype.getValue = function() {
      if (Utils.isNumeric(this.valueField.text())) {
        return parseFloat(this.valueField.text());
      }
    };

    return AccumulatorView;

  })();

  Button = (function() {
    Button.template = '<input type=\'button\' class=\'rsc-button\' />';

    function Button(text, options) {
      if (options == null) {
        options = {};
      }
      this.elem = $(Button.template);
      this.elem.val(text);
      if (options.classes != null) {
        this.elem.addClass(options.classes.join(' '));
      }
      if ((options.enabled != null) && !options.enabled) {
        this.elem.prop('disabled', true);
      }
      this.elem.click((function(_this) {
        return function() {
          return Events.fireIfDefined(_this, 'onClickCallback');
        };
      })(this));
    }

    Button.prototype.onClick = function(callback) {
      return this.onClickCallback = callback;
    };

    Button.prototype.enable = function() {
      return this.elem.prop('disabled', false);
    };

    Button.prototype.disable = function() {
      return this.elem.prop('disabled', true);
    };

    return Button;

  })();

  CommandListItemView = (function() {
    CommandListItemView.template = '<div class=\'rsc-command-list-item\'>\n  <div class=\'rsc-line-number rsc-computer-font\'></div>\n  <input type=\'text\' maxlength=\'7\' class=\'rsc-input-field rsc-computer-font\' />\n  <div class=\'rsc-indicator\'></div>\n</div>';

    function CommandListItemView(command) {
      this.elem = $(CommandListItemView.template);
      this.lineNumber = $('.rsc-line-number', this.elem);
      this.indicator = $('.rsc-indicator', this.elem);
      this.inputField = $("input[type='text']", this.elem);
      this.command = command;
      this.inputField.blur((function(_this) {
        return function() {
          return _this.validate();
        };
      })(this));
      this.inputField.keydown((function(_this) {
        return function(e) {
          if (_this.indicatesNextFieldHighlight(e)) {
            return Events.fireIfDefined(_this, 'onHighlightNextFieldCallback');
          } else if (_this.indicatesPreviousFieldHighlight(e)) {
            return Events.fireIfDefined(_this, 'onHighlightPreviousFieldCallback');
          }
        };
      })(this));
    }

    CommandListItemView.prototype.showExecutionIndicator = function() {
      return this.elem.addClass('info');
    };

    CommandListItemView.prototype.showErrorIndicator = function() {
      return this.elem.addClass('error');
    };

    CommandListItemView.prototype.hideIndicator = function() {
      return this.elem.removeClass('error info');
    };

    CommandListItemView.prototype.disable = function() {
      return this.inputField.prop('disabled', true);
    };

    CommandListItemView.prototype.enable = function() {
      return this.inputField.prop('disabled', false);
    };

    CommandListItemView.prototype.clear = function() {
      this.inputField.val('');
      this.command = null;
      return this.hideIndicator();
    };

    CommandListItemView.prototype.focus = function() {
      this.inputField.focus();
      return this.inputField.select();
    };

    CommandListItemView.prototype.validate = function() {
      var val, valid;
      val = this.inputField.val();
      valid = true;
      if (val.trim() === '') {
        this.command = null;
      } else {
        this.command = Command.parse(this.inputField.val());
        valid = this.command.isValid();
      }
      if (valid) {
        this.hideIndicator();
      } else {
        this.showErrorIndicator();
      }
      return Events.fireIfDefined(this, 'onValidateFinishedCallback');
    };

    CommandListItemView.prototype.onHighlightNextField = function(callback) {
      return this.onHighlightNextFieldCallback = callback;
    };

    CommandListItemView.prototype.onHighlightPreviousField = function(callback) {
      return this.onHighlightPreviousFieldCallback = callback;
    };

    CommandListItemView.prototype.onValidateFinished = function(callback) {
      return this.onValidateFinishedCallback = callback;
    };

    CommandListItemView.prototype.indicatesNextFieldHighlight = function(e) {
      return e.keyCode === 13 || e.keyCode === 40;
    };

    CommandListItemView.prototype.indicatesPreviousFieldHighlight = function(e) {
      return e.keyCode === 38;
    };

    return CommandListItemView;

  })();

  CommandListView = (function() {
    CommandListView.template = '<div class=\'rsc-command-list\'>\n  <h4 class=\'rsc-computer-font\'>Command List</h4>\n  <div class=\'rsc-commands-container\'></div>\n  <div class=\'rsc-error-list\'></div>\n</div>';

    CommandListView.columnTemplate = '<div class=\'rsc-command-list-column\'></div>';

    CommandListView.errorMessageTemplate = '<p>\n  <u><strong>Line %{lineNumber}</strong></u>:\n  <span class=\'rsc-computer-font\'>%{errorMessage}</span>\n</p>';

    function CommandListView(options) {
      var col, colElem, commandList, item, row, rowElems;
      if (options == null) {
        options = {};
      }
      this.elem = $(CommandListView.template);
      this.errorList = $('.rsc-error-list', this.elem);
      this.numColumns = options.numColumns || Rsc.defaultNumColumns;
      this.numRows = options.numRows || Rsc.defaultNumRows;
      commandList = $('.rsc-commands-container', this.elem);
      this.columns = (function() {
        var j, ref, results;
        results = [];
        for (col = j = 0, ref = this.numColumns; 0 <= ref ? j < ref : j > ref; col = 0 <= ref ? ++j : --j) {
          colElem = $(CommandListView.columnTemplate);
          rowElems = (function() {
            var k, ref1, results1;
            results1 = [];
            for (row = k = 0, ref1 = this.numRows; 0 <= ref1 ? k < ref1 : k > ref1; row = 0 <= ref1 ? ++k : --k) {
              item = this.createListItemAt(col, row);
              item.lineNumber.text(this.getLineNumber(col, row).toString());
              colElem.append(item.elem);
              results1.push(item);
            }
            return results1;
          }).call(this);
          commandList.append(colElem);
          results.push(rowElems);
        }
        return results;
      }).call(this);
    }

    CommandListView.prototype.createListItemAt = function(col, row) {
      var item;
      item = new CommandListItemView();
      item.onHighlightNextField((function(_this) {
        return function() {
          return _this.getField(_this.nextColumn(col, row), _this.nextRow(col, row)).focus();
        };
      })(this));
      item.onHighlightPreviousField((function(_this) {
        return function() {
          return _this.getField(_this.prevColumn(col, row), _this.prevRow(col, row)).focus();
        };
      })(this));
      item.onValidateFinished((function(_this) {
        return function() {
          return _this.updateErrorList();
        };
      })(this));
      return item;
    };

    CommandListView.prototype.getErrors = function() {
      var errors;
      errors = [];
      this.eachField((function(_this) {
        return function(col, row, field) {
          if (field.command != null) {
            return errors += field.command.errors;
          }
        };
      })(this));
      return errors;
    };

    CommandListView.prototype.updateErrorList = function() {
      this.errorList.html('');
      return this.eachField((function(_this) {
        return function(col, row, field) {
          var error, j, len, lineNumber, ref, results;
          if (field.command != null) {
            ref = field.command.errors;
            results = [];
            for (j = 0, len = ref.length; j < len; j++) {
              error = ref[j];
              lineNumber = _this.getLineNumber(col, row);
              results.push(_this.errorList.append(CommandListView.errorMessageTemplate.replace('%{lineNumber}', lineNumber).replace('%{errorMessage}', error)));
            }
            return results;
          }
        };
      })(this));
    };

    CommandListView.prototype.indicateExecutionForLine = function(line) {
      return this.eachField((function(_this) {
        return function(col, row, field) {
          if (_this.getFieldIndex(col, row) === line) {
            return field.showExecutionIndicator();
          } else {
            return field.hideIndicator();
          }
        };
      })(this));
    };

    CommandListView.prototype.hideExecutionIndicator = function() {
      return this.eachField((function(_this) {
        return function(col, row, field) {
          return field.hideIndicator();
        };
      })(this));
    };

    CommandListView.prototype.prevColumn = function(col, row) {
      if (row === 0) {
        if (col > 0) {
          return col - 1;
        }
      }
      return col;
    };

    CommandListView.prototype.prevRow = function(col, row) {
      if (row === 0) {
        if (col > 0) {
          return this.numRows - 1;
        }
      } else {
        return row - 1;
      }
      return row;
    };

    CommandListView.prototype.nextColumn = function(col, row) {
      if (row >= this.numRows - 1) {
        if (col < this.numColumns - 1) {
          return col + 1;
        }
      }
      return col;
    };

    CommandListView.prototype.nextRow = function(col, row) {
      if (row >= this.numRows - 1) {
        if (col < this.numColumns - 1) {
          return 0;
        }
      } else {
        return row + 1;
      }
      return row;
    };

    CommandListView.prototype.getLineNumber = function(col, row) {
      return this.getFieldIndex(col, row) + 1;
    };

    CommandListView.prototype.getFieldIndex = function(col, row) {
      return (col * this.numRows) + row;
    };

    CommandListView.prototype.eachField = function(callback) {
      var col, colObj, j, len, ref, results, row, rowObj;
      ref = this.columns;
      results = [];
      for (col = j = 0, len = ref.length; j < len; col = ++j) {
        colObj = ref[col];
        results.push((function() {
          var k, len1, results1;
          results1 = [];
          for (row = k = 0, len1 = colObj.length; k < len1; row = ++k) {
            rowObj = colObj[row];
            results1.push(callback(col, row, this.getField(col, row)));
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    CommandListView.prototype.getCommands = function() {
      var commands;
      commands = [];
      this.eachField(function(col, row, field) {
        return commands.push(field.command);
      });
      return commands;
    };

    CommandListView.prototype.getField = function(col, row) {
      return this.columns[col][row];
    };

    CommandListView.prototype.getFieldAtIndex = function(index) {
      var col, row;
      col = Math.floor(index / this.numRows);
      row = index % this.numRows;
      return this.getField(col, row);
    };

    CommandListView.prototype.setFieldValueAtIndex = function(index, value) {
      return this.getFieldAtIndex(index).inputField.val(value.toFixed(1));
    };

    CommandListView.prototype.clearFieldValueAtIndex = function(index) {
      return this.getFieldAtIndex(index).inputField.val('');
    };

    CommandListView.prototype.reset = function() {
      this.hideExecutionIndicator();
      return this.enable();
    };

    CommandListView.prototype.clear = function() {
      this.eachField(function(col, row, field) {
        return field.clear();
      });
      return this.updateErrorList();
    };

    CommandListView.prototype.disable = function() {
      return this.eachField(function(col, row, field) {
        return field.disable();
      });
    };

    CommandListView.prototype.enable = function() {
      return this.eachField(function(col, row, field) {
        return field.enable();
      });
    };

    return CommandListView;

  })();

  ContainerView = (function() {
    ContainerView.template = '<div class=\'rsc-container\'>\n  <div class=\'rsc-command-list-container\'></div>\n  <div class=\'rsc-peripherals-container\'></div>\n  <div class=\'rsc-controls-container\'></div>\n</div>';

    function ContainerView(options) {
      if (options == null) {
        options = {};
      }
      this.elem = $(ContainerView.template);
      this.commandListContainer = $('.rsc-command-list-container', this.elem);
      this.peripheralsContainer = $('.rsc-peripherals-container', this.elem);
      this.controlsContainer = $('.rsc-controls-container', this.elem);
      this.commandList = new CommandListView(options);
      this.commandListContainer.append(this.commandList.elem);
      this.peripherals = new PeripheralsView();
      this.peripheralsContainer.append(this.peripherals.elem);
      this.controls = new ControlsView();
      this.controlsContainer.append(this.controls.elem);
    }

    ContainerView.prototype.reset = function() {
      this.commandList.reset();
      this.controls.reset();
      return this.peripherals.reset();
    };

    return ContainerView;

  })();

  ControlsView = (function() {
    ControlsView.template = '<div class=\'rsc-controls\'>\n  <h4 class=\'rsc-computer-font\'>Controls</h4>\n</div>';

    function ControlsView() {
      this.elem = $(ControlsView.template);
      this.runProgramButton = new Button('Run Program', {
        classes: ['rsc-control-run']
      });
      this.stepButton = new Button('Step', {
        classes: ['rsc-control-step'],
        enabled: false
      });
      this.stopButton = new Button('Stop', {
        classes: ['rsc-control-step'],
        enabled: false
      });
      this.clearMemButton = new Button('Clear Mem', {
        classes: ['rsc-control-clear-mem']
      });
      this.elem.append(this.runProgramButton.elem);
      this.elem.append(this.stepButton.elem);
      this.elem.append(this.stopButton.elem);
      this.elem.append(this.clearMemButton.elem);
      this.runProgramButton.onClick((function(_this) {
        return function() {
          return Events.fireIfDefined(_this, 'onRunProgramButtonClickedCallback');
        };
      })(this));
      this.stepButton.onClick((function(_this) {
        return function() {
          return Events.fireIfDefined(_this, 'onStepButtonClickedCallback');
        };
      })(this));
      this.stopButton.onClick((function(_this) {
        return function() {
          return Events.fireIfDefined(_this, 'onStopButtonClickedCallback');
        };
      })(this));
      this.clearMemButton.onClick((function(_this) {
        return function() {
          return Events.fireIfDefined(_this, 'onClearMemButtonClickedCallback');
        };
      })(this));
    }

    ControlsView.prototype.onRunProgramButtonClicked = function(callback) {
      return this.onRunProgramButtonClickedCallback = callback;
    };

    ControlsView.prototype.onStepButtonClicked = function(callback) {
      return this.onStepButtonClickedCallback = callback;
    };

    ControlsView.prototype.onStopButtonClicked = function(callback) {
      return this.onStopButtonClickedCallback = callback;
    };

    ControlsView.prototype.onClearMemButtonClicked = function(callback) {
      return this.onClearMemButtonClickedCallback = callback;
    };

    ControlsView.prototype.reset = function() {
      this.runProgramButton.enable();
      this.clearMemButton.enable();
      this.stepButton.disable();
      return this.stopButton.disable();
    };

    return ControlsView;

  })();

  KeyboardView = (function() {
    KeyboardView.template = '<div class=\'rsc-peripheral-keyboard\'>\n  <div class=\'rsc-keyboard-image\'></div>\n  <input type=\'text\' class=\'rsc-input-field rsc-computer-font\' />\n  <div class=\'rsc-computer-font rsc-error\' style=\'display: none\'>\n    × Input must be a number!\n  </div>\n</div>';

    function KeyboardView() {
      this.elem = $(KeyboardView.template);
      this.inputField = $("input[type='text']", this.elem);
      this.errorMessage = $('.rsc-error', this.elem);
      this.inputField.keydown((function(_this) {
        return function(e) {
          if (e.keyCode === 13) {
            if (Utils.isNumeric(_this.inputField.val())) {
              Events.fireIfDefined(_this, 'onInputReceivedCallback', parseFloat(_this.inputField.val()));
              _this.reset();
              return _this.errorMessage.hide();
            } else {
              return _this.errorMessage.show();
            }
          }
        };
      })(this));
    }

    KeyboardView.prototype.onInputReceived = function(callback) {
      return this.onInputReceivedCallback = callback;
    };

    KeyboardView.prototype.enable = function() {
      return this.inputField.prop('disabled', false);
    };

    KeyboardView.prototype.disable = function() {
      return this.inputField.prop('disabled', true);
    };

    KeyboardView.prototype.focus = function() {
      return this.inputField.focus();
    };

    KeyboardView.prototype.reset = function() {
      this.errorMessage.hide();
      this.hideIndicator();
      return this.inputField.val('');
    };

    KeyboardView.prototype.showIndicator = function(animate) {
      var cycles, id;
      if (animate == null) {
        animate = true;
      }
      if (animate) {
        cycles = 0;
        return id = setInterval(((function(_this) {
          return function() {
            if (_this.elem.hasClass('info')) {
              _this.elem.removeClass('info');
            } else {
              _this.elem.addClass('info');
            }
            cycles += 1;
            if (cycles === 5) {
              clearInterval(id);
              return _this.elem.addClass('info');
            }
          };
        })(this)), 100);
      } else {
        return this.elem.addClass('info');
      }
    };

    KeyboardView.prototype.hideIndicator = function() {
      return this.elem.removeClass('info');
    };

    return KeyboardView;

  })();

  MonitorView = (function() {
    MonitorView.template = '<div class=\'rsc-peripheral-monitor\'>\n  <div class=\'rsc-monitor-image\'>\n    <div class=\'rsc-monitor-output-field rsc-computer-font\'></div>\n  </div>\n</div>';

    function MonitorView() {
      this.elem = $(MonitorView.template);
      this.outputField = $('.rsc-monitor-output-field', this.elem);
    }

    MonitorView.prototype.displayValue = function(value) {
      if (Utils.isNumeric(value)) {
        return this.outputField.text(value.toFixed(1));
      }
    };

    MonitorView.prototype.reset = function() {
      return this.outputField.text('');
    };

    return MonitorView;

  })();

  PeripheralsView = (function() {
    PeripheralsView.template = '<div class=\'rsc-peripherals\'>\n  <h4 class=\'rsc-computer-font\'>Peripherals</h4>\n</div>';

    function PeripheralsView() {
      this.elem = $(PeripheralsView.template);
      this.accumulator = new AccumulatorView();
      this.elem.append(this.accumulator.elem);
      this.monitor = new MonitorView();
      this.elem.append(this.monitor.elem);
      this.keyboard = new KeyboardView();
      this.elem.append(this.keyboard.elem);
    }

    PeripheralsView.prototype.reset = function() {
      this.monitor.reset();
      return this.keyboard.reset();
    };

    return PeripheralsView;

  })();

}).call(this);
