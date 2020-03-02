class Input {
  final List addresses;
  final int outputIndex;
  final int outputValue;
  final String prevHash;
  final String script;
  final String scriptType;
  final int sequence;

  Input(
      {this.addresses,
      this.outputIndex,
      this.outputValue,
      this.prevHash,
      this.script,
      this.scriptType,
      this.sequence});

  factory Input.fromJson(Map<String, dynamic> json) {
    return Input(
        addresses: json['addresses'],
        outputIndex: json['output_index'],
        outputValue: json['output_value'],
        prevHash: json['prev_hash'],
        script: json['script'],
        scriptType: json['script_type'],
        sequence: json['sequence']);
  }
}
